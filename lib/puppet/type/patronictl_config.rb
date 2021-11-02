Puppet::Type.newtype(:patronictl_config) do
  desc <<-DESC
@summary Abstract type to configure other types
**NOTE** This is a private type not intended to be used directly.
DESC

  newparam(:name, namevar: true) do
    desc 'The name of the resource.'
  end

  newparam(:path) do
    desc 'patronictl path'
    defaultto('/opt/app/patroni/bin/patronictl')
  end

  newparam(:config) do
    desc 'patronictl config'
    defaultto('/opt/app/patroni/etc/postgresql.yml')
  end

  # First collect all types with patronictl provider that come from this module
  # For each patronictl type, set the class variable 'chunk_size' used by
  # each provider to list resources
  # Return empty array since we are not actually generating resources
  def generate
    patronictl_types = []
    Dir[File.join(File.dirname(__FILE__), '../provider/patroni_*/patronictl.rb')].each do |file|
      type = File.basename(File.dirname(file))
      patronictl_types << type.to_sym
    end
    patronictl_types.each do |type|
      provider_class = Puppet::Type.type(type).provider(:patronictl)
      provider_class.path = self[:path]
      provider_class.config = self[:config]
    end
    []
  end
end
