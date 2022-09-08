class { 'postgresql::globals':
  encoding            => 'UTF-8',
  locale              => 'en_US.UTF-8',
  manage_package_repo => true,
  version             => '9.6',
}
package { ['postgresql96-server','postgresql96-contrib']:
  ensure => present,
}

$etcd_cluster_hosts = {
  'patroni1' => 'patroni1.example.com',
  'patroni2' => 'patroni2.example.com',
  'patroni3' => 'patroni3.example.com',
}
$initial_cluster = $etcd_cluster_hosts.map |$name, $hostname| {
  "${name}=http://${hostname}:2380"
}
class { 'etcd':
  config => {
    'data-dir'                    => '/var/lib/etcd',
    'name'                        => $facts['networking']['hostname'],
    'initial-advertise-peer-urls' => "http://${facts['networking']['fqdn']}:2380",
    'listen-peer-urls'            => 'http://0.0.0.0:2380',
    'listen-client-urls'          => 'http://0.0.0.0:2379',
    'advertise-client-urls'       => "http://${facts['networking']['fqdn']}:2379",
    'initial-cluster-token'       => 'etcd-cluster-1',
    'initial-cluster'             => join($initial_cluster, ','),
    'initial-cluster-state'       => 'new',
    'enable-v2'                   => true,
  },
}
class { 'patroni':
  scope                   => 'cluster',
  use_etcd                => true,
  etcd_host               => $facts['networking']['fqdn'],
  etcd_protocol           => 'http',
  pgsql_connect_address   => "${facts['networking']['fqdn']}:5432",
  restapi_connect_address => "${facts['networking']['fqdn']}:8008",
  pgsql_bin_dir           => '/usr/pgsql-9.6/bin',
  pgsql_data_dir          => '/var/lib/pgsql/9.6/data',
  pgsql_pgpass_path       => '/var/lib/pgsql/pgpass',
  pgsql_parameters        => {
    'max_connections' => 5000,
  },
  bootstrap_pg_hba        => [
    'local all postgres ident',
    'host all all 0.0.0.0/0 md5',
    'host replication repl 0.0.0.0/0 md5',
  ],
  pgsql_pg_hba            => [
    'local all postgres ident',
    'host all all 0.0.0.0/0 md5',
    'host replication repl 0.0.0.0/0 md5',
  ],
  superuser_username      => 'postgres',
  superuser_password      => 'postgrespassword',
  replication_username    => 'repl',
  replication_password    => 'replpassword',
}
