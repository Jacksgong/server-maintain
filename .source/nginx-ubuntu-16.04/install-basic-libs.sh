#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# Install necessary libs for nginx.

echo "$(tput setaf 3)start install basic libs$(tput sgr 0)"

sudo apt-get update
sudo apt-get install build-essential libpcre3 libpcre3-dev zlib1g-dev unzip git
