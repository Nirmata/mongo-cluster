#!/bin/bash

OPTIONS=${OPTIONS:=""}
REPL_SET=${REPL_SET}
PRIMARY_IP=${PRIMARY_IP}
PRIMARY_PORT=${PRIMARY_PORT}
LOG_PATH=${LOG_PATH}

HOST_IP=${HOST_IP}
SERVICE_PORT=${SERVICE_PORT:=27017}
IS_PRIMARY=${IS_PRIMARY:="false"}

# Start mongo and log
echo "Starting mongod in foreground"
/usr/bin/mongod --replSet ${REPL_SET} $OPTIONS --port $SERVICE_PORT
