#!/bin/bash

function check_prerequisites() {
  if [[ -z ${DEVICE} ]]; then
    echo "no device provided"
    exit 1
  fi

  if [[ -z ${MODE} ]]; then
    MODE=short
  fi

  if [[ -z ${MAIL_RECIPIENT} ]]; then
    echo "no recipient provided"
    exit 1
  fi
}

function run_test() {
  /usr/sbin/smartctl -t "${MODE}" "${DEVICE}"
}

while getopts d:m:r: opt
do
    case "${opt}" in
        d) DEVICE=${OPTARG};;
        m) MODE=${OPTARG};;
        r) MAIL_RECIPIENT=${OPTARG};;
        *) echo "argument not found" && exit 1;;
    esac
done

check_prerequisites
run_test