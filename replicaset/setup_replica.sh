#!/bin/bash

OPTIONS=${OPTIONS:=""}
REPL_SET=${REPL_SET}
PRIMARY_IP=${PRIMARY_IP}
PRIMARY_PORT=${PRIMARY_PORT}
LOG_PATH=${LOG_PATH}

HOST_IP=${HOST_IP}
SERVICE_PORT=${SERVICE_PORT:=27017}
IS_PRIMARY=${IS_PRIMARY:=0}

MONGOS_IP=${MONGOS_IP}
MONGOS_PORT=${MONGOS_PORT}

echo "Replica IP: $HOST_IP:$SERVICE_PORT"
echo "Replica set: $REPL_SET"
echo "Primary Ip: $PRIMARY_IP:$PRIMARY_PORT"
echo "Mongos Ip: $MONGOS_IP:$MONGOS_PORT"
echo "Is Primary: $IS_PRIMARY"

if [ $IS_PRIMARY == 0 ]; then
   sleep 15
   echo "Initiate the replica set"
   /usr/bin/mongo ${PRIMARY_IP}:${PRIMARY_PORT} --eval "printjson(rs.initiate())"
   sleep 10
   /usr/bin/mongo ${PRIMARY_IP}:${PRIMARY_PORT} --eval "printjson(rs.status())"
   sed -i -e  "s/REPLICA_IP/${HOST_IP}/g" -e "s/REPLICA_PORT/${SERVICE_PORT}/g" /addReplica.js
   sed -i -e  "s/HOST_IP/${PRIMARY_IP}/g" -e "s/SERVICE_PORT/${PRIMARY_PORT}/g" /configurePrimary.js
   cat addReplica.js   
   echo "Adding member..."
   /usr/bin/mongo ${PRIMARY_IP}:${PRIMARY_PORT} addReplica.js
   sleep 10
   #/usr/bin/mongo ${PRIMARY_IP}:${PRIMARY_PORT} configurePrimary.js
   echo "Getting replica status"
   /usr/bin/mongo ${PRIMARY_IP}:${PRIMARY_PORT} --eval "printjson(rs.status())"
   /usr/bin/mongo ${PRIMARY_IP}:${PRIMARY_PORT} --eval "printjson(rs.conf())"
   sed -i -e "s/REPL_SET/${REPL_SET}/g" -e "s/PRIMARY_IP/${PRIMARY_IP}/g" -e "s/PRIMARY_PORT/${PRIMARY_PORT}/g" addShard.js
	cat addShard.js
	echo "adding shard.."
        /usr/bin/mongo ${MONGOS_IP}:${MONGOS_PORT} addShard.js
	echo "added to shard..."
fi

