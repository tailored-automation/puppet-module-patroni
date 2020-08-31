RSpec.configure do |c|
  c.before :suite do
    on hosts, puppet('module', 'install', 'tailoredautomation-etcd', '--version', '">= 0.3.0 <2.0.0"')
    hiera_yaml = <<-EOS
---
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:
  - name: "Hierarchy"
    paths:
      - "%{facts.os.name}/%{facts.os.release.major}.yaml"
      - "%{facts.os.family}/%{facts.os.release.major}.yaml"
      - "%{facts.os.family}.yaml"
      - "common.yaml"
EOS
    common_yaml = <<-EOS
--- {}
EOS
    el7_yaml = <<-EOS
---
postgresql::globals::version: '9.6'
EOS
    create_remote_file(hosts, '/etc/puppetlabs/puppet/hiera.yaml', hiera_yaml)
    on hosts, 'mkdir -p -m 0755 /etc/puppetlabs/puppet/data/RedHat'
    create_remote_file(hosts, '/etc/puppetlabs/puppet/data/common.yaml', common_yaml)
    create_remote_file(hosts, '/etc/puppetlabs/puppet/data/RedHat/7.yaml', el7_yaml)
  end
end
