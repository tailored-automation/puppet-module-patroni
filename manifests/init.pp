# @summary Manages a Patroni instance
#
class patroni (

  # Global Settings
  String $scope,
  String $namespace = '/service/',
  String $hostname = $facts['networking']['hostname'],

  # Bootstrap Settings
  Integer $dcs_loop_wait = 10,
  Integer $dcs_ttl = 30,
  Integer $dcs_retry_timeout = 10,
  Integer $dcs_maximum_lag_on_failover = 1048576,
  Integer $dcs_master_start_timeout = 300,
  Boolean $dcs_synchronous_mode = false,
  Boolean $dcs_synchronous_mode_strict = false,
  Boolean $dcs_postgresql_use_pg_rewind = true,
  Boolean $dcs_postgresql_use_slots = true,
  Hash $dcs_postgresql_recovery_conf = {},
  Hash $dcs_postgresql_parameters = {},
  String[1] $bootstrap_method = 'initdb',
  Boolean $initdb_data_checksums = true,
  String $initdb_encoding = 'UTF8',
  String $initdb_locale = 'en_US.utf8',
  Array[String] $bootstrap_pg_hba = [
    'host all all 0.0.0.0/0 md5',
    'host replication rep_user 0.0.0.0/0 md5',
  ],
  Hash $bootstrap_users = {},
  Variant[Undef,String] $bootstrap_post_bootstrap = undef,
  Variant[Undef,String] $bootstrap_post_init = undef,

  # PostgreSQL Settings
  String $superuser_username = 'postgres',
  String $superuser_password = 'changeme',
  String $replication_username = 'rep_user',
  String $replication_password = 'changeme',
  Variant[Undef,String] $callback_on_reload = undef,
  Variant[Undef,String] $callback_on_restart = undef,
  Variant[Undef,String] $callback_on_role_change = undef,
  Variant[Undef,String] $callback_on_start = undef,
  Variant[Undef,String] $callback_on_stop = undef,
  String $pgsql_connect_address = "${facts['networking']['fqdn']}:5432",
  Array[String] $pgsql_create_replica_methods = ['basebackup'],
  Stdlib::Unixpath $pgsql_data_dir = '/var/lib/pgsql/data',
  Variant[Undef,String] $pgsql_config_dir = undef,
  Variant[Undef,String] $pgsql_bin_dir = '',
  String $pgsql_listen = '0.0.0.0:5432',
  Boolean $pgsql_use_unix_socket = false,
  String $pgsql_pgpass_path = '/tmp/pgpass0',
  Hash $pgsql_recovery_conf = {},
  Variant[Undef,String]  $pgsql_custom_conf = undef,
  Hash $pgsql_parameters = {},
  Array[String] $pgsql_pg_hba = [],
  Integer $pgsql_pg_ctl_timeout = 60,
  Boolean $pgsql_use_pg_rewind = true,
  Boolean $hiera_merge_pgsql_parameters = false,
  Boolean $pgsql_remove_data_directory_on_rewind_failure = false,
  Array[Hash] $pgsql_replica_method = [],

  # Consul Settings
  Boolean $use_consul = false,
  String $consul_host = 'localhost',
  Variant[Undef,String] $consul_url = undef,
  Stdlib::Port $consul_port = 8500,
  Enum['http','https'] $consul_scheme = 'http',
  Variant[Undef,String] $consul_token = undef,
  Boolean $consul_verify = false,
  Optional[Boolean] $consul_register_service = undef,
  Optional[String] $consul_service_check_interval = undef,
  Optional[Enum['default', 'consistent', 'stale']] $consul_consistency = undef,
  Variant[Undef,String] $consul_cacert = undef,
  Variant[Undef,String] $consul_cert = undef,
  Variant[Undef,String] $consul_key = undef,
  Variant[Undef,String] $consul_dc = undef,
  Variant[Undef,String] $consul_checks = undef,

  # Etcd Settings
  Boolean $use_etcd = false,
  String $etcd_host = '127.0.0.1:2379',
  Array[String] $etcd_hosts = [],
  Variant[Undef,String] $etcd_url = undef,
  Variant[Undef,String] $etcd_proxyurl = undef,
  Variant[Undef,String] $etcd_srv = undef,
  Enum['http','https'] $etcd_protocol = 'http',
  Variant[Undef,String] $etcd_username = undef,
  Variant[Undef,String] $etcd_password = undef,
  Variant[Undef,String] $etcd_cacert = undef,
  Variant[Undef,String] $etcd_cert = undef,
  Variant[Undef,String] $etcd_key = undef,

  # Exhibitor Settings
  Boolean $use_exhibitor = false,
  Array[String] $exhibitor_hosts = [],
  Integer $exhibitor_poll_interval = 10,
  Integer $exhibitor_port = 8080,

  # Kubernetes Settings
  Boolean $use_kubernetes = false,
  String $kubernetes_namespace = 'default',
  Hash $kubernetes_labels = {},
  Variant[Undef,String] $kubernetes_scope_label = undef,
  Variant[Undef,String] $kubernetes_role_label = undef,
  Boolean $kubernetes_use_endpoints = false,
  Variant[Undef,String] $kubernetes_pod_ip = undef,
  Variant[Undef,String] $kubernetes_ports = undef,

  # REST API Settings
  String $restapi_connect_address = "${facts['networking']['fqdn']}:8008",
  String $restapi_listen = '0.0.0.0:8008',
  Variant[Undef,String] $restapi_username = undef,
  Variant[Undef,String] $restapi_password = undef,
  Variant[Undef,String] $restapi_certfile = undef,
  Variant[Undef,String] $restapi_keyfile = undef,
  Optional[String] $restapi_cafile = undef,
  Optional[Enum['none','optional','required']] $restapi_verify_client = undef,

  # ZooKeeper Settings
  Boolean $use_zookeeper = false,
  Array[String] $zookeeper_hosts = [],

  # Watchdog Settings
  Enum['off','automatic','required'] $watchdog_mode = 'automatic',
  String $watchdog_device = '/dev/watchdog',
  Integer $watchdog_safety_margin = 5,

  # Module Specific Settings
  String $package_name = 'patroni',
  String $version = 'present',
  Array $install_dependencies = [],
  Boolean $manage_python = true,
  Enum['package','pip'] $install_method = 'pip',
  Stdlib::Absolutepath $install_dir = '/opt/app/patroni',
  String $python_class_version = '36',
  String $python_venv_version = '3.6',
  String $config_path = '/opt/app/patroni/etc/postgresql.yml',
  String $config_owner = 'postgres',
  String $config_group = 'postgres',
  String $config_mode = '0600',
  String $service_name = 'patroni',
  String $service_ensure = 'running',
  Boolean $service_enable = true,
) {

  if $install_method == 'pip' {
    if $manage_python {
      class { 'python':
        version    => $python_class_version,
        dev        => 'present',
        virtualenv => 'present',
      }
    }
    ensure_packages($install_dependencies, {'before' => Python::Pip['patroni']})
    exec { "/bin/mkdir -p ${install_dir}":
      creates => $install_dir,
      before  => Python::Virtualenv['patroni'],
    }
    python::virtualenv { 'patroni':
      version    => $python_venv_version,
      venv_dir   => $install_dir,
      virtualenv => 'virtualenv-3',
      systempkgs => true,
      distribute => false,
    }
    python::pip { 'patroni':
      ensure     => $version,
      virtualenv => $install_dir,
      before     => File['patroni_config'],
    }
    $dependency_params = {
      'virtualenv' => $install_dir,
      'before'     => Python::Pip['patroni'],
    }
    python::pip { 'psycopg2': * => $dependency_params }
    if $use_consul {
      python::pip { 'python-consul': * => $dependency_params }
    }
    if $use_etcd {
      python::pip { 'python-etcd': * => $dependency_params }
    }
    if $use_exhibitor or $use_zookeeper {
      python::pip { 'kazoo': * => $dependency_params }
    }
  } else {
    package { 'patroni':
      ensure => $version,
      name   => $package_name,
      before => File['patroni_config'],
    }
  }

  if $install_method == 'pip' {
    $config_dir = dirname($config_path)
    file { $config_dir:
      ensure => 'directory',
      owner  => 'postgres',
      group  => 'postgres',
      mode   => '0755',
    }
  }
  file { 'patroni_config':
    ensure  => 'file',
    path    => $config_path,
    owner   => $config_owner,
    group   => $config_group,
    mode    => $config_mode,
    content => template('patroni/postgresql.yml.erb'),
    notify  => Service['patroni'],
  }

  if $install_method == 'pip' {
    systemd::unit_file { 'patroni.service':
      content => template('patroni/patroni.service.erb'),
      notify  => Service['patroni'],
    }

    if versioncmp($facts['puppetversion'],'6.1.0') < 0 {
      # Puppet 5 does not execute 'systemctl daemon-reload' automatically (https://tickets.puppetlabs.com/browse/PUP-3483)
      # and camptocamp/systemd only creates this relationship when managing the service
      Class['systemd::systemctl::daemon_reload'] -> Service['patroni']
    }
  }

  service { 'patroni':
    ensure => $service_ensure,
    name   => $service_name,
    enable => $service_enable,
  }
}
