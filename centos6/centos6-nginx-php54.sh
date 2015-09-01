#!/bin/bash
# This script is to install Nginx and PHP5.4 to CentOS6
# WARNINGS! This only for CentOS6!
# The nginx is installed by http://nginx.org/packages,
# and PHP54 is installed by SCL

# Creating Nginx repository
touch /etc/yum.repos.d/nginx.repo
echo '[nginx]' >> /etc/yum.repos.d/nginx.repo
echo 'name=nginx repo' >> /etc/yum.repos.d/nginx.repo
echo 'baseurl=http://nginx.org/packages/centos/6/$basearch/' >> /etc/yum.repos.d/nginx.repo
echo 'gpgcheck=0' >> /etc/yum.repos.d/nginx.repo
echo 'enabled=1' >> /etc/yum.repos.d/nginx.repo
yum update -y

# Install Nginx and PHP54
yum install -y nginx php54* nginx-filesystem
ln -s /opt/rh/php54/root/usr/bin/pear /usr/bin/pear
ln -s /opt/rh/php54/root/usr/bin/peardev /usr/bin/peardev
ln -s /opt/rh/php54/root/usr/bin/pecl /usr/bin/pecl
ln -s /opt/rh/php54/root/usr/bin/phar /usr/bin/phar
ln -s /opt/rh/php54/root/usr/bin/phar.phar /usr/bin/phar.phar
ln -s /opt/rh/php54/root/usr/bin/php /usr/bin/php
ln -s /opt/rh/php54/root/usr/bin/php-cgi /usr/bin/php-cgi
ln -s /opt/rh/php54/root/usr/bin/php-config /bin/php-config
ln -s /opt/rh/php54/root/usr/bin/phpize /usr/bin/phpize

# Setting the nginx
mkdir -p /home/www
mkdir -p /home/log/nginx
chown -R nginx:nginx /home/www
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled
mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.defualt
mv /etc/nginx/conf.d/example_ssl.conf /etc/nginx/conf.d/example_ssl.conf.default

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

# Setting the PHP54
#mkdir -p /home/log
#touch /home/log/php-fpm.log

# Setting the php-fpm.conf
if [ ! -f /opt/rh/php54/root/etc/php-fpm.conf.default ]; then
	cp /opt/rh/php54/root/etc/php-fpm.conf /opt/rh/php54/root/etc/php-fpm.conf.default
fi
sed -i 's/opt\/rh\/php54\/root\/var\/log\/php-fpm\/error.log/home\/log\/php-fpm.log/g' /opt/rh/php54/root/etc/php-fpm.conf

# Setting the php.ini
if [ ! -f /opt/rh/php54/root/etc/php.ini.default ]; then
	cp /opt/rh/php54/root/etc/php.ini /opt/rh/php54/root/etc/php.ini.default
fi
sed -i 's/short_open_tag = Off/short_open_tag = On/g' /opt/rh/php54/root/etc/php.ini
sed -i 's/expose_php = On/expose_php = Off/g' /opt/rh/php54/root/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 128M/g' /opt/rh/php54/root/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /opt/rh/php54/root/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /opt/rh/php54/root/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = "Asia/Taipei"/g' /opt/rh/php54/root/etc/php.ini

# Setting the www.conf
if [ ! -f /opt/rh/php54/root/etc/php-fpm.d/www.conf.default ]; then
	cp /opt/rh/php54/root/etc/php-fpm.d/www.conf /opt/rh/php54/root/etc/php-fpm.d/www.conf.default
fi
sed -i 's/user = apache/user = nginx/g' /opt/rh/php54/root/etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/g' /opt/rh/php54/root/etc/php-fpm.d/www.conf
