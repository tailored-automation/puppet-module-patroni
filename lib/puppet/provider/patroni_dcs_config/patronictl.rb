require File.expand_path(File.join(File.dirname(__FILE__), '..', 'patronictl'))

Puppet::Type.type(:patroni_dcs_config).provide(:patronictl, parent: Puppet::Provider::Patronictl) do
  desc 'Provider for patroni_dcs_config using patronictl'

  mk_resource_methods

  defaultfor kernel: ['Linux']

  def self.instances
    configs = []
    begin
      output = patronictl(['show-config'])
    rescue Exception => e # rubocop:disable RescueException
      Puppet.err('Failed to fetch patronictl configurations')
      puts e.backtrace
    end
    Puppet.debug("show-config output: #{output}")
    data = YAML.safe_load(output)
    flatten_hash(data).each_pair do |key, value|
      config = {}
      config[:name] = key
      config[:value] = value
      configs << new(config)
    end
    configs
  end

  def self.prefetch(resources)
    configs = instances
    resources.keys.each do |name|
      if provider = configs.find { |c| c.name == name } # rubocop:disable AssignmentInCondition
        resources[name].provider = provider
      end
    end
  end

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  type_properties.each do |prop|
    define_method "#{prop}=".to_sym do |value|
      @property_flush[prop] = value
    end
  end

  def edit_config(value)
    patronictl(['edit-config', '--force', '--quiet', '-s', value])
  rescue Exception => e # rubocop:disable RescueException
    raise Puppet::Error, "patronictl edit-config for #{resource[:name]} failed\nError message: #{e.message}"
  end

  def create
    edit_config("#{resource[:name]}=#{resource[:value]}")
  end

  def flush
    edit_config("#{resource[:name]}=#{@property_flush[:value]}")
  end
end
