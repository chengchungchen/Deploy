#!/bin/bash
# This script is to install MariaDB to CentOS6
# WARNINGS! This only for CentOS6_x64!
# MariaDB is intallde by MaraiDB office reposity

# Creating MariaDB repository 
touch /etc/yum.repos.d/MariaDB.repo
echo '[mariadb]' >> /etc/yum.repos.d/MariaDB.repo
echo 'name=MariaDB' >> /etc/yum.repos.d/MariaDB.repo
echo 'baseurl=http://yum.mariadb.org/10.0/centos6-amd64' >> /etc/yum.repos.d/MariaDB.repo
echo 'gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB' >> /etc/yum.repos.d/MariaDB.repo
echo 'gpgcheck=1' >> /etc/yum.repos.d/MariaDB.repo
yum update -y

# Install MariaDB server
#yum install -y MariaDB-server MariaDB-client

# Install MariaDB Galera Cluster
yum install -y MariaDB-Galera-server MariaDB-client galera socat

# Install Percona XtraBACKUP
yum install -y http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm
yum install -y xtrabackup pigz

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
if [ ! -f /etc/my.cnf.default ]; then
        cp /etc/my.cnf /etc/my.cnf.default
fi

if [ ! -d /etc/my.cnf.d.default ]; then
        cp -r /etc/my.cnf.d /etc/my.cnf.d.default
fi
cp -f my.cnf /etc/my.cnf
cp -rf my.cnf.d /etc/

mkdir -p /root/defaultfile
if [ -f /etc/logrotate.d/mysql ]; then
        mv /etc/logrotate.d/mysql /root/defaultfile/etc.logrotate.d.mysql
fi
cp -f etc.logrotate.d.mysql /etc/logrotate.d/mysql
