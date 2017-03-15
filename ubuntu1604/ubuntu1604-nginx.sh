#!/bin/bash
# This script is to install Nginx and PHP to Ubuntu12.04 & Ubuntu14.04
# WARNINGS! This only for Ubuntu!
# The nginx is installed by http://nginx.org/packages,

WEBPATH="/home/www"

# Creating Nginx repository & update
#wget http://nginx.org/keys/nginx_signing.key
#apt-key add nginx_signing.key
touch /etc/apt/sources.list.d/nginx.list
echo "## Offical repository to Nginx stable version" >> /etc/apt/sources.list.d/nginx.list
codename=$(lsb_release -a | grep Codename |awk '{print $2}')
echo "deb http://nginx.org/packages/ubuntu/ $codename nginx" >> /etc/apt/sources.list.d/nginx.list
echo "deb-src http://nginx.org/packages/ubuntu/ $codename nginx" >> /etc/apt/sources.list.d/nginx.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62
apt-get update

# Install Nginx
apt-get install -y nginx

# Setting the nginx
mkdir -p ${WEBPATH}
chown -R www-data:www-data ${WEBPATH}
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled
if [ ! -f /etc/nginx/conf.d/default.conf ]; then
    mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.defualt
fi

if [ ! -f /etc/nginx/fastcgi_params.default ]; then
    cp /etc/nginx/fastcgi_params /etc/nginx/fastcgi_params.default
fi
sed -i '$G' /etc/nginx/fastcgi_params
sed -i '$a # yam setting' /etc/nginx/fastcgi_params
sed -i '$a #fastcgi_param   SERVER_ENV              "develop";' /etc/nginx/fastcgi_params
sed -i '$a #fastcgi_param   SERVER_ENV              "production";' /etc/nginx/fastcgi_params

if [ ! -f /etc/nginx/nginx.conf.default ]; then
    cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default
fi
cp -f ./nginx.conf /etc/nginx/nginx.conf

# Setting logrotate
if [ ! -d /root/defaultfile ]; then
    mkdir -p /root/defaultfile
fi

if [ -f /etc/logroate.d/nginx ]; then
    mv /etc/logroate.d/nginx /root/defaultfile/etc.logroate.d.nginx
fi
cp etc.logrotate.d.nginx /etc/logrotate.d/nginx
