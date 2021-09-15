#! /bin/bash
# Install wget to download Puppet Enterprise
# Install git for Puppet Enterprise code management


set -x

sudo yum update -y
sudo yum -y install wget git nc

# Download the Puppet Enterprise 2018.1.15

cd /tmp
curl -JLO 'https://pm.puppet.com/cgi-bin/download.cgi?dist=el&rel=7&arch=x86_64&ver=2019.8.6'

tar -xzf puppet-enterprise-2019.8.6-el-7-x86_64.tar.gz
# Set PE console password and configure code manager
sed -i 's/#"console_admin_password": ""/"console_admin_password": "puppetlabs"/' puppet-enterprise-2019.8.6-el-7-x86_64/conf.d/pe.conf
sed -i '/#"puppet_enterprise::profile::master::r10k_private_key"/a "pe_repo::compile_master_pool_address" : "puppet"'  /tmp/puppet-enterprise-2019.8.6-el-7-x86_64/conf.d/pe.conf

# sed -i 's/"puppet_enterprise::puppet_master_host": "%{::trusted.certname}"/"puppet_enterprise::puppet_master_host": "puppet"/' puppet-enterprise-2019.8.6-el-7-x86_64/conf.d/pe.conf
#sudo sed -i 's/127.0.0.1 localhost/127.0.0.1 localhost puppet/' /etc/hosts
# sed -i 's/#"puppet_enterprise::profile::master::code_manager_auto_configure": true/"puppet_enterprise::profile::master::code_manager_auto_configure": true/' puppet-enterprise-2018.1.15-el-7-x86_64/conf.d/pe.conf
# sed -i 's|#"puppet_enterprise::profile::master::r10k_private_key": "/etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa"|"puppet_enterprise::profile::master::r10k_private_key": "/etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa"|' puppet-enterprise-2018.1.15-el-7-x86_64/conf.d/pe.conf
# sed -i 's|#"puppet_enterprise::profile::master::r10k_remote": "git@your.git.server.com:puppet/control.git"|"puppet_enterprise::profile::master::r10k_remote": "https://github.com/puppetlabs/education-control-repo.git"|' puppet-enterprise-2018.1.15-el-7-x86_64/conf.d/pe.conf

# Install Puppet Enterprise 2019.8.6
sudo ./puppet-enterprise-2019.8.6-el-7-x86_64/puppet-enterprise-installer -c puppet-enterprise-2019.8.6-el-7-x86_64/conf.d/pe.conf

sudo systemctl stop puppet.service

sleep 30

sudo /usr/local/bin/puppet agent -t 

sleep 5

sudo /usr/local/bin/puppet agent -t

sudo /usr/local/bin/puppet module install WhatsARanjit-node_manager --version 0.7.5

sudo /usr/local/bin/puppet agent -t

sudo /usr/local/bin/puppet apply /tmp/resources/node_manager.pp

sudo /usr/local/bin/puppet agent -t

sudo rpm -Uvh https://yum.puppet.com/puppet-tools-release-el-7.noarch.rpm
sudo yum install -y puppet-bolt-3.17.0

service pe-puppetserver reload

# Wait for any running agent to finish
while [ -f /opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock ]; do
  sleep 1
done

