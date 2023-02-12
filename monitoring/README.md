# Monitoring

1. [Configure Mail](#configure-mail)
2. [Drives (HDD / SSD)](#drives-hdd--ssd)
   1. [S.M.A.R.T](#smart)
   2. [Temperature](#temperature)

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