#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# Install Nginx-self.


echo "$(tput setaf 3)enable start nginx when user login the system automatically$(tput sgr 0)"
sudo cp source-auto-start /etc/init.d/nginx
sudo chmod a+x /etc/init.d/nginx
sudo update-rc.d -f nginx defaults
