#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# This script is used for config swap on ubuntu 16.04.

echo "$(tput setaf 3)the current swap status:$(tput sgr 0)"
sudo swapon --show
free -h

while true; do
    read -p "do you want to continue to configure swap?(y/n)" yn
    case $yn in
        [Yy]* ) echo "$(tput setaf 3)the current space usage:$(tput sgr 0)"; df -h; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

read -p "$(tput setaf 3)normally large than 4G is useless, and best choise is equal to or double the amount of RAM\nhow much spaces do you want to use for swap(eg(if you want 1G): 1G)\n:$(tput sgr 0)" swap_size

echo "allocate $swap_size swap space to /swapfile"
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
ls -lh /swapfile

echo "make the /swapfile to be a swap space"
sudo mkswap /swapfile
sudo swapon /swapfile

echo "$(tput setaf 3)now, the current swap status is:$(tput sgr 0)"
sudo swapon --show
free -h

echo "persistent the swap"
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

while true; do
    read -p "do you want to optimize some params about swap(swappiness、vfs_cache_pressure)?(y/n)" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "the current swappiness value is:"
cat /proc/sys/vm/swappiness
read -p "$(tput setaf 3)what value do you want assign to swappiness(0~100)(default: 10): $(tput sgr 0)" swappiness
while true; do
  if [ -z $swappiness ]; then
    swappiness=10
  fi
  if [[ "$swappiness" =~ ^[0-9]+$ ]] && [ "$swappiness" -ge 0 -a "$swappiness" -le 100 ]; then
     break;
  fi
  read -p "$(tput setaf 1)please input 0~100, default: 10 : $(tput sgr 0)" swappiness
done
sudo sysctl vm.swappiness=$swappiness
echo "vm.swappiness=$swappiness" | sudo tee -a /etc/sysctl.conf
echo "assigned swappiness to $swappiness"

echo "the current vfs_cache_pressure value is:"
cat /proc/sys/vm/vfs_cache_pressure
read -p "$(tput setaf 3)what value do you want assign to vfs_cache_pressure(0~100)(default: 80): $(tput sgr 0)" cache_pressure
while true; do
  if [ -z $cache_pressure ]; then
    cache_pressure=80
  fi
  if [[ "$cache_pressure" =~ ^[0-9]+$ ]] && [ "$cache_pressure" -ge 0 -a "$cache_pressure" -le 100 ]; then
     break;
  fi
  read -p "$(tput setaf 1)please input 0~100, default: 80 : $(tput sgr 0)" cache_pressure
done
sudo sysctl vm.vfs_cache_pressure=$cache_pressure
echo "vm.vfs_cache_pressure=$cache_pressure" | sudo tee -a /etc/sysctl.conf
echo "assigned vfs_cache_pressure to $cache_pressure"
