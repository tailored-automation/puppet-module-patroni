require 'spec_helper'

describe Puppet::Type.type(:patroni_dcs_config).provider(:patronictl) do
  let(:provider) { described_class }
  let(:type) { Puppet::Type.type(:patroni_dcs_config) }
  let(:resource) { type.new(name: 'foo', value: 'bar') }

  describe 'self.instances' do
    it 'creates instances' do
      allow(provider).to receive(:patronictl).with(['show-config']).and_return(my_fixture_read('config.out'))
      expect(provider.instances.length).to eq(10)
      instance = provider.instances.select { |i| i.instance_variable_get('@property_hash')[:name] == 'postgresql.parameters.max_connections' }
      expect(instance[0].instance_variable_get('@property_hash')[:value]).to eq(200)
    end
  end

  describe 'create' do
    it 'creates DCS config' do
      expect(resource.provider).to receive(:patronictl).with(['edit-config', '--force', '--quiet', '-s', 'foo=bar'])
      resource.provider.create
    end
  end

  describe 'flush' do
    it 'updates DCS config' do
      expect(resource.provider).to receive(:patronictl).with(['edit-config', '--force', '--quiet', '-s', 'foo=1'])
      resource.provider.value = 1
      resource.provider.flush
    end
  end
end
