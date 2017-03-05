#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# This script is used for restoring the nginx environment for ubuntu 16.04.

mkdir init-nginx
cd init-nginx

bash .source/nginx-ubuntu-16.04/install-basic-libs.sh
bash .source/nginx-ubuntu-16.04/install-nginx-ct.sh
bash .source/nginx-ubuntu-16.04/install-ngx_brotli.sh
bash .source/nginx-ubuntu-16.04/install-openssl.sh
bash .source/nginx-ubuntu-16.04/install-nginx-self.sh

cd ..
rm -rf init-nginx

bash .source/nginx-ubuntu-16.04/config-auto-start.sh
bash .source/nginx-ubuntu-16.04/config-nginx-default-setting.sh

echo "$(tput setaf 2)if you want to enable http2, please configure your conf like:\nlisten 443 ssl http2;$(tput sgr 0)"
echo "$(tput setaf 2)now, it's it:$(tput sgr 0)"
service nginx start
service nginx status
