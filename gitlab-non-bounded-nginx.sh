#!/bin/bash
#
# This file is licensed under the Apache License, Version 2.0
# Copyright (C) 2017 Jacksgong(blog.dreamtobe.cn)

# This script is used for config non-bundled nginx for gitlab-omnibus on ubuntu 16.04.

# please invoke this script on the su privilege

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
while read line; do echo ${line//server_name YOUR_SERVER_FQDN/server_name $fqdns} ; done < /etc/nginx/sites-available/gitlab.conf > /etc/nginx/sites-available/gitlab.conf.t ; mv /etc/nginx/sites-available/gitlab.conf{.t,}

mkdir /var/log/nginx/
ln -s /etc/nginx/sites-available/gitlab.conf /etc/nginx/sites-enabled/gitlab.conf
nginx -t

# refresh nginx settings.
nginx -s reload

echo "$(tput setaf 2)Congratulate! Everything is ready now.\ngitlab conf on: /etc/gitlab/gitlab.rb, and its nginx conf on: /etc/nginx/sites-available/gitlab.conf$(tput sgr 0)"
echo "$(tput setaf 2)if you finish change the record of $fqdn you can access your gitlab with http://$fqdn (the same to other FQDN you provided)$(tput sgr 0)"
