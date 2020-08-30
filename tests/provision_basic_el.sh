#!/bin/bash

setenforce 0
sed -r -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

release=$(awk -F \: '{print $5}' /etc/system-release-cpe)

yum install -y epel-release
yum install -y wget jq

# install and configure puppet
rpm -qa | grep -q puppet
if [ $? -ne 0 ]
then
    yum -y install http://yum.puppetlabs.com/puppet5-release-el-${release}.noarch.rpm
    yum -y install puppet-agent
    ln -s /opt/puppetlabs/puppet/bin/puppet /usr/bin/puppet
fi

puppet resource host patroni1.example.com ensure=present ip=10.0.0.1 host_aliases=patroni1
puppet resource host patroni2.example.com ensure=present ip=10.0.0.2 host_aliases=patroni2
puppet resource host patroni3.example.com ensure=present ip=10.0.0.3 host_aliases=patroni3

puppet resource file /etc/puppetlabs/code/environments/production/modules/patroni ensure=link target=/vagrant
puppet module install camptocamp-systemd --version 2.10.0
puppet module install puppet-python --version 4.1.1
puppet module install puppet-epel --version 3.0.1
puppet module install tailoredautomation-etcd --version 0.3.0
puppet module install puppetlabs-postgresql --version 6.7.0
