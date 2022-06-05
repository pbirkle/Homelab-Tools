#!/bin/bash

function print_usage() {
  bold='\033[1m'
  reset="\e[0m"
  echo ""
  echo " |----------------------------------------------------------------------------------------------|"
  echo -e " | ${bold}Parameter${reset}  | ${bold}Mandatory${reset} | ${bold}Comment${reset}                                                             |"
  echo " |----------------------------------------------------------------------------------------------|"
  echo " | -d [value] | no        | path to destination directory (default: '/')                        |"
  echo " |----------------------------------------------------------------------------------------------|"
  echo " | -p [value] | yes       | path to restic password file                                        |"
  echo " |----------------------------------------------------------------------------------------------|"
  echo " | -r [value] | yes       | path to restic repository                                           |"
  echo " |----------------------------------------------------------------------------------------------|"
  echo ""
}

# $1: error statement
function print_error() {
  red="\e[0;91m"
  reset="\e[0m"
  echo -e "${red}${1}${reset}"
}

function check() {

  if [[ -z ${RESTIC_PASSWORD_FILE} ]]; then
    print_error "no restic password file set (see -p flag)"
    print_usage
    exit 1
  fi

  if ! [[ -e "${RESTIC_PASSWORD_FILE}" ]]; then
    print_error "restic password file does not exist"
    print_usage
    exit 1
  fi

  if [[ -z ${RESTIC_REPO} ]]; then
    print_error "no restic repository set (see -r flag)"
    print_usage
    exit 1
  fi

  if [[ -z ${DESTINATION} ]]; then
    DESTINATION="/"
  fi
}

function choose_snapshot() {
  restic --repo "${RESTIC_REPO}" --password-file "${RESTIC_PASSWORD_FILE}" snapshots
  echo ""
  read -r -p 'please provide snapshot id to restore: ' RESTIC_SNAPSHOT_ID
  echo ""

  if [[ -z "${RESTIC_SNAPSHOT_ID}" ]]; then
    print_error "no restic snapshot id provided"
    exit 1
  fi
}

function restore() {
  echo ""
  echo "start restore of ${DESTINATION}"
  if restic --repo "${RESTIC_REPO}" --password-file "${RESTIC_PASSWORD_FILE}" --destination "${DESTINATION}" restore "${RESTIC_SNAPSHOT_ID}" > /dev/null 2>&1; then
    echo "restore of ${DESTINATION} successful"
  else
    print_error "backup of ${DESTINATION} failed"
  fi
  echo ""
}

while getopts d:p:r: option; do
  case "${option}" in
  d) DESTINATION=${OPTARG} ;;
  p) RESTIC_PASSWORD_FILE=${OPTARG} ;;
  r) RESTIC_REPO=${OPTARG} ;;
  *) print_usage && exit 1 ;;
  esac
done

check
choose_snapshot
restore
