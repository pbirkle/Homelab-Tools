#!/bin/bash

function check_prerequisites() {
  if [[ -z "${MODE}" ]]; then
    echo "mode was not provided (-m flag)"
    exit 1
  fi

  if [[ -z "${MINECRAFT_SERVER_DIR}" ]]; then
    echo "minecraft server directory was not provided (-d flag)"
    exit 1
  fi

  if [[ -z "${MINECRAFT_VERSION}" ]]; then
    MINECRAFT_VERSION=1.18.2
  fi

  if [[ -z "${MINECRAFT_WORLD}" ]]; then
    MINECRAFT_WORLD=world
  fi

  readonly MINECRAFT_SERVER_FILENAME="server_${MINECRAFT_VERSION}.jar"
}

function prepare_directory_structure() {
  mkdir -p "${MINECRAFT_SERVER_DIR}/backups"
  mkdir -p "${MINECRAFT_SERVER_DIR}/versions"
  mkdir -p "${MINECRAFT_SERVER_DIR}/worlds/${MINECRAFT_WORLD}"
}

function download_server_version() {
  readonly SERVERJARS_URL="https://serverjars.com/api/fetchJar/vanilla/${MINECRAFT_VERSION}"

  if [[ -f "${MINECRAFT_SERVER_DIR}/versions/${MINECRAFT_SERVER_FILENAME}" ]]; then
    echo "server version ${MINECRAFT_VERSION} already present"
    return
  fi

  wget -O "${MINECRAFT_SERVER_DIR}/versions/${MINECRAFT_SERVER_FILENAME}" "${SERVERJARS_URL}"
}

function update_server_version() {
  cd "${MINECRAFT_SERVER_DIR}/worlds/${MINECRAFT_WORLD}" || exit 1

  if ! [[ -f "../../versions/${MINECRAFT_SERVER_FILENAME}" ]]; then
    echo "minecraft server file for version ${MINECRAFT_VERSION} cannot be found."
    exit 1
  fi

  rm server.jar
  ln -s "../../versions/${MINECRAFT_SERVER_FILENAME}" server.jar
}

function start_server() {
  cd "${MINECRAFT_SERVER_DIR}/worlds/${MINECRAFT_WORLD}" || exit 1

  if ! [[ -h server.jar ]]; then
    if ! [[ -f "../../versions/${MINECRAFT_SERVER_FILENAME}" ]]; then
      echo "minecraft server file for version ${MINECRAFT_VERSION} cannot be found."
      exit 1
    fi

    ln -s "../../versions/${MINECRAFT_SERVER_FILENAME}" server.jar
  fi

  if ! [[ -f eula.txt ]] || [[ $(grep -c -i 'eula=true' < eula.txt) -eq 0 ]]; then
    echo "eula=true" > eula.txt
  fi

  readonly MINECRAFT_CMD="java -Xms${MINECRAFT_MEMORY_MIN:-1024M} -Xmx${MINECRAFT_MEMORY_MAX:-2048M} -jar server.jar nogui"

  screen -S "${MINECRAFT_WORLD}" -d -m ${MINECRAFT_CMD}
  sleep 1s

  until grep -q 'Done (' < logs/latest.log; do
    echo "waiting for server to be ready..."
    sleep 2s
  done
  echo "minecraft server successfully started"
}

function stop_server() {
  cd "${MINECRAFT_SERVER_DIR}/worlds/${MINECRAFT_WORLD}" || exit 1
  screen -S "${MINECRAFT_WORLD}" -p 0 -X stuff "stop^M"

  until grep -q 'All dimensions are saved' < logs/latest.log; do
    echo "waiting for server to shutdown..."
    sleep 2s
  done
  echo "minecraft server successfully stopped"
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

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -d|--directory) MINECRAFT_SERVER_DIR=${2}; shift ;;
    -h|--help) help && exit 0 ;;
    -m|--mode) MODE=${2}; shift ;;
    -i|--memory-min) MINECRAFT_MEMORY_MIN=${2}; shift ;;
    -a|--memory-max) MINECRAFT_MEMORY_MAX=${2}; shift ;;
    -v|--version) MINECRAFT_VERSION=${2}; shift ;;
    -w|--world) MINECRAFT_WORLD=${2}; shift ;;
    *) echo "argument not found" && exit 1;;
  esac
  shift
done

check_prerequisites
prepare_directory_structure

if [[ "${MODE}" == "start" ]]; then
  download_server_version
  start_server
elif [[ "${MODE}" == "stop" ]]; then
  stop_server
elif [[ "${MODE}" == "backup" ]]; then
  echo "mode '${MODE}' is not yet implemented"
  exit 1
elif [[ "${MODE}" == "update" ]]; then
   stop_server
   download_server_version
   update_server_version
   start_server
else
  echo "unknown mode: ${MODE}"
  exit 1
fi