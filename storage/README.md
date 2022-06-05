# Storage
1. [Backup & Restore](#backup--restore)
   1. [Restic](#restic)
      1. [Prerequisites](#prerequisites) 
      2. [Backup](#backup)
      3. [Restore](#restore)


## Backup & Restore

### Restic
Backups can be created and restored using [restic](https://restic.net/)

#### Prerequisites
Create new file which contains repository password and limit access for specific user only
```
echo "YOUR_PASSWORD" > ~/.restic_pw
chmod 600 ~/.restic_pw
```

#### Backup
Use `restic-backup.sh` with following parameters to execute a backup. Some of them are not mandatory.

| Parameter    | Mandatory | Default | Comment                                                             |
|--------------|-----------|---------|---------------------------------------------------------------------|
| `-d [value]` | `no`      | 31      | number of daily backups to keep                                     |
| `-h [value]` | `no`      | 1       | number of hourly backups to keep                                    |
| `-m [value]` | `no`      | 3       | number of monthly backups to keep                                   |
| `-p [value]` | `yes`     |         | path to restic password file                                        |
| `-r [value]` | `yes`     |         | path to restic repository                                           |
| `-s [value]` | `yes`     |         | path to source directory or source file, can be used multiple times |

Example:

With following command you can create a backup for multiple directories:

```
/backup/restic-backup-restore/backup.sh \
  -p ~/.restic_pw \
  -r /backup/restic \
  -s /data/docker/seafile \
  -s /var/lib/docker/volumes/seafile_seafile-data/_data \
  -s /var/lib/docker/volumes/seafile_seafile-mariadb/_data \
  -s /var/lib/docker/volumes/seafile_seahub-custom/_data \
  -s /var/lib/docker/volumes/seafile_seahub-avatars/_data
```

- Password file is located at `~/.restic_pw`
- Repository will be initialized at `/backup/restic`
- Sources are:
    - `/data/docker/seafile` which in this example contains `docker-compose.yaml`
    - `/var/lib/docker/volumes/seafile_seafile-data/_data` which in this example contains seafile data
    - `/var/lib/docker/volumes/seafile_seafile-mariadb/_data` which in this example contains seafile database
    - `/var/lib/docker/volumes/seafile_seahub-custom/_data` which in this example contains seahub custom
    - `/var/lib/docker/volumes/seafile_seahub-avatars/_data` which in this example contains seahub avatars

#### Restore
TBD