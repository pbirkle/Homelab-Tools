# Storage
1. [Backup & Restore](#backup--restore)
   1. [Restic](#restic)
      1. [Prerequisites](#prerequisites) 
      2. [Backup](#backup)
      3. [Restore](#restore)
      4. [REST-Server](#rest-server)


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

**Example:**

With following command you can create a backup for multiple directories:

```
restic-backup.sh \
  -p ~/.restic_pw \
  -r /backup/restic \
  -s /data/docker/seafile \
  -s /var/lib/docker/volumes/seafile_seafile-data/_data \
  -s /var/lib/docker/volumes/seafile_seafile-mariadb/_data \
  -s /var/lib/docker/volumes/seafile_seahub-custom/_data \
  -s /var/lib/docker/volumes/seafile_seahub-avatars/_data
```

#### Restore
Use `restic-restore.sh` with following parameters to restore a backup. Some of them are not mandatory.

| Parameter    | Mandatory | Default | Comment                       |
|--------------|-----------|---------|-------------------------------|
| `-d [value]` | `no`      | /       | path to destination directory |
| `-p [value]` | `yes`     |         | path to restic password file  |
| `-r [value]` | `yes`     |         | path to restic repository     |

After execution of script all available backups will be listed and a proper one must be chosen to start restore process.

**Example:**

With following command you can list available backups and restore specific one:

```
restic-restore.sh \
  -r /backup/restic \ 
  -p ~/.restic_pw
```

#### REST-Server
Restic offers an [REST-Server](https://github.com/restic/rest-server) to back up your data to a remote server. As restic has performance issues while backing up files through a network share (e.g. samba) this REST-Server can be used to provide a fast remote backup destination.  