# Game Servers

1. [Minecraft](#minecraft)

## Minecraft

Use `minecraft.sh` to maintain your minecraft server (vanilla):
* server.jar file will be downloaded during start or update process
* [minecraft EULA](https://www.minecraft.net/en-us/eula) will be accepted while starting process!

|      |                | Options  | Comment                                                          | Example value |
|------|----------------|----------|------------------------------------------------------------------|---------------|
| `-d` | `--directory ` |          | specify minecraft server directory                               | `~/minecraft` |
| `-h` | `--help`       |          | show help                                                        |               |
| `-m` | `--mode`       |          | specify mode to be used                                          | `start`       |
|      |                | `start`  | start minecraft server                                           |               |
|      |                | `stop`   | stop minecraft server                                            |               |
|      |                | `update` | stop server, update server file and start server again           |               |
|      |                | `backup` | backup minecraft server into tar.gz file                         |               |
| `-i` | `--memory-min` |          | specify min memory usage for minecraft server (default: `1024M`) | `2048M`       |
| `-a` | `--memory-max` |          | specify max memory usage for minecraft server (default: `2048M`) | `4096M`       |
| `-v` | `--version`    |          | specify minecraft version (default: `1.18.2`)                    | `1.18.2`      |
| `-w` | `--world`      |          | specify name of world                                            | `my-world`    |

*Directory structure:*
```
~/minecraft # this represents your minecraft server directory 
   |-- versions  # all server versions will be saved here
   |   |-- server_1.18.1.jar
   |   |-- server_1.18.2.jar
   |
   |-- worlds
   |   |-- test-1 # data of world (-w 'test-1')
   |   |   |-- server.jar    # symlink to server version (e.g. '../../versions/server_1.18.1.jar')'
   |   |   |-- ...           # other minecraft data
   |   |
   |   |-- test-2 # data of world (-w 'test-2')
   |   |   |-- server.jar    # symlink to server version (e.g. '../../versions/server_1.18.2.jar')'
   |   |   |-- ...           # other minecraft data
   |
   |-- backups
   |   |-- test-1
   |   |   |- 2022-06-06_10-08.tar.gz
```

*Examples:*

```shell
# start minecraft server
minecraft.sh -m start -d ~/minecraft/

# stop minecraft server
minecraft.sh -m stop -d ~/minecraft/

# update minecraft server
minecraft.sh -m update -d ~/minecraft/ -v 1.18.2

# backup minecraft server
minecraft.sh -m backup -d ~/minecraft/
```