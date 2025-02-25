RSpec.configure do |c|
  c.before :suite do
    on hosts, puppet('module', 'install', 'tailoredautomation-etcd', '--version', '">= 0.3.0 <2.0.0"')
  end
end
