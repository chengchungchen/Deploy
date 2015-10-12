#!/bin/bash
# This script is to install PHP55 and PHP55more to CentOS6
# WARNINGS! This only for CentOS6!
# PHP55: https://www.softwarecollections.org/en/scls/rhscl/php55/
# PHP55more: https://www.softwarecollections.org/en/scls/remi/php55more/
# Need to change permission: /opt/rh/php55/root/var/lib/php

# Creating repository
wget https://www.softwarecollections.org/en/scls/rhscl/php55/epel-6-x86_64/download/rhscl-php55-epel-6-x86_64.noarch.rpm
wget https://www.softwarecollections.org/en/scls/remi/php55more/epel-6-x86_64/download/remi-php55more-epel-6-x86_64.noarch.rpm
yum install -y scl-utils
yum install -y rhscl-php55-epel-6-x86_64.noarch.rpm remi-php55more-epel-6-x86_64.noarch.rpm
yum install -y php55 php55-php-fpm
scl enable php55 bash

# Install PHP55
yum install -y php55* nginx-filesystem
ln -s /opt/rh/php55/root/usr/bin/pear /usr/bin/pear
ln -s /opt/rh/php55/root/usr/bin/peardev /usr/bin/peardev
ln -s /opt/rh/php55/root/usr/bin/pecl /usr/bin/pecl
ln -s /opt/rh/php55/root/usr/bin/phar /usr/bin/phar
ln -s /opt/rh/php55/root/usr/bin/phar.phar /usr/bin/phar.phar
ln -s /opt/rh/php55/root/usr/bin/php /usr/bin/php
ln -s /opt/rh/php55/root/usr/bin/php-cgi /usr/bin/php-cgi
ln -s /opt/rh/php55/root/usr/bin/php-config /bin/php-config
ln -s /opt/rh/php55/root/usr/bin/phpize /usr/bin/phpize

# Setting the PHP54
#mkdir -p /home/log
#touch /home/log/php-fpm.log

# Setting the php-fpm.conf
if [ ! -f /opt/rh/php55/root/etc/php-fpm.conf.default ]; then
	cp /opt/rh/php55/root/etc/php-fpm.conf /opt/rh/php55/root/etc/php-fpm.conf.default
fi
sed -i 's/opt\/rh\/php55\/root\/var\/log\/php-fpm\/error.log/home\/log\/php-fpm.log/g' /opt/rh/php55/root/etc/php-fpm.conf

# Setting the php.ini
if [ ! -f /opt/rh/php55/root/etc/php.ini.default ]; then
	cp /opt/rh/php55/root/etc/php.ini /opt/rh/php55/root/etc/php.ini.default
fi
sed -i 's/short_open_tag = Off/short_open_tag = On/g' /opt/rh/php55/root/etc/php.ini
sed -i 's/expose_php = On/expose_php = Off/g' /opt/rh/php55/root/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 128M/g' /opt/rh/php55/root/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /opt/rh/php55/root/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /opt/rh/php55/root/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = "Asia\/Taipei"/g' /opt/rh/php55/root/etc/php.ini

# Setting the www.conf
if [ ! -f /opt/rh/php55/root/etc/php-fpm.d/www.conf.default ]; then
	cp /opt/rh/php55/root/etc/php-fpm.d/www.conf /opt/rh/php55/root/etc/php-fpm.d/www.conf.default
fi
sed -i 's/user = apache/user = nginx/g' /opt/rh/php55/root/etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/g' /opt/rh/php55/root/etc/php-fpm.d/www.conf
