#!/bin/bash

function print_usage() {
  bold='\033[1m'
  reset="\e[0m"
  echo ""
  echo " |----------------------------------------------------------------------------------------------|"
  echo -e " | ${bold}Parameter${reset}  | ${bold}Mandatory${reset} | ${bold}Comment${reset}                                                             |"
  echo " |----------------------------------------------------------------------------------------------|"
  echo " | -d [value] | no        | number of daily backups to keep                                     |"
  echo " |                        | default: 31                                                         |"
  echo " |----------------------------------------------------------------------------------------------|"
  echo " | -h [value] | no        | number of hourly backups to keep                                    |"
  echo " |                        | default: 1                                                          |"
  echo " |----------------------------------------------------------------------------------------------|"
  echo " | -m [value] | no        | number of monthly backups to keep                                   |"
  echo " |                        | default: 3                                                          |"
  echo " |----------------------------------------------------------------------------------------------|"
  echo " | -p [value] | yes       | path to restic password file                                        |"
  echo " |----------------------------------------------------------------------------------------------|"
  echo " | -r [value] | yes       | path to restic repository                                           |"
  echo " |----------------------------------------------------------------------------------------------|"
  echo " | -s [value] | yes       | path to source directory or source file, can be used multiple times |"
  echo " |----------------------------------------------------------------------------------------------|"
  echo ""
}

# $1: error statement
# $2: skip print of date (yes|y) [optional]
function print_error() {
  red="\e[0;91m"
  reset="\e[0m"
  if [[ ${2} != "yes" ]] && [[ ${2} != "y" ]]; then
    echo -e "${red}$(date +"%Y-%m-%d %H:%M:%S") ${1}${reset}"
  else
    echo -e "${red}${1}${reset}"
  fi
}

# $1: log statement (print without date when empty)
function print_log() {
  if [[ -n ${1} ]]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") ${1}"
  else
    echo "${1}"
  fi
}

function check() {
  if ! [[ ${RESTIC_KEEP_HOURLY} =~ ^[0-9]+$ ]] ; then
    print_error "keep hourly must be a number" "y"
    exit 1
  fi

  if ! [[ ${RESTIC_KEEP_DAILY} =~ ^[0-9]+$ ]] ; then
    print_error "keep daily must be a number" "y"
    exit 1
  fi

  if ! [[ ${RESTIC_KEEP_MONTHLY} =~ ^[0-9]+$ ]] ; then
    print_error "keep monthly must be a number" "y"
    exit 1
  fi

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

  if [[ ${#SOURCES[@]} -lt 1 ]]; then
    print_error "no source directories set (see -s flag)"
    print_usage
    exit 1
  fi

  # fail if connection to restic repository cannot be established
  if ! restic --repo "${RESTIC_REPO}" --password-file "${RESTIC_PASSWORD_FILE}" cat config >/dev/null; then
    print_error "connection to restic repsitory cannot be established"
    exit 1
  fi

  if restic --repo "${RESTIC_REPO}" --password-file "${RESTIC_PASSWORD_FILE}" init >/dev/null 2>&1; then
    print_log "restic repository initialized"
  else
    print_log "restic repository already exists"
  fi
}

function backup() {
  for SOURCE in "${SOURCES[@]}"; do
    print_log ""
    print_log "start backup of ${SOURCE}"
    if restic --repo "${RESTIC_REPO}" --password-file "${RESTIC_PASSWORD_FILE}" backup "${SOURCE}"; then
      print_log "backup of ${SOURCE} successful"
    else
      print_error "backup of ${SOURCE} failed"
      exit 1
    fi
  done
  print_log ""
}

function forget() {
  restic --repo "${RESTIC_REPO}" --password-file "${RESTIC_PASSWORD_FILE}" forget --keep-hourly "${RESTIC_KEEP_HOURLY}" --keep-daily "${RESTIC_KEEP_DAILY}" --keep-monthly "${RESTIC_KEEP_MONTHLY}"
}

RESTIC_KEEP_HOURLY=1
RESTIC_KEEP_DAILY=31
RESTIC_KEEP_MONTHLY=3

while getopts d:h:m:p:r:s: option; do
  case "${option}" in
  d) RESTIC_KEEP_DAILY=${OPTARG} ;;
  h) RESTIC_KEEP_HOURLY=${OPTARG} ;;
  m) RESTIC_KEEP_MONTHLY=${OPTARG} ;;
  p) RESTIC_PASSWORD_FILE=${OPTARG} ;;
  r) RESTIC_REPO=${OPTARG} ;;
  s) SOURCES=("${SOURCES[@]}" "${OPTARG}") ;;
  *) print_usage && exit 1 ;;
  esac
done

check
backup
forget
