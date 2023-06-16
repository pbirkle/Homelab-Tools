# Network
1. [SSH](#ssh)
   1. [Client](#client)
   2. [Server](#server)
2. [DynDNS](#dyndns)

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
nano /etc/ssh/sshd_config
---
PubkeyAuthentication yes
PasswordAuthentication no
PermitRootLogin no
---

# restart sshd daemon
systemctl restart ssh.service
```

## DynDNS
[dynv6](https://dynv6.com) can be used to link both IPv4 and IPv6 ips for a hostname. After creating the specified zones/hostnames, the [dynv6.sh](./dynv6.sh) script can be used to update both the IPv4 and IPv6 ips. As the dynv6 api needs an access token, the script must be run once manually so it can be provided. All subsequent calls will use the previously provided api key as it is saved at the following location: ~/.dynv6/[HOSTNAME]/api_token

The update can be automated by adding following to the crontab: (it will check and update every minute)

```sh
* * * * * ~/dynv6.sh your.domain.tld
```