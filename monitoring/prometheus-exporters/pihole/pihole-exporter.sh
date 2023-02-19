#!/bin/bash
API_TOKEN=$(awk -F= -v key="WEBPASSWORD" '$1==key {print $2}' /etc/pihole/setupVars.conf) 
/usr/bin/pihole_exporter -pihole_hostname localhost -pihole_api_token $API_TOKEN