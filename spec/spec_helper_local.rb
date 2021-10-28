require 'coveralls'
Coveralls.wear!

def platform_data(p, d)
  data = {
    'CentOS-7' => {
      postgresql_version: '9.6',
      data_dir: '/var/lib/pgsql/9.6/data',
      bin_dir: '/usr/pgsql-9.6/bin',
      pg_config_link: true,
      python_class_version: '36',
      python_venv_version: '3.6',
    },
    'CentOS-8' => {
      manage_postgresql_repo: false,
      postgres_repo_require: nil,
      data_dir: '/var/lib/pgsql/data',
      bin_dir: '/usr/bin',
      python_venv_version: '3',
    },
    'Debian-9' => {
      data_dir: '/var/lib/postgresql/9.6/main',
      bin_dir: '/usr/lib/postgresql/9.6/bin',
      python_venv_version: '3.5',
      config_dir: '/etc/patroni',
      config_path: '/etc/patroni/config.yml',
    },
    'Debian-10' => {
      data_dir: '/var/lib/postgresql/11/main',
      bin_dir: '/usr/lib/postgresql/11/bin',
      config_dir: '/etc/patroni',
      config_path: '/etc/patroni/config.yml',
    },
    'Ubuntu-18.04' => {
      data_dir: '/var/lib/postgresql/10/main',
      bin_dir: '/usr/lib/postgresql/10/bin',
      python_venv_version: '3.6',
      config_dir: '/etc/patroni',
      config_path: '/etc/patroni/config.yml',
    },
    'default' => {
      postgresql_version: nil,
      manage_postgresql_repo: true,
      postgres_repo_require: 'Class[Postgresql::Repo]',
      pg_config_link: false,
      python_class_version: '3',
      install_dependencies: ['gcc'],
      python_venv_version: '3.7',
      config_dir: '/opt/app/patroni/etc',
      config_path: '/opt/app/patroni/etc/postgresql.yml',
    },
  }
  default = data['default'][d]
  data.fetch(p, data['default']).fetch(d, default)
end
