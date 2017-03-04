#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# This script used for restore zsh environment

apt-get update
apt-get install zsh
apt-get install git-core

git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

cp .source/.zshrc ~/.zshrc

git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

chsh -s `which zsh`
shutdown -r 0
