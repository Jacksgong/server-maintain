#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# Install ngx_brotli for supporting the compress algorithm Brotli from Google.

echo "$(tput setaf 3)start install ngx_brotli$(tput sgr 0)"

sudo apt-get install autoconf libtool automake
git clone https://github.com/bagder/libbrotli
cd libbrotli
./autogen.sh
./configure
make
sudo make install
cd  ../

installed_path="$(ls /usr/local/lib/libbrotlienc.so.1)"
if [ ! -z "$installed_path" -a "$installed_path" != " " ]; then
  echo "$(tput setaf 3)install brotli successfully!$(tput sgr 0)"
fi

echo "$(tput setaf 3)fetch ngx_brotli$(tput sgr 0)"
git clone https://github.com/google/ngx_brotli.git
cd ngx_brotli
git submodule update --init
cd ../
