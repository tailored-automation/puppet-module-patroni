require 'spec_helper_acceptance'

describe 'patroni class:' do
  patroni1 = hosts_as('patroni1')[0]
  patroni2 = hosts_as('patroni2')[0]
  context 'default parameters' do
    it 'runs successfully' do
      etcd = <<-EOS
      class { 'etcd':
        config => {
          'data-dir'                    => '/var/lib/etcd',
          'name'                        => $facts['networking']['hostname'],
          'initial-advertise-peer-urls' => "http://${facts['networking']['hostname']}:2380",
          'listen-peer-urls'            => 'http://0.0.0.0:2380',
          'listen-client-urls'          => 'http://0.0.0.0:2379',
          'advertise-client-urls'       => "http://${facts['networking']['hostname']}:2379",
          'initial-cluster-token'       => 'etcd-cluster-1',
          'initial-cluster'             => 'patroni1=http://patroni1:2380,patroni2=http://patroni2:2380',
          'initial-cluster-state'       => 'new',
          'enable-v2'                   => true,
        },
      }
      EOS
      pp = <<-EOS
      class { 'postgresql::globals':
        encoding            => 'UTF-8',
        locale              => 'en_US.UTF-8',
        manage_package_repo => true,
        version             => '9.6',
      }
      include postgresql::params
      package { [$postgresql::params::server_package_name, $postgresql::params::contrib_package_name]:
        ensure => present,
      }

      class { 'patroni':
        scope                   => 'cluster',
        use_etcd                => true,
        pgsql_connect_address   => "${facts['networking']['fqdn']}:5432",
        restapi_connect_address => "${facts['networking']['fqdn']}:8008",
        pgsql_bin_dir           => $postgresql::params::bindir,
        pgsql_data_dir          => $postgresql::params::datadir,
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
      }
      EOS
      apply_manifest_on(patroni1, etcd)
      apply_manifest_on(patroni2, etcd, catch_failures: true)
      apply_manifest_on(patroni1, etcd, catch_failures: true)
      apply_manifest_on(patroni1, pp, catch_failures: true)
      apply_manifest_on(patroni1, pp, catch_changes: true)
      apply_manifest_on(patroni2, pp, catch_failures: true)
      apply_manifest_on(patroni2, pp, catch_changes: true)
    end

    describe port(8008), :node => patroni1 do
      it { should be_listening }
    end
    describe port(8008), :node => patroni2 do
      it { should be_listening }
    end
    describe service('patroni'), node: patroni1 do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
    describe service('patroni'), node: patroni2 do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
