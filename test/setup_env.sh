#!/bin/bash
set -e

emqx_ids=`ps aux|grep "emqx" | grep "/usr/bin"|awk '{printf $2 " "}'`
if [ "$emqx_ids" = "" ] ; then
  echo "No emqx broker was started"
  emqx start
  echo "Success started emqx "
else
  echo "emqx has already started"
  #for pid in $emqx_ids ; do
    #echo "kill emqx: " $pid
    #kill -9 $pid
  #done
fi

pids=`ps aux|grep "kuiperd" | grep "bin"|awk '{printf $2 " "}'`
if [ "$pids" = "" ] ; then
   echo "No kuiper server was started"
else
  for pid in $pids ; do
    echo "kill kuiper " $pid
    kill -9 $pid
  done
fi

test/start_kuiper.sh

chmod +x test/build_edgex_mock.sh
test/build_edgex_mock.sh

pids=`ps aux | grep http_server | grep "./" | awk '{printf $2 " "}'`
if [ "$pids" = "" ] ; then
   echo "No http mockup server was started"
else
  for pid in $pids ; do
    echo "kill http mockup server " $pid
    kill -9 $pid
  done
fi

test/prepare_plugins.sh
