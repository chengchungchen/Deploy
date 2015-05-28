#!/bin/bash
# This script is to install MariaDB to Ubuntu12.04 & Ubuntu14.04
# WARNINGS! This only for Ubuntu!
# MySQL5.6 is intalled by MySQL office reposity

# Creating MariaDB repository 
codename=$(lsb_release -a | grep Codename |awk '{print $2}')
apt-get install -y software-properties-common 
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db 
#add-apt-repository "deb http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu $codename main"
touch /etc/apt/sources.list.d/mariadb.list
echo "## Offical repository to MariaDB 10" >> /etc/apt/sources.list.d/mariadb.list
echo "deb http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/10.0/ubuntu $codename main" >> /etc/apt/sources.list.d/mariadb.list
echo "deb-src http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/10.0/ubuntu $codename main" >> /etc/apt/sources.list.d/mariadb.list
apt-get update

# Install MariaDB server
apt-get install -y mariadb-server mariadb-client

# Create DB directory
mkdir -p /home/mysql
chown -R mysql:mysql /home/mysql
chmod 700 /home/mysql
rsync -av -default /var/lib/mysql/* /home/mysql

# Create DB log directory
mkdir -p /home/log/mysql
touch /home/log/mysql/mysql-slow-queries.log
chown mysql /home/log/mysql/mysql-slow-queries.log

# Setting my.cnf
if [ ! -f /etc/mysql/my.cnf.default ]; then
        cp /etc/mysql/my.cnf /etc/mysql/my.cnf.default
fi

if [ ! -d /etc/mysql/conf.d.default ]; then
        cp -r /etc/mysql/conf.d /etc/mysql/conf.d.default
fi
cp -f my.cnf /etc/mysql/my.cnf
cp -rf conf.d /etc/mysql/

mkdir -p /root/defaultfile
if [ -f /etc/logrotate.d/mysql ]; then
        mv /etc/logrotate.d/mysql /root/defaultfile/etc.logrotate.d.mysql
fi
cp -f etc.logrotate.d.mysql /etc/logrotate.d/mysql
