#!/bin/bash

function check_prerequisites() {
  if [[ -z ${DEVICE} ]]; then
    echo "no device provided"
    exit 1
  fi

  if [[ -z ${MAIL_RECIPIENT} ]]; then
    echo "no email provided"
    exit 1
  fi
}

function provide_result() {
  TEST_STATUS=$(/usr/sbin/smartctl -a "${DEVICE}" | grep 'test result' | awk '{print $6}')
  /usr/sbin/smartctl -a "${DEVICE}" | mail -s "SMART '/dev/sda' ${TEST_STATUS}" "${MAIL_RECIPIENT}"
}

while getopts d:r: opt
do
    case "${opt}" in
        d) DEVICE=${OPTARG};;
        r) MAIL_RECIPIENT=${OPTARG};;
        *) echo "argument not found" && exit 1;;
    esac
done

check_prerequisites
provide_result