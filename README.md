# homelab-puppet
Masterless puppet code to manage my homelab environment.

## Steps
1. Create public/private keypair using SSH tutorial link below.
2. Add public key to github account.
3. Create `~/.ssh/ciuser` and copy in your private key.
4. Run provision.sh `./provision.sh <role>` to provision server.

## Available roles
The puppet system has the following roles which can be used by
**provision.sh**:
- management

## Help
Checkout the [GitHub SSH Tutorial](https://help.github.com/articles/generating-an-ssh-key/) to create a public/private keypair for use with Github.
