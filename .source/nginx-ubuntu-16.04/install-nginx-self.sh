#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# Install Nginx-self.


echo "$(tput setaf 3)fetch nginx-1.11.9$(tput sgr 0)"
wget -c https://nginx.org/download/nginx-1.11.9.tar.gz
tar zxf nginx-1.11.9.tar.gz
cd nginx-1.11.9/

echo "$(tput setaf 3)apply the Dynamic TLS records path$(tput sgr 0)"
patch -p1 < ../sslconfig/patches/nginx__1.11.5_dynamic_tls_records.patch
cd ../

echo "$(tput setaf 3)install the nginx-1.11.9$(tput sgr 0)"
cd nginx-1.11.9/
./configure --add-module=../ngx_brotli --add-module=../nginx-ct-1.3.2 --with-openssl=../openssl --with-http_v2_module --with-http_ssl_module --with-http_gzip_static_module
make
sudo make install
