#/bin/sh

prepare () {
    if [ -z "${1}" ]; then
        echo "hostname was not provided"
        exit 1
    fi

    cd ~
    HOSTNAME=$1
    DYNV6_DIR=".dynv6/${HOSTNAME}"
    IPv4_OLD_FILE="${DYNV6_DIR}/ipv4"
    IPv6_OLD_FILE="${DYNV6_DIR}/ipv6"
    mkdir -p ${DYNV6_DIR}

    if [ -e "${DYNV6_DIR}/api_token" ]; then
        DYNV6_API_TOKEN=$(head -n 1 "${DYNV6_DIR}/api_token")
    else
        read -r -p 'provide dynv6 api token: ' DYNV6_API_TOKEN
        echo ""

        echo "${DYNV6_API_TOKEN}" > "${DYNV6_DIR}/api_token"
        chmod 600 "${DYNV6_DIR}/api_token"
    fi
}

update_ipv4 () {
    IPv4=$(curl -fsS ifconfig.me/ip)

    if [ -z "${IPv4}" ]; then
        echo "IPv4 address not found, skipping..."
        echo ""
        return
    else
        echo "current IPv4 address is: ${IPv4}"
    fi
    if [ -e "${IPv4_OLD_FILE}" ]; then
        IPv4_OLD=$(head -n 1 ${IPv4_OLD_FILE})
    fi
    if [ "${IPv4}" == "${IPv4_OLD}" ]; then
        echo "IPv4 address didn't change since last update, skipping..."
        echo ""
        return
    fi
    
    curl -fsS "http://ipv4.dynv6.com/api/update?hostname=${HOSTNAME}&ipv4=${IPv4}&token=${DYNV6_API_TOKEN}"
    
    echo ""
    echo "${IPv4}" > ${IPv4_OLD_FILE}
    echo ""
}

update_ipv6 () {
    IPv6=$(ip -6 addr list scope global | grep -v " fd" | sed -n 's/.*inet6 \([0-9a-f:]\+\).*/\1/p' | head -n 1)

    if [ -z "${IPv6}" ]; then
        echo "IPv6 address not found, skipping..."
        echo ""
        return
    else
        echo "current IPv6 address is: ${IPv6}"
    fi
    if [ -e "${IPv6_OLD_FILE}" ]; then
        IPv6_OLD=$(head -n 1 ${IPv6_OLD_FILE})
    fi
    if [ "${IPv6}" == "${IPv6_OLD}" ]; then
        echo "IPv6 address didn't change since last update, skipping..."
        echo ""
        return
    fi

    curl -fsS "http://dynv6.com/api/update?hostname=${HOSTNAME}&ipv6=${IPv6}&token=${DYNV6_API_TOKEN}"

    echo ""
    echo "${IPv6}" > ${IPv6_OLD_FILE}
    echo ""
}

prepare $1
update_ipv4
update_ipv6