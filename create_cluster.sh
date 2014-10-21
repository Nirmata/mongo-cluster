#!/bin/bash
sudo docker run --name cfg1 -P -d nirmata/mongodbcfg
sudo docker run --name cfg2 -P -d nirmata/mongodbcfg
sudo docker run --name cfg3 -P -d nirmata/mongodbcfg
export CFG1_PORT=$(sudo docker port cfg1 27019|cut -d : -f2) #49157
export CFG2_PORT=$(sudo docker port cfg2 27019|cut -d : -f2) #49159
export CFG3_PORT=$(sudo docker port cfg3 27019|cut -d : -f2) #49161
sleep 10
sudo docker run --name mongos -P -d -e CONFIG_DBS="192.168.123.165:${CFG1_PORT},192.168.123.165:${CFG2_PORT},192.168.123.165:${CFG3_PORT}" nirmata/mongos
export MONGOS_PORT=$(sudo docker port mongos 27017|cut -d : -f2) 
sudo docker run -d -p 11111:11111 --name=rs11 -e REPL_SET=rs0 -e PRIMARY_IP=192.168.123.165 -e PRIMARY_PORT=11111 -e IS_PRIMARY=1 -e SERVICE_PORT=11111 -e MONGOS_PORT=${MONGO_PORT} -e MONGOS_IP=192.168.123.165 -v /var/log/mongodb/1111:/var/log/supervisor nirmata/mongocluster
sleep 10
sudo docker run -d -p 22222:22222 --name=rs12 -e REPL_SET=rs0 -e PRIMARY_IP=192.168.123.165 -e PRIMARY_PORT=11111 -e HOST_IP=192.168.123.165 -e SERVICE_PORT=22222 -e IS_PRIMARY=0 -e MONGOS_PORT=${MONGOS_PORT} -v /var/log/mongodb/2222:/var/log/supervisor nirmata/mongocluster:latest
sleep 10
sudo docker run -d -p 33333:33333 --name=rs13 -e REPL_SET=rs0 -e PRIMARY_IP=192.168.123.165 -e PRIMARY_PORT=11111 -e HOST_IP=192.168.123.165 -e SERVICE_PORT=33333 -e IS_PRIMARY=0 -e MONGOS_PORT=${MONGOS_PORT} -v /var/log/mongodb/3333:/var/log/supervisor nirmata/mongocluster:latest
