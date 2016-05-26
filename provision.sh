#!/bin/bash
role=$1

sudo yum -y install epel-release
sudo yum -y install ruby
sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
sudo yum -y install puppet-agent

/usr/bin/rm -rf /etc/puppet/

mkdir -p /etc/facter/facts.d/
echo "leadx_role=$role" > /etc/facter/facts.d/role.txt

cat <<'EOF' > /root/.ssh/config
Host github.com
  User git
  Hostname github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/ciuser
  StrictHostKeyChecking=no
EOF

cat <<'EOF' > /usr/local/bin/update-r10k.sh
#!/bin/bash
PUPPETFILE_DIR=/etc/puppet/environments/production/modules
export PUPPETFILE_DIR
test ! -d $PUPPETFILE_DIR && mkdir -p $PUPPETFILE_DIR
pushd /etc/puppet
/usr/local/bin/r10k puppetfile install -v
popd
EOF

mkdir /etc/puppet
cd /etc/puppet
git clone git@github.com:jasonsedwards/homelab-puppet.git .
sudo gem install r10k --no-ri --no-rdoc
bash /usr/local/bin/update-r10k.sh
ln -sf /etc/puppet/hiera.yaml /etc/hiera.yaml
puppet apply /etc/puppet/environments/production/manifests/site.pp --environment production --modulepath /etc/puppet/modules:/etc/puppet/environments/production/modules/
