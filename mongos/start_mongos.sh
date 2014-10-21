#!/bin/bash

echo ${CONFIG_DBS}
CONFIG_DBS=${CONFIG_DBS:=""}
echo ${CONFIG_DBS}
sleep 15
/usr/bin/mongos --configdb ${CONFIG_DBS}
