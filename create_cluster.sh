#!/bin/bash
# Remove all containers
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)
# Config server connection Port
CONFIG_PORT=${CONFIG_PORT:=27019}
MONGOD_PORT=${MONGOD_PORT:=27017}
HOST_IP=$(hostname -I | cut -d ' '  -f1)
REPL_SET=1

# Starting three config servers for cluster
for(( i=1; i <=3; i++ ))
do
sudo docker run --name cfg$i -P -d nirmata/mongodbcfg
export CFG_PORT$i=$(sudo docker port cfg$i ${CONFIG_PORT}|cut -d : -f2) #49157
done
# Wait for configservers to start
sleep 10
# Starting mongos with three configservers
sudo docker run --name mongos -P -d -e CONFIG_DBS="${HOST_IP}:${CFG_PORT1},${HOST_IP}:${CFG_PORT2},${HOST_IP}:${CFG_PORT3}" nirmata/mongos
export MONGO_PORT=$(sudo docker port mongos ${MONGOD_PORT}|cut -d : -f2)

# Starting replica set1 servers
for(( i=1;i<=3;i++ ))
do
PORT=$i$i$i$i$i
if [ "$i" == "1" ]; then # First server in the set is primary
        IS_PRIMARY=1
        PRIMARY_PORT=$PORT
else
        IS_PRIMARY=0
fi
sudo docker run -d -p $PORT:$PORT --name=rs${REPL_SET}${i} -e REPL_SET=rs${REPL_SET} -e PRIMARY_IP=${HOST_IP} -e PRIMARY_PORT=$PRIMARY_PORT -e IS_PRIMARY=$IS_PRIMARY -e SERVICE_PORT=$PORT -e MONGOS_PORT=${MONGO_PORT} -e MONGOS_IP=${HOST_IP} -e HOST_IP=${HOST_IP} -v /var/log/mongodb/$PORT:/var/log/supervisor nirmata/mongocluster
# Wait for server to start
sleep 15
done
