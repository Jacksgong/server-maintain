#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# Install Nginx-self.


echo "$(tput setaf 3)replace the nginx configuration file for\n enable gzip、brotli\nlet nginx running on the www-data user\nall singleton nginx-conf on the /etc/nginx/sites-enabled folder$(tput sgr 0)"
echo "$(tput setaf 2)tips: you can restore the default one through replacing with the /usr/local/nginx/conf/nginx.conf.default$(tput sgr 0)"
sudo rm /usr/local/nginx/conf/nginx.conf
sudo cp source-nginx.conf /usr/local/nginx/conf/nginx.conf
sudo chown www-data:www-data /usr/local/nginx/conf/nginx.conf
sudo mkdir /etc/nginx
sudo mkdir /etc/nginx/sites-available
sudo mkdir /etc/nginx/sites-enabled

echo "$(tput setaf 2)"
sudo ls /etc/nginx/
echo "$(tput setaf 0)"

sudo ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/nginx
