# @summary Manages a Patroni instance
#
# @param scope
#   Refer to Patroni Global `scope` setting
# @param namespace
#   Refer to Patroni Global `namespace` setting
# @param hostname
#   Refer to Patroni Global `name` setting
# @param dcs_loop_wait
#   Refer to Patroni Dynamic Configuration Settings `loop_wait` setting
# @param dcs_ttl
#   Refer to Patroni Dynamic Configuration Settings `ttl` setting
# @param dcs_retry_timeout
#   Refer to Patroni Dynamic Configuration Settings `retry_timeout` setting
# @param dcs_maximum_lag_on_failover
#   Refer to Patroni Dynamic Configuration Settings `maximum_lag_on_failover` setting
# @param dcs_master_start_timeout
#   Refer to Patroni Dynamic Configuration Settings `master_start_timeout` setting
# @param dcs_synchronous_mode
#   Refer to Patroni Dynamic Configuration Settings `synchronous_mode` setting
# @param dcs_synchronous_mode_strict
#   Refer to Patroni Dynamic Configuration Settings `synchronous_mode_strict` setting
# @param dcs_postgresql_use_pg_rewind
#   Refer to Patroni Dynamic Configuration Settings `postgresql_use_pg_rewind` setting
# @param dcs_postgresql_use_slots
#   Refer to Patroni Dynamic Configuration Settings `postgresql_use_slots` setting
# @param dcs_postgresql_recovery_conf
#   Refer to Patroni Dynamic Configuration Settings `postgresql_recovery_conf` setting
# @param dcs_postgresql_parameters
#   Refer to Patroni Dynamic Configuration Settings `postgresql_parameters` setting
# @param bootstrap_method
#   Refer to Bootstrap configuration settings `method` setting
# @param initdb_data_checksums
#   Refer to Bootstrap configuration settings `data-checksums` setting
# @param initdb_encoding
#   Refer to Bootstrap configuration settings `encoding` setting
# @param initdb_locale
#   Refer to Bootstrap configuration settings `locale` setting
# @param bootstrap_pg_hba
#   Refer to Bootstrap configuration settings `pg_hba` setting
# @param bootstrap_users
#   Refer to Bootstrap configuration settings `users` setting
# @param bootstrap_post_bootstrap
#   Refer to Bootstrap configuration settings `post_bootstrap` setting
# @param bootstrap_post_init
#   Refer to Bootstrap configuration settings `post_init` setting
# @param superuser_username
#   Refer to PostgreSQL configuration settings superuser username
# @param superuser_password
#   Refer to PostgreSQL configuration settings superuser password
# @param replication_username
#   Refer to PostgreSQL configuration settings replication username
# @param replication_password
#   Refer to PostgreSQL configuration settings replication password
# @param callback_on_reload
#   Refer to PostgreSQL configuration settings callbacks `on_reload`
# @param callback_on_restart
#   Refer to PostgreSQL configuration settings callbacks `on_restart`
# @param callback_on_role_change
#   Refer to PostgreSQL configuration settings callbacks `on_role_change`
# @param callback_on_start
#   Refer to PostgreSQL configuration settings callbacks `on_start`
# @param callback_on_stop
#   Refer to PostgreSQL configuration settings callbacks `on_stop`
# @param pgsql_connect_address
#   Refer to PostgreSQL configuration settings `connect_address` setting
# @param pgsql_create_replica_methods
#   Refer to PostgreSQL configuration settings `create_replica_methods` setting
# @param pgsql_data_dir
#   Refer to PostgreSQL configuration settings `data_dir` setting
# @param pgsql_config_dir
#   Refer to PostgreSQL configuration settings `config_dir` setting
# @param pgsql_bin_dir
#   Refer to PostgreSQL configuration settings `bin_dir` setting
# @param pgsql_listen
#   Refer to PostgreSQL configuration settings `listen` setting
# @param pgsql_use_unix_socket
#   Refer to PostgreSQL configuration settings `use_unix_socket` setting
# @param pgsql_pgpass_path
#   Refer to PostgreSQL configuration settings `pgpass_path` setting
# @param pgsql_recovery_conf
#   Refer to PostgreSQL configuration settings `recovery_conf` setting
# @param pgsql_custom_conf
#   Refer to PostgreSQL configuration settings `custom_conf` setting
# @param pgsql_parameters
#   Refer to PostgreSQL configuration settings `parameters` setting
# @param pgsql_pg_hba
#   Refer to PostgreSQL configuration settings `pg_hba` setting
# @param pgsql_pg_ctl_timeout
#   Refer to PostgreSQL configuration settings `pg_ctl_timeout` setting
# @param pgsql_use_pg_rewind
#   Refer to PostgreSQL configuration settings `use_pg_rewind` setting
# @param pgsql_remove_data_directory_on_rewind_failure
#   Refer to PostgreSQL configuration settings `remove_data_directory_on_rewind_failure` setting
# @param pgsql_replica_method
#   Refer to PostgreSQL configuration settings `replica_method` setting
# @param use_consul
#   Boolean to use Consul for configuration storage
# @param consul_host
#   Refer to Consul configuration `host` setting
# @param consul_url
#   Refer to Consul configuration `url` setting
# @param consul_port
#   Refer to Consul configuration `port` setting
# @param consul_scheme
#   Refer to Consul configuration `scheme` setting
# @param consul_token
#   Refer to Consul configuration `token` setting
# @param consul_verify
#   Refer to Consul configuration `verify` setting
# @param consul_register_service
#   Refer to Consul configuration `register_service` setting
# @param consul_service_check_interval
#   Refer to Consul configuration `service_check_interval` setting
# @param consul_consistency
#   Refer to Consul configuration `consistency` setting
# @param consul_cacert
#   Refer to Consul configuration `cacert` setting
# @param consul_cert
#   Refer to Consul configuration `cert` setting
# @param consul_key
#   Refer to Consul configuration `key` setting
# @param consul_dc
#   Refer to Consul configuration `dc` setting
# @param consul_checks
#   Refer to Consul configuration `checks` setting
# @param use_etcd
#   Boolean to use Etcd for configuration storage
# @param etcd_host
#   Refer to Etcd configuration `host` setting
# @param etcd_hosts
#   Refer to Etcd configuration `hosts` setting
# @param etcd_url
#   Refer to Etcd configuration `url` setting
# @param etcd_proxyurl
#   Refer to Etcd configuration `proxy` setting
# @param etcd_srv
#   Refer to Etcd configuration `srv` setting
# @param etcd_protocol
#   Refer to Etcd configuration `protocol` setting
# @param etcd_username
#   Refer to Etcd configuration `username` setting
# @param etcd_password
#   Refer to Etcd configuration `password` setting
# @param etcd_cacert
#   Refer to Etcd configuration `cacert` setting
# @param etcd_cert
#   Refer to Etcd configuration `cert` setting
# @param etcd_key
#   Refer to Etcd configuration `key` setting
# @param use_exhibitor
#   Boolean to use Exhibitor configuration storage
# @param exhibitor_hosts
#   Refer to Exhibitor configuration `hosts` setting
# @param exhibitor_poll_interval
#   Refer to Exhibitor configuration `poll_interval` setting
# @param exhibitor_port
#   Refer to Exhibitor configuration `port` setting
# @param use_kubernetes
#   Boolean to use Kubernetes configuration storage
# @param kubernetes_namespace
#   Refer to Kubernetes configuration `namespace` setting
# @param kubernetes_labels
#   Refer to Kubernetes configuration `labels` setting
# @param kubernetes_scope_label
#   Refer to Kubernetes configuration `scope_label` setting
# @param kubernetes_role_label
#   Refer to Kubernetes configuration `role_label` setting
# @param kubernetes_use_endpoints
#   Refer to Kubernetes configuration `use_endpoints` setting
# @param kubernetes_pod_ip
#   Refer to Kubernetes configuration `pod_ip` setting
# @param kubernetes_ports
#   Refer to Kubernetes configuration `ports` setting
# @param restapi_connect_address
#   Refer to REST API configuration `connect_address` setting
# @param restapi_listen
#   Refer to REST API configuration `listen` setting
# @param restapi_username
#   Refer to REST API configuration `username` setting
# @param restapi_password
#   Refer to REST API configuration `password` setting
# @param restapi_certfile
#   Refer to REST API configuration `certfile` setting
# @param restapi_keyfile
#   Refer to REST API configuration `keyfile` setting
# @param restapi_cafile
#   Refer to REST API configuration `cafile` setting
# @param restapi_verify_client
#   Refer to REST API configuration `verify_client` setting
# @param use_zookeeper
#   Boolean to enable Zookeeper configuration storage
# @param zookeeper_hosts
#   Refer to Zookeeper configuration `hosts` setting
# @param watchdog_mode
#   Refer to Watchdog configuration `mode` setting
# @param watchdog_device
#   Refer to Watchdog configuration `device` setting
# @param watchdog_safety_margin
#   Refer to Watchdog configuration `safety_margin` setting
# @param package_name
#   Patroni package name, only used when `install_method` is `package`
# @param version
#   Version of Patroni to install
# @param install_dependencies
#   Install dependencies, only used when `install_method` is `pip`
# @param manage_python
#   Manage Python class, only used when `install_method` is `pip`
# @param install_method
#   Install method
# @param install_dir
#   Install directory, only used when `install_method` is `pip`
# @param python_class_version
#   The  version of Python to pass to Python class
#   Only used when `install_method` is `pip`
# @param python_venv_version
#   The  version of Python to pass to Python virtualenv defined type
#   Only used when `install_method` is `pip`
# @param config_path
#   Path to Patroni configuration file
# @param config_owner
#   Patroni configuration file owner
# @param config_group
#   Patroni configuration file group
# @param config_mode
#   Patroni configuration file mode
# @param service_name
#   Name of Patroni service
# @param service_ensure
#   Patroni service ensure property
# @param service_enable
#   Patroni service enable property
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
    exec { 'patroni-mkdir-install_dir':
      command => "/bin/mkdir -p ${install_dir}",
      creates => $install_dir,
    }
    if $facts['os']['family'] == 'RedHat' {
      python::virtualenv { 'patroni':
        version    => $python_venv_version,
        venv_dir   => $install_dir,
        virtualenv => 'virtualenv-3',
        systempkgs => true,
        distribute => false,
        require    => Exec['patroni-mkdir-install_dir'],
      }
    }
    if $facts['os']['family'] == 'Debian' {
      python::pyvenv { 'patroni':
        version    => $python_venv_version,
        venv_dir   => $install_dir,
        systempkgs => true,
        require    => Exec['patroni-mkdir-install_dir'],
      }
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
    systemd::unit_file { "${service_name}.service":
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
