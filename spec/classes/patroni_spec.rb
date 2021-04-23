require 'spec_helper'

describe 'patroni' do
  test_on = {
    # The supported OS's are listed here explicitly instead of automatically
    # using the list from metadata.json. This is to prevent extra, wasteful and
    # useless testing for RedHat like systems which would otherwise run the
    # same tests for OracleLinux and RedHat.
    supported_os: [
      {
        'operatingsystem'        => 'CentOS',
        'operatingsystemrelease' => ['7', '8'],
      },
      {
        'operatingsystem'        => 'Debian',
        'operatingsystemrelease' => ['9', '10'],
      },
      {
        'operatingsystem'        => 'Ubuntu',
        'operatingsystemrelease' => ['18.04'],
      },
    ],
  }

  on_supported_os(test_on).each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:node) { 'localhost' }
      let(:params) { { 'scope' => 'testscope' } }
      let(:platform) { "#{facts[:os]['name']}-#{facts[:os]['release']['major']}" }

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_class('postgresql::globals').with(
          encoding: 'UTF-8',
          locale: 'en_US.UTF-8',
          manage_package_repo: 'true',
          version: platform_data(platform, :postgresql_version),
        )
      end
      it { is_expected.to contain_class('postgresql::params') }
      it do
        is_expected.to contain_package('patroni-postgresql-package').with(
          ensure: 'present',
          require: 'Class[Postgresql::Repo]',
          before: 'Service[patroni]',
        )
      end
      it do
        is_expected.to contain_exec('patroni-clear-datadir').with(
          path: '/usr/bin:/bin',
          command: "/bin/rm -rf #{platform_data(platform, :data_dir)}",
          refreshonly: 'true',
          subscribe: 'Package[patroni-postgresql-package]',
          before: 'Service[patroni]',
        )
      end

      it do
        is_expected.to contain_class('python').with(
          version: platform_data(platform, :python_class_version),
          dev: 'present',
          virtualenv: 'present',
        )
      end
      it 'installs dependencies' do
        platform_data(platform, :install_dependencies).each do |p|
          is_expected.to contain_package(p).that_comes_before('Python::Pip[patroni]')
        end
      end
      it do
        is_expected.to contain_exec('patroni-mkdir-install_dir').with(
          command: '/bin/mkdir -p /opt/app/patroni',
          creates: '/opt/app/patroni',
        )
      end

      case os_facts[:os]['family']
      when 'RedHat'
        it do
          is_expected.to contain_python__virtualenv('patroni').with(
            version: platform_data(platform, :python_venv_version),
            venv_dir: '/opt/app/patroni',
            virtualenv: 'virtualenv-3',
            systempkgs: 'true',
            distribute: 'false',
            environment: ['PIP_PREFIX=/opt/app/patroni'],
            require: 'Exec[patroni-mkdir-install_dir]',
          )
        end
      when 'Debian'
        it do
          is_expected.to contain_python__pyvenv('patroni').with(
            version: platform_data(platform, :python_venv_version),
            venv_dir: '/opt/app/patroni',
            systempkgs: 'true',
            environment: ['PIP_PREFIX=/opt/app/patroni'],
            require: 'Exec[patroni-mkdir-install_dir]',
          )
        end
      end

      it do
        is_expected.to contain_python__pip('patroni').with(
          ensure: 'present',
          virtualenv: '/opt/app/patroni',
          environment: ['PIP_PREFIX=/opt/app/patroni'],
          before: 'File[patroni_config]',
        )
      end
      it do
        is_expected.to contain_python__pip('psycopg2').with(
          virtualenv: '/opt/app/patroni',
          before: 'Python::Pip[patroni]',
          environment: ['PIP_PREFIX=/opt/app/patroni'],
        )
      end
      it { is_expected.not_to contain_python__pip('python-consul') }
      it { is_expected.not_to contain_python__pip('python-etcd') }
      it { is_expected.not_to contain_python__pip('python-kazoo') }

      it do
        is_expected.to contain_file('patroni_config_dir').with(
          ensure: 'directory',
          path: platform_data(platform, :config_dir),
          owner: 'postgres',
          group: 'postgres',
          mode: '0755',
        )
      end

      it do
        is_expected.to contain_file('patroni_config').with(
          ensure: 'file',
          path: platform_data(platform, :config_path),
          owner: 'postgres',
          group: 'postgres',
          mode: '0600',
          notify: 'Service[patroni]',
        )
      end
      it 'has valid config' do
        content = catalogue.resource('file', 'patroni_config').send(:parameters)[:content]
        config = YAML.safe_load(content)

        expected = {
          'dcs' => {
            'ttl' => 30,
            'loop_wait' => 10,
            'retry_timeout' => 10,
            'maximum_lag_on_failover' => 1_048_576,
            'master_start_timeout' => 300,
            'synchronous_mode' => false,
            'synchronous_mode_strict' => false,
            'postgresql' => {
              'use_pg_rewind' => true,
              'use_slots' => true,
            },
          },
          'method' => 'initdb',
          'initdb' => [
            'data-checksums',
            { 'encoding' => 'UTF8' },
            { 'locale' => 'en_US.utf8' },
          ],
          'pg_hba' => [
            'host all all 0.0.0.0/0 md5',
            'host replication rep_user 0.0.0.0/0 md5',
          ],
        }
        expected.each_pair do |k, v|
          expect(config['bootstrap'][k]).to eq(v)
        end
        expect(config['bootstrap']).to eq(expected)
        expected_config = {
          'scope' => 'testscope',
          'namespace' => '/service/',
          'name' => 'localhost',
          'bootstrap' => {
            'dcs' => {
              'ttl' => 30,
              'loop_wait' => 10,
              'retry_timeout' => 10,
              'maximum_lag_on_failover' => 1_048_576,
              'master_start_timeout' => 300,
              'synchronous_mode' => false,
              'synchronous_mode_strict' => false,
              'postgresql' => {
                'use_pg_rewind' => true,
                'use_slots' => true,
              },
            },
            'method' => 'initdb',
            'initdb' => [
              'data-checksums',
              { 'encoding' => 'UTF8' },
              { 'locale' => 'en_US.utf8' },
            ],
            'pg_hba' => [
              'host all all 0.0.0.0/0 md5',
              'host replication rep_user 0.0.0.0/0 md5',
            ],
          },
          'postgresql' => {
            'listen'          => '0.0.0.0:5432',
            'connect_address' => 'localhost:5432',
            'data_dir'        => platform_data(platform, :data_dir),
            'bin_dir'         => platform_data(platform, :bin_dir),
            'use_unix_socket' => false,
            'pgpass'          => '/tmp/pgpass0',
            'pg_ctl_timeout'  => 60,
            'use_pg_rewind'   => true,
            'remove_data_directory_on_rewind_failure' => false,
            'authentication' => {
              'superuser' => {
                'username' => 'postgres',
                'password' => 'changeme',
              },
              'replication' => {
                'username' => 'rep_user',
                'password' => 'changeme',
              },
            },
            'create_replica_methods' => ['basebackup'],
          },
          'restapi' => {
            'listen' => '0.0.0.0:8008',
            'connect_address' => 'localhost:8008',
          },
          'watchdog' => {
            'mode' => 'automatic',
            'device' => '/dev/watchdog',
            'safety_margin' => 5,
          },
        }
        expect(config).to eq(expected_config)
      end

      it do
        is_expected.to contain_systemd__unit_file('patroni.service').with_notify('Service[patroni]')
      end
      it 'has valid systemd unit' do
        content = catalogue.resource('systemd::unit_file', 'patroni.service').send(:parameters)[:content]
        expected_lines = [
          '[Unit]',
          'Description=PostgreSQL high-availability manager',
          'After=syslog.target',
          'After=network-online.target',
          '[Service]',
          'Type=simple',
          'User=postgres',
          'Group=postgres',
          "Environment=PATRONI_CONFIG_LOCATION=#{platform_data(platform, :config_path)}",
          'OOMScoreAdjust=-1000',
          'ExecStart=/opt/app/patroni/bin/patroni ${PATRONI_CONFIG_LOCATION}',
          'ExecReload=/bin/kill -HUP $MAINPID',
          'TimeoutSec=30',
          'TimeoutStopSec=120s',
          'KillSignal=SIGINT',
          'KillMode=process',
          '[Install]',
          'WantedBy=multi-user.target',
        ]
        expect(content.split("\n").reject { |l| l =~ %r{(^$|^#)} }).to eq(expected_lines)
      end

      if Puppet.version.to_s =~ %r{^5}
        it { is_expected.to contain_class('systemd::systemctl::daemon_reload').that_comes_before('Service[patroni]') }
      else
        it { is_expected.not_to contain_class('systemd::systemctl::daemon_reload').that_comes_before('Service[patroni]') }
      end

      it do
        is_expected.to contain_service('patroni').with(
          ensure: 'running',
          enable: 'true',
          name: 'patroni',
        )
      end

      context 'use_etcd => true' do
        let(:params) { { 'scope' => 'testscope', 'use_etcd' => true } }

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_python__pip('python-etcd').with(
            virtualenv: '/opt/app/patroni',
            before: 'Python::Pip[patroni]',
            environment: ['PIP_PREFIX=/opt/app/patroni'],
          )
        end
        it 'has valid config' do
          content = catalogue.resource('file', 'patroni_config').send(:parameters)[:content]
          config = YAML.safe_load(content)
          expected = {
            'etcd' => {
              'host' => '127.0.0.1:2379',
              'protocol' => 'http',
            },
          }
          expect(config).to include(expected)
        end
      end

      context 'manage_postgresql => false' do
        let(:params) { { 'scope' => 'testscope', 'manage_postgresql' => false } }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.not_to contain_class('postgresql::globals') }
        it { is_expected.not_to contain_class('postgresql::params') }
        it { is_expected.not_to contain_package('patroni-postgresql-package') }
        it { is_expected.not_to contain_exec('patroni-clear-datadir') }
        it 'has valid config' do
          content = catalogue.resource('file', 'patroni_config').send(:parameters)[:content]
          config = YAML.safe_load(content)
          expect(config['postgresql']['data_dir']).to eq('/var/lib/patroni')
          expect(config['postgresql']['bin_dir']).to be_nil
        end
      end

      context 'manage_postgresql_repo => false' do
        let(:params) { { 'scope' => 'testscope', 'manage_postgresql_repo' => false } }

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_class('postgresql::globals').with(
            manage_package_repo: false,
          )
        end
        it do
          is_expected.to contain_package('patroni-postgresql-package').with(
            require: nil,
          )
        end
      end

      context 'install_method => package' do
        let(:params) { { 'scope' => 'testscope', 'install_method' => 'package' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('python') }
        it { is_expected.not_to contain_exec('patroni-mkdir-install_dir') }
        it { is_expected.not_to contain_python__virtualenv('patroni') }
        it { is_expected.not_to contain_python__pyenv('patroni') }
        it { is_expected.not_to contain_python__pip('patroni') }

        it do
          is_expected.to contain_package('patroni').with(
            ensure: 'present',
            name: 'patroni',
            before: 'File[patroni_config]',
          )
        end
        it { is_expected.not_to contain_file('patroni_config_dir') }
        it { is_expected.not_to contain_systemd__unit_file('patroni.service') }
      end

      context 'install_dir => /usr/local/patroni' do
        let(:params) { { 'scope' => 'testscope', 'install_dir' => '/usr/local/patroni' } }

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_exec('patroni-mkdir-install_dir').with(
            command: '/bin/mkdir -p /usr/local/patroni',
            creates: '/usr/local/patroni',
          )
        end
        case os_facts[:os]['family']
        when 'RedHat'
          it do
            is_expected.to contain_python__virtualenv('patroni').with(
              venv_dir: '/usr/local/patroni',
              environment: ['PIP_PREFIX=/usr/local/patroni'],
            )
          end
        when 'Debian'
          it do
            is_expected.to contain_python__pyvenv('patroni').with(
              venv_dir: '/usr/local/patroni',
              environment: ['PIP_PREFIX=/usr/local/patroni'],
            )
          end
        end
        it do
          is_expected.to contain_python__pip('patroni').with(
            virtualenv: '/usr/local/patroni',
            environment: ['PIP_PREFIX=/usr/local/patroni'],
          )
        end
        it do
          is_expected.to contain_python__pip('psycopg2').with(
            virtualenv: '/usr/local/patroni',
            environment: ['PIP_PREFIX=/usr/local/patroni'],
          )
        end
        it 'has valid systemd unit' do
          content = catalogue.resource('systemd::unit_file', 'patroni.service').send(:parameters)[:content]
          expect(content).to include('ExecStart=/usr/local/patroni/bin/patroni ${PATRONI_CONFIG_LOCATION}')
        end
      end
    end
    context 'custom_pip_provider => undef' do
      let(:params) { { 'scope' => 'testscope' } }

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_python__pip('patroni').with(
          pip_provider: nil,
          virtualenv: '/opt/app/patroni',
        )
      end
    end
    context 'custom_pip_provider => /usr/bin/pip3' do
      let(:params) { { 'scope' => 'testscope', 'custom_pip_provider' => '/usr/bin/pip3' } }

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_python__pip('patroni').with(
          pip_provider: '/usr/bin/pip3',
          virtualenv: nil,
        )
      end
    end
  end
end
