require 'spec_helper_acceptance'

describe 'patroni class:' do
  patroni1 = hosts_as('patroni1')[0]
  patroni2 = hosts_as('patroni2')[0]
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
    class { 'patroni':
      scope                   => 'cluster',
      use_etcd                => true,
      pgsql_connect_address   => "${facts['networking']['fqdn']}:5432",
      restapi_connect_address => "${facts['networking']['fqdn']}:8008",
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
  EOS
  context 'default parameters' do
    it 'runs successfully' do
      apply_manifest_on(patroni1, etcd)
      apply_manifest_on(patroni2, etcd, catch_failures: true)
      apply_manifest_on(patroni1, etcd, catch_failures: true)
      apply_manifest_on(patroni1, pp, catch_failures: true)
      apply_manifest_on(patroni1, pp, catch_changes: true)
      apply_manifest_on(patroni2, pp, catch_failures: true)
      apply_manifest_on(patroni2, pp, catch_changes: true)
    end

    describe port(8008), node: patroni1 do
      it { is_expected.to be_listening }
    end
    describe port(8008), node: patroni2 do
      it { is_expected.to be_listening }
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

  context 'add DCS config' do
    it 'runs successfully' do
      dcs_pp = <<-EOS
        #{pp}
        patroni_dcs_config { 'postgresql.parameters.max_connections':
          value  => 200,
          notify => Exec['patroni-restart-pending'],
        }

        exec { 'patroni-restart-pending':
          path        => '/usr/bin:/bin:/usr/sbin:/sbin',
          command     => "sleep 60 ; ${patroni::patronictl} -c ${patroni::config_path} restart ${patroni::scope} --pending --force",
          environment => ['LC_ALL=en_US.utf8'],
          refreshonly => true,
          require     => Service['patroni'],
        }
      EOS
      apply_manifest_on(patroni1, dcs_pp, catch_failures: true)
      apply_manifest_on(patroni1, dcs_pp, catch_changes: true)
    end

    describe command('ps aux | grep postgres') do
      its(:stdout) { is_expected.to match %r{max_connections=200} }
    end
  end
end
