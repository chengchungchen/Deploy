#!/bin/bash
# This script is to install Nginx and PHP to Ubuntu12.04 & Ubuntu14.04
# WARNINGS! This only for Ubuntu!
# The nginx is installed by http://nginx.org/packages,

# Creating Nginx repository
wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
touch /etc/apt/sources.list.d/nginx.list
echo "## Offical repository to Nginx stable version" >> /etc/apt/sources.list.d/nginx.list
codename=$(lsb_release -a | grep Codename |awk '{print $2}')
echo "deb http://nginx.org/packages/ubuntu/ $codename nginx" >> /etc/apt/sources.list.d/nginx.list
echo "deb-src http://nginx.org/packages/ubuntu/ $codename nginx" >> /etc/apt/sources.list.d/nginx.list
# For Ubuntu 12.04
#sed -i '$a deb http://nginx.org/packages/ubuntu/ precise nginx' /etc/apt/sources.list
#sed -i '$a deb-src http://nginx.org/packages/ubuntu/ precise nginx' /etc/apt/sources.list
# For Ubuntu 14.04
#sed -i '$a deb http://nginx.org/packages/ubuntu/ trusty nginx' /etc/apt/sources.list
#sed -i '$a deb-src http://nginx.org/packages/ubuntu/ trusty nginx' /etc/apt/sources.list
apt-get update

# Install Nginx and PHP5
apt-get install -y nginx php5 php5-cli php5-common php5-curl php5-dev php5-fpm php5-gd php5-mcrypt php5-memcache php5-mysqlnd php5-xmlrpc php5-sqlite php-pear

# Setting the nginx
mkdir -p /home/www
mkdir -p /home/log/nginx
chown -R nginx:nginx /home/www
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled
if [ ! -f /etc/nginx/conf.d/default.conf ]; then
	mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.defualt
fi
if [ ! -f /etc/nginx/conf.d/example_ssl.conf ]; then
	mv /etc/nginx/conf.d/example_ssl.conf /etc/nginx/conf.d/example_ssl.conf.default
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

# Setting the PHP5
mkdir -p /home/log
touch /home/log/php-fpm.log

# Setting the php-fpm.conf
if [ ! -f /etc/php5/fpm/php-fpm.conf.default ]; then
	cp /etc/php5/fpm/php-fpm.conf /etc/php5/fpm/php-fpm.conf.default
fi
sed -i 's/var\/log\/php5-fpm.log/home\/log\/php-fpm.log/g' /etc/php5/fpm/php-fpm.conf

# Setting the php.ini
if [ ! -f /etc/php5/fpm/php.ini.default ]; then
	cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.default
fi
sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php5/fpm/php.ini
sed -i 's/expose_php = On/expose_php = Off/g' /etc/php5/fpm/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 128M/g' /etc/php5/fpm/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /etc/php5/fpm/php.ini
sed -i 's/;date.timezone =/date.timezone = "Asia/Taipei"/g' /etc/php5/fpm/php.ini

# Setting the www.conf
if [ ! -f /etc/php5/fpm/pool.d/www.conf.default ]; then
	cp /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.default
fi
sed -i 's/www-data/nginx/g' /etc/php5/fpm/pool.d/www.conf

# Setting logrotate
mkdir -p /root/defaultfile
if [ -f /etc/logroate.d/nginx ]; then
	mv /etc/logroate.d/nginx /root/defaultfile/etc.logroate.d.nginx
fi
cp etc.logrotate.d.nginx /etc/logrotate.d/nginx

if [ -f /etc/logroate.d/php5-fpm ]; then
	mv /etc/logroate.d/php5-fpm /root/defaultfile/etc.logroate.d.php5-fpm
fi
cp etc.logrotate.d.php5-fpm /etc/logrotate.d/php5-fpm
