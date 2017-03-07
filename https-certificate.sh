#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# This script is used for application Let's Encrypt certificate on ubuntu 16.04.

# please invoke this script on the su privilege

certbot="$(which certbot-auto)"
if [[ $certbot = *'not found' ]]; then
  echo "$(tput setaf 3)not found certbot-auto, so install it first$(tput sgr 0)"
  cd /usr/local/sbin
  wget https://dl.eff.org/certbot-auto
  chmod a+x /usr/local/sbin/certbot-auto
  cd
fi

read -p "Enter your FQDN for access your website(use spaces to apart eg: blog.dreamtobe.cn blog.jacksgong.com)" fqdns
read -p "Enter your the root path for store your website(eg: /var/www/blog)" path

mkdir $path

# create a temporary environment
cp .source/https/cert-https-tmp.conf /etc/nginx/sites-available/
# replace `YOUR_PATH` to `$path`
while read line; do echo ${line//YOUR_PATH/$path} ; done < /etc/nginx/sites-available/cert-https-tmp.conf > /etc/nginx/sites-available/cert-https-tmp.conf.t ; mv /etc/nginx/sites-available/cert-https-tmp.conf{.t,}
# replace `YOUR_FQDNS` to `$fqdns`
while read line; do echo ${line//YOUR_FQDNS/$fqdns} ; done < /etc/nginx/sites-available/cert-https-tmp.conf > /etc/nginx/sites-available/cert-https-tmp.conf.t ; mv /etc/nginx/sites-available/cert-https-tmp.conf{.t,}
ln -s /etc/nginx/sites-available/cert-https-tmp.conf /etc/nginx/sites-enabled/cert-https-tmp.conf
nginx -s reload

# application certificate
fqdn_with_d=''
for fqdn in $fqdns
do
  fqdn_with_d=$fqdn_with_d' -d '$fqdn
done
certbot-auto certonly -a webroot --webroot-path=$path -d $fqdn_with_d

# generate dhparam
dhparam="$(sudo ls /etc/ssl/certs/dhparam.pem)"
if [ -z "$installed_path" ]; then
  echo "$(tput setaf 3)not found dhparam.pem, so generate it first$(tput sgr 0)"
  sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
fi

# clear temporary environment
rm -rf /etc/nginx/sites-available/cert-https-tmp.conf
rm -rf /etc/nginx/sites-enabled/cert-https-tmp.conf

# for final environment
need_generate= false
while true; do
    read -p "Do you need we generate temporary conf(/etc/nginx/sites-available/certificated-https-tmp.conf) for your?(y/n)" yn
    case $yn in
        [Yy]* ) need_generate= true; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

fqdn_first=''
for fqdn in $fqdns
do
  fqdn_first=$fqdn; break;;
done

if [ $need_generate ]; then
  cp .source/https/certificated-https-tmp.conf /etc/nginx/sites-available/
  # replace `YOUR_PATH` to `$path`
  while read line; do echo ${line//YOUR_PATH/$path} ; done < /etc/nginx/sites-available/certificated-https-tmp.conf > /etc/nginx/sites-available/certificated-https-tmp.conf.t ; mv /etc/nginx/sites-available/certificated-https-tmp.conf{.t,}
  # replace `YOUR_FQDNS` to `$fqdns`
  while read line; do echo ${line//YOUR_FQDNS/$fqdns} ; done < /etc/nginx/sites-available/certificated-https-tmp.conf > /etc/nginx/sites-available/certificated-https-tmp.conf.t ; mv /etc/nginx/sites-available/certificated-https-tmp.conf{.t,}
  # replace `YOUR_FIST_FQDN` to `$fqdn_first`
  while read line; do echo ${line//YOUR_FIST_FQDN/$fqdn_first} ; done < /etc/nginx/sites-available/certificated-https-tmp.conf > /etc/nginx/sites-available/certificated-https-tmp.conf.t ; mv /etc/nginx/sites-available/certificated-https-tmp.conf{.t,}
  ls /etc/nginx/sites-available/certificated-https-tmp.conf
  echo "$(tput setaf 3)every thing is done now, you just need to enable the conf$(tput sgr 0)"
else
  # TODO print tips
  ls /etc/letsencrypt/live/$fqdn_first
  echo "$(tput setaf 3)every thing is done now, you just need to config the ssl_certificate to your nginx conf, and add dhparam$(tput sgr 0)"
fi
