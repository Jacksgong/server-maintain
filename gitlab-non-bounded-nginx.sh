#!/bin/bash
#
# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# This script is used for config non-bundled nginx for gitlab-omnibus on ubuntu 16.04.

# for convenient, switch to root
su root

# replace `# web_server['external_users'] = ['www-data']` to `web_server['external_users'] = ['www-data']`
while read line; do echo ${line//\# web_server\[\'external_users\'\] = \[\'www-data\'\]/web_server\[\'external_users\'\] = \[\'www-data\'\]} ; done < /etc/gitlab/gitlab.rb > /etc/gitlab/gitlab.rb.t ; mv /etc/gitlab/gitlab.rb{.t,}
# replace `# web_server['external_users'] = []` to `web_server['external_users'] = ['www-data']`
while read line; do echo ${line//\# web_server\[\'external_users\'\] = \[\]/web_server\[\'external_users\'\] = \[\'www-data\'\]} ; done < /etc/gitlab/gitlab.rb > /etc/gitlab/gitlab.rb.t ; mv /etc/gitlab/gitlab.rb{.t,}
# replace `# nginx['enable'] = true` to `nginx['enable'] = false`
while read line; do echo ${line//\# nginx\[\'enable\'] = true/nginx\[\'enable\'] = false} ; done < /etc/gitlab/gitlab.rb > /etc/gitlab/gitlab.rb.t ; mv /etc/gitlab/gitlab.rb{.t,}
# replace `# nginx['enable'] = false` to `nginx['enable'] = false`
while read line; do echo ${line//\# nginx\[\'enable\'] = false/nginx\[\'enable\'] = false} ; done < /etc/gitlab/gitlab.rb > /etc/gitlab/gitlab.rb.t ; mv /etc/gitlab/gitlab.rb{.t,}

# get the gitlab website FQDN
read -p "Enter your FQDN for access gitlab website(like: git.jacksgong.com): " fqdn

# config external_url to gitlab-conf: `external_url 'http://$fqdn'`
while read line; do
   if [[ $line = 'external_url'* ]]; then
      echo "external_url 'http://$fqdn'"
   else
      echo $line; fi
done < /etc/gitlab/gitlab.rb > /etc/gitlab/gitlab.rb.t ; mv /etc/gitlab/gitlab.rb{.t,}

# refresh settings for gitlab
gitlab-ctl reconfigure

# get FQDNs for nginx conf
while true; do
    read -p "In addition to $fqdn, is there any other FQDN that can access the gitlab site?(y/n)" yn
    case $yn in
        [Yy]* ) read -p "Enter your another FQDN for access gitlab(use spaces to apart eg: git.dreamtobe.cn g.jacksgong.com)" fqdns; break;;
        [Nn]* ) fqdns='';break;;
        * ) echo "Please answer yes or no.";;
    esac
done
fqdns=$fqdn' '$fqdns

# fetch the official recommended nginx conf
wget https://gitlab.com/gitlab-org/gitlab-recipes/raw/master/web-server/nginx/gitlab-omnibus-nginx.conf
mv gitlab-omnibus-nginx.conf /etc/nginx/sites-available/gitlab.conf
# replace `server_name YOUR_SERVER_FQDN` to `server_name $fqdn`
while read line; do echo ${line//server_name YOUR_SERVER_FQDN/server_name $fqdns} ; done < /etc/nginx/sites-available/gitlab.conf > /etc/nginx/sites-available/gitlab.conf.t ; mv /etc/nginx/sites-available/nginx.conf{.t,}

# refresh nginx settings.
nginx -s reload
