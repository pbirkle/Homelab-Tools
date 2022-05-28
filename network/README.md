# Network
1. [SSH](#ssh)
   1. [Client](#client)
   2. [Server](#server)

## SSH
### Client
* add config for ssh connections with ssh key

```shell
# edit ssh config
nano ~/.ssh/config

# add following template and adjust for each server
---
Host vm1
  HostName 10.0.0.1
  User username
  IdentityFile ~/.ssh/id_rsa
--- 
```

### Server
* setup of new server to only allow ssh connections
* only ssh keys allowed
* no password authentication
* no ssh root login
```shell
# get public key from private key
ssh-keygen -y -f ~/.ssh/id_rsa

# add public key on remote server
nano ~/.ssh/authorized_keys

# edit sshd config on remote server and add/edit following configurations
nano nano /etc/ssh/sshd_config
---
PubkeyAuthentication yes
PasswordAuthentication no
PermitRootLogin no
---

# restart sshd daemon
systemctl restart ssh.service
```