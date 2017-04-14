#!/bin/bash

app_pool_path=/home/gitlab-runner/review-apps/
nginx_vhosts_path=/home/gitlab-runner/nginx-review-sites/

if [ -n "$1" ]
then
  vhost_name=$1

  app_path=$app_pool_path$vhost_name

  mkdir -p $app_path
  mkdir -p $nginx_vhosts_path

  cat > ${nginx_vhosts_path}${vhost_name}.conf << EOF
upstream rails_app_$vhost_name {
    server unix://$app_path/tmp/sockets/puma.sock;
}

server {
    listen 80;
    server_name $vhost_name.example.com;
    root $app_path/public;

    index index.html index.htm;

    charset utf-8;

    try_files $uri $uri/index.html @rails_app_$vhost_name;

    access_log /var/log/nginx/$vhost_name-access.log;
    error_log  /var/log/nginx/pages-error.log debug;

    location @rails_app_$vhost_name {
        proxy_set_header X-Forwarder-FOR \$proxy_add_x_forwarded_for;
        proxy_set_header Host \$http_host;
        proxy_redirect off;

        proxy_pass http://rails_app_$vhost_name;
    }
}
EOF

  sudo /usr/sbin/service nginx reload

  pid_file=/home/gitlab-runner/review-apps/$vhost_name/tmp/pids/puma.pid

  if [ -f $pid_file ]
  then
    bundle exec pumactl --pidfile $pid_file stop
  fi

else
  echo "Usage: $(basename $0) virtual_host_name"
  exit 1
fi

