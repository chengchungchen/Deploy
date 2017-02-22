#!/bin/bash
# This script is to install MariaDB to Ubuntu12.04 & Ubuntu14.04
# WARNINGS! This only for Ubuntu!
# MySQL5.6 is intalled by MySQL office reposity

# Creating MariaDB repository 
codename=$(lsb_release -a | grep Codename |awk '{print $2}')
apt-get install -y software-properties-common 
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
echo "# http://downloads.mariadb.org/mariadb/repositories/" >> /etc/apt/sources.list.d    /mariadb.list
echo "deb [arch=amd64,i386] http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/10.1/ubuntu $codename main" >> /etc/apt/sources.list.d/mariadb.list
echo "deb-src http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/10.1/ubuntu $codename main" >> /etc/apt/sources.list.d/mariadb.list
apt-get update

# Install MariaDB server
apt-get install -y mariadb-server mariadb-client

# Create DB log directory
#mkdir -p /var/log/mysql
#touch /var/log/mysql/mysql-slow-queries.log
#chown mysql /var/log/mysql/mysql-slow-queries.log

# Setting my.cnf
if [ ! -f /etc/mysql/my.cnf.default ]; then
    cp /etc/mysql/my.cnf /etc/mysql/my.cnf.default
fi

if [ ! -d /etc/mysql/conf.d.default ]; then
    cp -r /etc/mysql/conf.d /etc/mysql/conf.d.default
fi
cp -f my.cnf /etc/mysql/my.cnf
cp -rf conf.d /etc/mysql/
