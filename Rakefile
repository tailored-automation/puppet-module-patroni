# frozen_string_literal: true

# Attempt to load voxpupuli-test (which pulls in puppetlabs_spec_helper),
# otherwise attempt to load it directly.
begin
  require 'voxpupuli/test/rake'
rescue LoadError
  begin
    require 'puppetlabs_spec_helper/rake_tasks'
  rescue LoadError
  end
end

require 'beaker-rspec/rake_task' if Bundler.rubygems.find_name('beaker-rspec').any?
