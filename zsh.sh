#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# This script used for restore zsh environment

echo "--------------------------------------------------------"
echo " Auto install&configure zsh with oh-my-zsh on ubuntu 16.04"
echo " "
echo " URL: https://blog.dreamtobe.cn/maintain-website-server/"
echo "--------------------------------------------------------"

sudo apt-get update
sudo apt-get install zsh
sudo apt-get install git-core

echo "$(tput setaf 3)install oh-my-zsh$(tput sgr 0)"
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

echo "$(tput setaf 3)restore zshrc file$(tput sgr 0)"
cp .source/.zshrc ~/.zshrc

echo "$(tput setaf 3)install autosuggestions plugin$(tput sgr 0)"
git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
echo "$(tput setaf 3)install powerlevel9k theme$(tput sgr 0)"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

echo "$(tput setaf 3)install autojump plugin$(tput sgr 0)"
git clone https://github.com/joelthelion/autojump.git
cd autojump
sudo python ./install.py
cd ..
rm -rf autojump

chsh -s `which zsh`

iam=$(whoami)
sudo usermod -s /bin/zsh $iam

echo "$(tput setaf 3)Congratulate! it has been configured successfully, now we reboot the system to valid it.$(tput sgr 0)"
shutdown -r 0
