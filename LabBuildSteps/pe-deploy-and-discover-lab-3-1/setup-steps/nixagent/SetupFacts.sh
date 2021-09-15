set -x

sudo mkdir -p /etc/puppetlabs/facter/facts.d

cd /etc/puppetlabs/facter/facts.d
touch datacenter.sh
cat << 'EOF' > /etc/puppetlabs/facter/facts.d/datacenter.sh
#!/usr/bin/env bash
echo "datacenter=datacenter-west"
EOF

chmod +x /etc/puppetlabs/facter/facts.d/datacenter.sh
exit 0