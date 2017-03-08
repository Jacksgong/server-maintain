#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# This script is used for checking whether bbr has been enabled on ubuntu 16.04.

echo "-------------------------------------------------------"
echo " Auto checking whether bbr is working on ubuntu 16.04"
echo "\n URL: https://blog.dreamtobe.cn/maintain-website-server/"
echo "-------------------------------------------------------"

uname="$(uname -r)"
if [[ $uname == *"4.10"* ]]; then
        echo "$(tput setaf 3)bbr check: uname seams $(tput setaf 2)right$(tput sgr 0): $uname"
else
        echo "$(tput setaf 3)bbr check: uname seams $(tput setaf 1)wrong$(tput sgr 0): $uname"
fi

available_congestion_control="$(sysctl net.ipv4.tcp_available_congestion_control)"
if [[ $available_congestion_control == *"bbr"* ]]; then
        echo "$(tput setaf 3)bbr check: available tcp congestion control seams $(tput setaf 2)right$(tput sgr 0): $available_congestion_control"
else
        echo "$(tput setaf 3)bbr check: available tcp congestion control seams $(tput setaf 1)wrong$(tput sgr 0): $available_congestion_control"
fi

congestion_control="$(sysctl net.ipv4.tcp_congestion_control)"
if [[ $congestion_control == *"bbr"* ]]; then
        echo "$(tput setaf 3)bbr check: tcp congestion control seams $(tput setaf 2)right$(tput sgr 0): $congestion_control"
else
        echo "$(tput setaf 3)bbr check: tcp congestion control seams $(tput setaf 1)wrong$(tput sgr 0): $congestion_control"
fi

default_qdisc="$(sysctl net.core.default_qdisc)"
if [[ $default_qdisc == *"fq"* ]]; then
        echo "$(tput setaf 3)bbr check: default qdisc seams $(tput setaf 2)right$(tput sgr 0): $default_qdisc"
else
        echo "$(tput setaf 3)bbr check: default qdisc seams $(tput setaf 1)wrong$(tput sgr 0): $default_qdisc"
fi

lsmod="$(lsmod | grep bbr)"
if [[ $lsmod == *"tcp_bbr"* ]]; then
        echo "$(tput setaf 3)bbr check: lsmod seams $(tput setaf 2)right$(tput sgr 0): $lsmod"
else
        echo "$(tput setaf 3)bbr check: lsmod seams $(tput setaf 1)wrong$(tput sgr 0): $lsmod"
fi
