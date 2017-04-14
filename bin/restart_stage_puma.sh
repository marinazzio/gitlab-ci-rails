#!/bin/bash

app_dir=$(pwd)

STARTUP_TIMEOUT=30
pid_file=$app_dir/tmp/pids/puma.pid
socket=unix://$app_dir/tmp/sockets/puma.sock

if [ -f $pid_file ]
then
  bundle exec pumactl --pidfile $pid_file restart
else
  bundle exec bundle exec puma -d -e stage -b $socket --pidfile $pid_file
fi

i=0
while [ ! -f $pid_path ] && [ $i -le $STARTUP_TIMEOUT ]
do
  i=$((i+1))
  sleep 1
done

if [ ! -f $pid_path ]
then
  echo "PID ${pid_path} not found in ${i} seconds..."
  exit 2
else
  echo "It seems that Puma was started in ${i} seconds SUCCESSFUL!"
  exit 0
fi
