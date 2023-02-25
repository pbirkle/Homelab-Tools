#!/bin/bash

function usage() {
    echo "ARGUMENTS          | MANDATORY | DECRIPTION"
    echo "------------------------------------------------------------------------------"
    echo "-h   --help        |           | show help"
    echo "-l   --login-token |           | login token for authorization"
    echo "-m   --message     |     x     | message to display"
    echo "-p   --priority    |           | priority of the notification"
    echo "-t   --title       |           | title of the notification"
    echo "-T   --tags        |           | tags of the notification"
    echo "-u   --url         |     x     | url of the ntfy instance including the topic"
}

function die() {
    printf '%s\n' "${1}" >&2
    exit 1
}

function checks() {
    if ! command -v curl >/dev/null; then
        echo "curl not found, please install"
        exit 1
    fi

    if [[ -z "${NTFY_URL}" ]]; then
        echo "ntfy url (including topic) not provided [e.g. https://ntfy.sh/YOUR_TOPIC]"
        echo ""
        usage
        exit 1
    fi

    if [[ -z "${NTFY_MESSAGE}" ]]; then
        echo "message not provided"
        echo ""
        usage
        exit 1
    fi
}

function publish_notification() {
    HEADERS=()

    if [[ -n "${NTFY_TOKEN}" ]]; then
        HEADERS+=(-H "Authorization: Bearer ${NTFY_TOKEN}")
    fi

    if [[ -n "${NTFY_PRIORITY}" ]]; then
        HEADERS+=(-H "X-Priority: ${NTFY_PRIORITY}")
    fi

    if [[ -n "${NTFY_TITLE}" ]]; then
        HEADERS+=(-H "X-Title: ${NTFY_TITLE}")
    fi

    if [[ -n "${NTFY_TAGS}" ]]; then
        HEADERS+=(-H "X-Tags: ${NTFY_TAGS}")
    fi

    curl -s -S "${HEADERS[@]}" -d "${NTFY_MESSAGE}" "${NTFY_URL}" > /dev/null
}

NTFY_MESSAGE=
NTFY_PRIORITY=
NTFY_TAGS=
NTFY_TITLE=
NTFY_TOKEN=
NTFY_URL=

while [[ $# -gt 0 ]] ; do
    case ${1} in
    -h | -\? | --help)
        usage
        exit 0
        ;;

    -l | --login-token)
        if [[ -z ${2} ]]; then die "ERROR: -l and --login-token require a non-empty option argument"; fi
        NTFY_TOKEN=${2}
        shift
        ;;
    -l=?* | --login-token=?*)
        NTFY_TOKEN=${1#*=}
        ;;
    -l= | --login-token=)
        die "ERROR: -l and --login-token require a non-empty option argument"
        ;;

    -m | --message)
        if [[ -z ${2} ]]; then die "ERROR: -m and --message require a non-empty option argument"; fi
        NTFY_MESSAGE=${2}
        shift
        ;;
    -m=?* | --message=?*)
        NTFY_MESSAGE=${1#*=}
        ;;
    -m= | --message=)
        die "ERROR: -m and --message require a non-empty option argument"
        ;;

    -p | --priority)
        if [[ -z ${2} ]]; then die "ERROR: -p and --priority require a non-empty option argument"; fi
        NTFY_PRIORITY=${2}
        shift
        ;;
    -p=?* | --priority=?*)
        NTFY_PRIORITY=${1#*=}
        ;;
    -p= | --priority=)
        die "ERROR: -p and --priority require a non-empty option argument"
        ;;

    -t | --title)
        if [[ -z ${2} ]]; then die "ERROR: -t and --title require a non-empty option argument"; fi
        NTFY_TITLE=${2}
        shift
        ;;
    -t=?* | --title=?*)
        NTFY_TITLE=${1#*=}
        ;;
    -t= | --title=)
        die "ERROR: -t and --title require a non-empty option argument"
        ;;

    -T | --tags)
        if [[ -z ${2} ]]; then die "ERROR: -T and --tags require a non-empty option argument"; fi
        NTFY_TAGS=${2}
        shift
        ;;
    -T=?* | --tags=?*)
        NTFY_TAGS=${1#*=}
        ;;
    -T= | --tags=)
        die "ERROR: -T and --tags require a non-empty option argument"
        ;;

    -u | --url)
        if [[ -z ${2} ]]; then die "ERROR: -u and --url require a non-empty option argument"; fi
        NTFY_URL=${2}
        shift
        ;;
    -u=?* | --url=?*)
        NTFY_URL=${1#*=}
        ;;
    -u= | --url=)
        die "ERROR: -u and --url require a non-empty option argument"
        ;;

    --)
        shift
        break
        ;;
    -?*)
        printf 'WARN: Unknown option (ignored): %s\n\n' "${1}" >&2
        usage
        exit 1
        ;;
    *)
        break
        ;;
    esac
    shift
done

checks
publish_notification