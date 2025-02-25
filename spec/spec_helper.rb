# frozen_string_literal: true

require 'voxpupuli/test/spec_helper'

RSpec.configure do |c|
  c.mock_with :rspec
end

require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

include RspecPuppetFacts

default_facts = {
  puppetversion: Puppet.version,
  facterversion: Facter.version,
}

default_fact_files = [
  File.expand_path(File.join(File.dirname(__FILE__), 'default_facts.yml')),
  File.expand_path(File.join(File.dirname(__FILE__), 'default_module_facts.yml')),
]

default_fact_files.each do |f|
  next unless File.exist?(f) && File.readable?(f) && File.size?(f)

  begin
    default_facts.merge!(YAML.safe_load(File.read(f)))
  rescue => e
    RSpec.configuration.reporter.message "WARNING: Unable to load #{f}: #{e}"
  end
end

RSpec.configure do |c|
  c.facterdb_string_keys = false
end

Dir['./spec/support/spec/**/*.rb'].sort.each { |f| require f }
