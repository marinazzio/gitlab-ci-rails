#!/bin/bash

app_pool_path=/home/gitlab-runner/review-apps/
nginx_vhosts_path=/home/gitlab-runner/nginx-review-sites/

if [ -n "$1" ]
then
  vhost_name=$1

  app_path=$app_pool_path$vhost_name

  rm -rf $app_path
  rm ${nginx_vhosts_path}${vhost_name}.conf

  sudo /usr/sbin/service nginx reload
else
  echo "Usage: $(basename $0) virtual_host_name"
  exit 1
fi

