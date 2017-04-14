#!/bin/bash

# you may change these according to your needs
APP_POOL_PATH=/home/gitlab-runner/review-apps/
STARTUP_TIMEOUT=60

if [ -n "$1" ]
then
  vhost_name=$1

  # as well as this path to Puma pid
  pid_path=$APP_POOL_PATH$vhost_name/tmp/pids/puma.pid

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

else
  echo "Usage: $(basename $0) virtual_host_name"
  exit 1
fi
