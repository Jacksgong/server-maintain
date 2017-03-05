#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# Install nginx-ct for launching the Certificate Transparency function.

echo "$(tput setaf 3)start fetch nginx-ct$(tput sgr 0)"

wget -O nginx-ct.zip -c https://github.com/grahamedgecombe/nginx-ct/archive/v1.3.2.zip
unzip nginx-ct.zip

installed_path="$(ls nginx-ct)"
if [ ! -z "$installed_path" -a "$installed_path" != " " ]; then
  echo "$(tput setaf 3)unzip nginx-ct successfully!$(tput sgr 0)"
fi
