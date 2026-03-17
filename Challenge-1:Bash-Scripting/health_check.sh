#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <server_ip_or_hostname> [port]"
    exit 1
fi

SERVER=$1
PORT=${2:-80}
LOGFILE="health_check.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

log_result() {
    echo "[$TIMESTAMP] $1" >> "$LOGFILE"
}

echo "Starting health check for $SERVER..."

if ping -c 1 "$SERVER" > /dev/null 2>&1; then
    RESULT_PING="Server is reachable."
    echo "$RESULT_PING"
else
    echo "Server unreachable"
    log_result "Ping failed: $SERVER is unreachable."
    exit 1
fi

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://$SERVER:$PORT")

if [ "$HTTP_STATUS" -eq 200 ] || [ "$HTTP_STATUS" -eq 301 ] || [ "$HTTP_STATUS" -eq 302 ]; then
    RESULT_HTTP="Web service on port $PORT is UP."
else
    RESULT_HTTP="Web service on port $PORT is DOWN (Status: $HTTP_STATUS)."
fi
echo "$RESULT_HTTP"

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
RESULT_DISK="Disk usage on / is $DISK_USAGE."
echo "$RESULT_DISK"

log_result "Check for $SERVER - $RESULT_PING | $RESULT_HTTP | $RESULT_DISK"

echo "Results logged to $LOGFILE"
