#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# Install OpenSSL for supporting the SSL for Nginx.

echo "$(tput setaf 3)install OpenSSL$(tput sgr 0)"

wget -O openssl.tar.gz -c https://github.com/openssl/openssl/archive/OpenSSL_1_0_2k.tar.gz
tar zxf openssl.tar.gz
mv openssl-OpenSSL_1_0_2k/ openssl

echo "$(tput setaf 3)put the Cloudflare path to OpenSSL$(tput sgr 0)"
git clone https://github.com/cloudflare/sslconfig.git
cd openssl
patch -p1 < ../sslconfig/patches/openssl__chacha20_poly1305_draft_and_rfc_ossl102j.patch
cd ../
