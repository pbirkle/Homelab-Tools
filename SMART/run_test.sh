#!/bin/bash

function check_prerequisites() {
  if [[ -z ${DEVICE} ]]; then
    echo "no device provided"
    exit 1
  fi

  if [[ -z ${MODE} ]]; then
    MODE=short
  fi
}

function run_test() {
  /usr/sbin/smartctl -t "${MODE}" "${DEVICE}"
}

while getopts d:m: opt
do
    case "${opt}" in
        d) DEVICE=${OPTARG};;
        m) MODE=${OPTARG};;
        *) echo "argument not found" && exit 1;;
    esac
done

check_prerequisites
run_test