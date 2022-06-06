#!/bin/bash

MINECRAFT_MEMORY_MIN=
MINECRAFT_MEMORY_MAX=
MINECRAFT_SERVER_DIR=
MINECRAFT_SERVER_WORLD=world
MINECRAFT_SERVER_VERSION=1.18.2

function start_server() {
  cd "${MINECRAFT_SERVER_DIR}/worlds/${MINECRAFT_SERVER_WORLD}" || exit 1

  if ! [[ -e server.jar ]]; then
    ln -s "../versions/server_${MINECRAFT_SERVER_VERSION}.jar" server.jar
  fi

  readonly LOGFILE_NAME="minecraft_$(date +"%Y-%m-%d_%H-%M").log"
  readonly MINECRAFT_CMD="java -Xms${MINECRAFT_MEMORY_MIN} -Xmx${MINECRAFT_MEMORY_MAX} -jar server_${MINECRAFT_SERVER_VERSION}.jar nogui"

  mkdir -p logs

  screen -L -Logfile "logs/${LOGFILE_NAME}" ${MINECRAFT_CMD}
}


# /home/mc/minecraft <- MINECRAFT_SERVER_DIR
# |- versions
# |  |- server_1.18.0.jar
# |  |- server_1.18.1.jar
# |  |- server_1.18.2.jar
# |
# |- worlds
# |  |- test-1
# |  |  |- server.jar <- symlink to ../versions/server_xyz.jar
# |  |
# |  |- test-2
# |- backups
# |  |- test-1
# |  |  |- 2022-06-06_10-08.tar.gz
# |
# |- minecraft.sh