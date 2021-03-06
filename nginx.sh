#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# This script is used for restoring the nginx environment for ubuntu 16.04.

echo "----------------------------------------------------------"
echo " Auto install&configure nginx on ubuntu 16.04"
echo " "
echo " URL: https://blog.dreamtobe.cn/maintain-website-server/"
echo "----------------------------------------------------------"

mkdir nginx-tmp
cd nginx-tmp

bash ../.source/nginx-ubuntu-16.04/0-install-basic-libs.sh
bash ../.source/nginx-ubuntu-16.04/1-install-nginx-ct.sh
bash ../.source/nginx-ubuntu-16.04/2-install-ngx_brotli.sh
bash ../.source/nginx-ubuntu-16.04/3-install-openssl.sh
bash ../.source/nginx-ubuntu-16.04/4-install-nginx-self.sh

cd ..
rm -rf nginx-tmp

cd .source/nginx-ubuntu-16.04/
bash config-auto-start.sh
bash config-nginx-default-setting.sh
cd ../../

echo "$(tput setaf 2)if you want to enable http2, please configure your conf like:\nlisten 443 ssl http2;$(tput sgr 0)"
echo "$(tput setaf 2)now, it's it:$(tput sgr 0)"
service nginx start
service nginx status
