# Monitoring

1. [Configure Mail](#configure-mail)
2. [Drives (HDD / SSD)](#drives-hdd--ssd)
   1. [S.M.A.R.T](#smart)
   2. [Temperature](#temperature)
3. [Prometheus / Grafana](#prometheus--grafana)
4. [Prometheus Exporters](#prometheus-exporters)
   1. [Node Exporter](#node-exporter)
   2. [Pi-Hole Exporter](#pi-hole-exporter-service)

## Configure Mail
for mor information see [here](https://decatec.de/linux/linux-einfach-e-mails-versenden-mit-msmtp/)

## Drives (HDD / SSD)
### S.M.A.R.T

* smartctl must be installed
* smtp client must be installed and configured
* `smart.sh` can be used to trigger test runs and to retrieve test results (email)

|      |               | Options  | Comment                                                                       | Example value   |
|------|---------------|----------|-------------------------------------------------------------------------------|-----------------|
| `-d` | `--device`    |          | specify device to be used                                                     | `/dev/sda`      |
| `-h` | `--help`      |          | show help                                                                     |                 |
| `-m` | `--mode`      |          | specify mode to be used                                                       | `test`          |
|      |               | `test`   | run a new test                                                                |                 |
|      |               | `result` | provide results of a previously triggered test                                |                 |
| `-r` | `--recipient` |          | specify recipient (email) to be notified when using result mode `[-m result]` | `test@test.tld` |
| `-t` | `--test-mode` |          | specify smartctl test mode to be used                                         | `short`         |
|      |               | `short`  |                                                                               |                 |
|      |               | `long`   |                                                                               |                 |

* to automate test runs a crontab entry can be used: `crontab -e`
```shell
# run a long test for /dev/sda every first day of the month at 1 am
0 1 1 * * /root/Homelab-Tools/monitoring/smart.sh -m test -d /dev/sda -t long

# provide test results for /dev/sda every second day of the month at 1 am
0 1 2 * * /root/Homelab-Tools/monitoring/smart.sh -m result -d /dev/sda -r test@test.tld
```

#### Commands
```shell
# run short test for device /dev/sda
smartctl -t short /dev/sda

# run long test for device /dev/sda
smartctl -t long /dev/sda

# show test results for device /dev/sda
smartctl -a /dev/sda
```

### Temperature
#### Commands
```shell
# show temp for multiple devices
hddtemp /dev/sd[a-d]

# show temp for device as numeric
hddtemp /dev/sda --numeric
```

## Prometheus / Grafana
Easiest way to use Prometheus and Grafana is by using [docker-compose](./prometheus-grafana/docker-compose.yml) file

## Prometheus Exporters

### Node Exporter (Service)

1. create new user
```sh
sudo useradd node_exporter -s /sbin/nologin
```

2. download node_exporter

check for newest version on [prometheus website](https://prometheus.io/download/#node_exporter)
```sh
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
```

3. extract and move node_exporter
```sh
tar xvfz node_exporter-1.5.0.linux-amd64.tar.gz
sudo cp node_exporter-1.5.0.linux-amd64/node_exporter /usr/bin
```
4. create new service
```sh
sudo nano /etc/systemd/system/node_exporter.service
```

add content from [node_exporter.service](./prometheus-exporters/node-exporter/node_exporter.service)

5. activate and start service
```sh
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
```

### Pi-Hole Exporter (Service)
see [Pi-Hole Prometheus Exporter](https://github.com/eko/pihole-exporter) GitHub page for further information

1. create new user
```sh
sudo useradd pihole_exporter -s /sbin/nologin
```

2. download pihole_exporter

check for newest version on [pihole-exporter](https://github.com/eko/pihole-exporter/releases) GitHub page
```sh
wget https://github.com/eko/pihole-exporter/releases/download/v0.3.0/pihole_exporter-linux-amd64
```

3. make pihole_exporter executable and move
```sh
chmod +x pihole_exporter-linux-amd64 
sudo cp pihole_exporter-linux-amd64 /usr/bin/pihole_exporter
```
4. create new service
```sh
sudo nano /etc/systemd/system/pihole_exporter.service
```

add content from [pihole_exporter.service](./prometheus-exporters/pihole/pihole_exporter.service)

5. create start script
```sh
sudo nano /etc/pihole/pihole-exporter.sh
```

add content from [pihole_exporter.service](./prometheus-exporters/pihole/pihole-exporter.sh)

make script executable
```sh
sudo chmod +x /etc/pihole/pihole-exporter.sh
```

6. activate and start service
```sh
sudo systemctl daemon-reload
sudo systemctl enable pihole_exporter
sudo systemctl start pihole_exporter
```