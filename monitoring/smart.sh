#!/bin/bash

function help() {
  echo ""
  echo "-d  --device        specify device to be used"
  echo "-h  --help          show help"
  echo "-m  --mode          specify mode to be used [test|result]"
  echo "                    test:      run new test"
  echo "                    result:    provide test results"
  echo "-r  --recipient     specify recipient (email) to be notified when using result mode [-m result]"
  echo "-t  --test-mode     specify smart test mode to be used [short|long]"
}

function check_prerequisites() {
  if [[ -z ${DEVICE} ]]; then
    echo "no device provided"
    exit 1
  fi
}

function check_prerequisites_test() {
  if [[ -z ${MODE} ]]; then
    MODE=short
  fi
}

function check_prerequisites_result() {
  if [[ -z ${MAIL_RECIPIENT} ]]; then
    echo "no recipient provided"
    exit 1
  fi
}

function run_test() {
  /usr/sbin/smartctl -t "${TEST_MODE}" "${DEVICE}"
}

function provide_result() {
  TEST_STATUS=$(/usr/sbin/smartctl -a "${DEVICE}" | grep 'test result' | awk '{print $6}')
  /usr/sbin/smartctl -a "${DEVICE}" | mail -s "SMART '${DEVICE}' ${TEST_STATUS}" "${MAIL_RECIPIENT}"
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--device) DEVICE=${2}; shift ;;
        -h|--help) help && exit 0 ;;
        -m|--mode) MODE=${2}; shift ;;
        -t|--test-mode) TEST_MODE=${2}; shift ;;
        -r|--recipient) MAIL_RECIPIENT=${2}; shift ;;
        *) echo "argument not found" && exit 1;;
    esac
    shift
done

if [[ "${MODE}" == "test" ]]; then
  check_prerequisites
  check_prerequisites_test
  run_test
elif [[ "${MODE}" == "result" ]]; then
  check_prerequisites
  check_prerequisites_result
  provide_result
else
  echo "unknown mode: ${MODE}"
  exit 1
fi