#!/bin/bash

# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# This script is used for application Let's Encrypt certificate on ubuntu 16.04.

echo "----------------------------------------------------------"
echo " Auto generate Let's Encrypt for any FQDN on ubuntu 16.04"
echo " "
echo " URL: https://blog.dreamtobe.cn/maintain-website-server/"
echo "----------------------------------------------------------"

# please invoke this script on the su privilege
[[ $EUID -ne 0 ]] && echo -e "${red}Error:${plain} This script must be run as root!" && exit 1

if ! command -v certbot-auto >/dev/null; then
  echo "$(tput setaf 3)not found certbot-auto, so install it first$(tput sgr 0)"
  cd /usr/local/sbin
  wget https://dl.eff.org/certbot-auto
  chmod a+x /usr/local/sbin/certbot-auto
  # just for cover people using .bash_profile as shell profile
  source ~/.bash_profile
  # just for cover people using .bash_profile as shell profile
  source ~/.zshrc
  cd
fi

read -p "Enter your FQDN for access your website(use spaces to apart eg: blog.dreamtobe.cn blog.jacksgong.com): " fqdns
read -p "Enter your the root path for store your website(eg: /var/www/blog): " path

mkdir -p $path

exists_sites="$(ls /etc/nginx/sites-available/)"

for site in $exists_sites
do
    abs_site='/etc/nginx/sites-available/'$site
    echo "$(tput setaf 3)scan $abs_site file$(tput sgr 0)"
    while read line; do echo ${line//$fqdns/tmp_$fqdns tmp.tmp.com} ; done < $abs_site > $abs_site.t ; mv $abs_site{.t,}
done

  echo "$(tput setaf 3)create a temporary environment$(tput sgr 0)"
# create a temporary environment
cp .source/https/cert-https-tmp.conf /etc/nginx/sites-available/
# replace `YOUR_PATH` to `$path`
while read line; do echo ${line//YOUR_PATH/$path} ; done < /etc/nginx/sites-available/cert-https-tmp.conf > /etc/nginx/sites-available/cert-https-tmp.conf.t ; mv /etc/nginx/sites-available/cert-https-tmp.conf{.t,}
# replace `YOUR_FQDNS` to `$fqdns`
while read line; do echo ${line//YOUR_FQDNS/$fqdns} ; done < /etc/nginx/sites-available/cert-https-tmp.conf > /etc/nginx/sites-available/cert-https-tmp.conf.t ; mv /etc/nginx/sites-available/cert-https-tmp.conf{.t,}
ln -s /etc/nginx/sites-available/cert-https-tmp.conf /etc/nginx/sites-enabled/cert-https-tmp.conf
echo "$(tput setaf 3)valid the temporary environment$(tput sgr 0)"
sudo ls /etc/nginx/sites-available/
nginx -t
nginx -s reload

# application certificate
fqdn_with_d=''
for fqdn in $fqdns
do
  fqdn_with_d=$fqdn_with_d' -d '$fqdn
done
echo "$(tput setaf 3)generate the certificate for $fqdn_with_d on $path $(tput sgr 0)"
echo "certbot-auto certonly -a webroot --webroot-path=$path $fqdn_with_d"
certbot-auto certonly -a webroot --webroot-path=$path $fqdn_with_d

# generate dhparam
dhparam="$(sudo ls /etc/ssl/certs/dhparam.pem)"
if [ -z $dhparam ]; then
  echo "$(tput setaf 3)there isn't dhparam.pem, so generate it first$(tput sgr 0)"
  sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
fi

echo "$(tput setaf 3)clear the temporary environment$(tput sgr 0)"
# clear temporary environment
rm -rf /etc/nginx/sites-available/cert-https-tmp.conf
rm -rf /etc/nginx/sites-enabled/cert-https-tmp.conf
for site in $exists_sites
do
    abs_site='/etc/nginx/sites-available/'$site
    echo "$(tput setaf 3)restore $abs_site file$(tput sgr 0)"
    while read line; do echo ${line//tmp_$fqdns tmp.tmp.com/$fqdns} ; done < $abs_site > $abs_site.t ; mv $abs_site{.t,}
done


# for final environment
need_generate= false
while true; do
    read -p "Do you need we generate temporary conf(/etc/nginx/sites-available/certificated-https-tmp.conf) for your?(y/n) " yn
    case $yn in
        [Yy]* ) need_generate=true; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

fqdn_first=''
for fqdn in $fqdns
do
  fqdn_first=$fqdn; break
done

if [ $need_generate ]; then
  cp .source/https/certificated-https-tmp.conf /etc/nginx/sites-available/
  # replace `YOUR_PATH` to `$path`
  while read line; do echo ${line//YOUR_PATH/$path} ; done < /etc/nginx/sites-available/certificated-https-tmp.conf > /etc/nginx/sites-available/certificated-https-tmp.conf.t ; mv /etc/nginx/sites-available/certificated-https-tmp.conf{.t,}
  # replace `YOUR_FQDNS` to `$fqdns`
  while read line; do echo ${line//YOUR_FQDNS/$fqdns} ; done < /etc/nginx/sites-available/certificated-https-tmp.conf > /etc/nginx/sites-available/certificated-https-tmp.conf.t ; mv /etc/nginx/sites-available/certificated-https-tmp.conf{.t,}
  # replace `YOUR_FIST_FQDN` to `$fqdn_first`
  while read line; do echo ${line//YOUR_FIRST_FQDN/$fqdn_first} ; done < /etc/nginx/sites-available/certificated-https-tmp.conf > /etc/nginx/sites-available/certificated-https-tmp.conf.t ; mv /etc/nginx/sites-available/certificated-https-tmp.conf{.t,}
  sudo ls /etc/nginx/sites-available/certificated-https-tmp.conf
  echo "$(tput setaf 3)Congratulations! every thing is done now, you just need to enable the conf$(tput sgr 0)"
  echo "$(tput setaf 2)We don't make a link to sites-enabled folder yet, if you finish others, just link it by yourself$(tput sgr 0)"
else
  # TODO print tips
  echo "/etc/letsencrypt/live/$fqdn_first"
  ls /etc/letsencrypt/live/$fqdn_first
  echo "$(tput setaf 3)Congratulations! every thing is done now, you just need to config the ssl_certificate to your nginx conf, and add dhparam$(tput sgr 0)"
fi
