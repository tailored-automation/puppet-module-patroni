require 'coveralls'
Coveralls.wear!

def platform_data(p, d)
  data = {
    'RedHat-7' => {
      postgresql_version: '9.6',
      data_dir: '/var/lib/pgsql/9.6/data',
      bin_dir: '/usr/pgsql-9.6/bin',
      pg_config_link: true,
      python_class_version: '36',
      python_venv_version: '3.6',
    },
    'RedHat-8' => {
      manage_postgresql_repo: false,
      postgres_repo_require: nil,
      data_dir: '/var/lib/pgsql/data',
      bin_dir: '/usr/bin',
      python_venv_version: '3.6',
    },
    'RedHat-9' => {
      manage_postgresql_repo: false,
      postgres_repo_require: nil,
      data_dir: '/var/lib/pgsql/data',
      bin_dir: '/usr/bin',
      python_venv_version: '3.9',
    },
    'Debian-11' => {
      data_dir: '/var/lib/postgresql/13/main',
      bin_dir: '/usr/lib/postgresql/13/bin',
      python_venv_version: '3.9',
      config_dir: '/etc/patroni',
      config_path: '/etc/patroni/config.yml',
    },
    'Ubuntu-20.04' => {
      data_dir: '/var/lib/postgresql/12/main',
      bin_dir: '/usr/lib/postgresql/12/bin',
      python_venv_version: '3.8',
      config_dir: '/etc/patroni',
      config_path: '/etc/patroni/config.yml',
    },
    'Ubuntu-22.04' => {
      data_dir: '/var/lib/postgresql/14/main',
      bin_dir: '/usr/lib/postgresql/14/bin',
      python_venv_version: '3.10',
      config_dir: '/etc/patroni',
      config_path: '/etc/patroni/config.yml',
    },
    'Ubuntu-24.04' => {
      data_dir: '/var/lib/postgresql/16/main',
      bin_dir: '/usr/lib/postgresql/16/bin',
      python_venv_version: '3.12',
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
