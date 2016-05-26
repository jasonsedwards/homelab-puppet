#!/bin/bash
role=$1

sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
if [$? -eq 0]; then
  sudo yum -y install puppet
  if [$? -eq 0]; then
    mkdir -p /etc/facter/facts.d/
    echo "leadx_role=$role" > /etc/facter/facts.d/role.txt
    gem install r10k --no-ri --no-rdoc
    cd /etc/puppet
    rm -rf *
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
    /usr/bin/r10k puppetfile install -v
    popd
EOF
    bash /usr/local/bin/update-r10k.sh
    git clone git@github.com:jasonsedwards/homelab-puppet.git .
    ln -sf /etc/puppet/hiera.yaml /etc/hiera.yaml
    puppet apply /etc/puppet/environments/production/manifests/site.pp --environment production --modulepath /etc/puppet/modules:/etc/puppet/environments/production/modules/
  else
    echo "Failed to install puppet and provision machine"
  fi
else
  echo "Failed to download puppetlabs repository"
  exit 1
fi
