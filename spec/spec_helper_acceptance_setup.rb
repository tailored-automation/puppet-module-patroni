RSpec.configure do |c|
  c.before :suite do
    on hosts, puppet('module', 'install', 'puppetlabs-postgresql', '--version', '">= 6.7.0 <7.0.0"')
    on hosts, puppet('module', 'install', 'tailoredautomation-etcd', '--version', '">= 0.3.0 <2.0.0"')
  end
end
