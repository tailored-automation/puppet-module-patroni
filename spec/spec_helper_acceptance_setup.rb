RSpec.configure do |c|
  c.before :suite do
    on hosts, puppet('module', 'install', 'puppet-etcd', '--version', '">= 1.2.0 <2.0.0"')
  end
end
