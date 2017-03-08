#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# This script is used for enable UFW on ubuntu 16.04.

echo "--------------------------------------------------"
echo " Auto configure UFW on ubuntu 16.04"
echo "\n URL: https://blog.dreamtobe.cn/maintain-website-server/"
echo "--------------------------------------------------"

# Check whether UFW has been uninstalled and install it if yes.
sudo apt-get install ufw

# Deny incoming and allow outgoing connection
sudo ufw default deny incoming
sudo ufw default allow outgoing

# allow SSH connections
sudo ufw allow ssh
sudo ufw enable

# allow http and https connections
sudo ufw allow http
sudo ufw allow https

# prompt ipv6
ipv6="$(cat /etc/default/ufw | IPV6=yes)"
if [ -z "$ipv6" -a "$ipv6" = " " ]; then
  #sudo -- sh -c "echo IPV6=yes>> /etc/default/ufw"
  cat /etc/default/ufw | IPV6
  echo "$(tput setaf 3)please consider to enable IPV6 through add IPV6=yes on /etc/default/ufw$(tput sgr 0)"
fi

# check the status of UFW
sudo ufw status verbose
