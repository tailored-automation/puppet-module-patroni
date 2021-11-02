Puppet::Type.newtype(:patroni_dcs_config) do
  desc <<-DESC
@summary Manages Patroni DCS configuration options
@example Set PostgreSQL max connections
  patroni_dcs_config { 'postgresql.params.max_connections':
    value => '200',
  }
DESC

  newparam(:name, namevar: true) do
    desc 'The DCS configuration option name'
  end

  newproperty(:value) do
    desc 'The value to assign the DCS configuration'
  end

  autorequire(:service) do
    ['patroni']
  end
end
