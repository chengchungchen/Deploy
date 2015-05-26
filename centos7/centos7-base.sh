#!/bin/bash
# This script is to setting CentOS7
# WARNINGS! This only for CentOS7!

# Install the base softwares.
yum install -y wget mlocate ntsysv openssh-clients screen ntpdate net-snmp redhat-lsb vim
#wget http://mirror01.idc.hinet.net/EPEL/6/i386/epel-release-6-8.noarch.rpm
# Install EPEL & SCL
yum install -y epel-release
#rpm -Uvh epel-release-6-8.noarch.rpm
yum update -y

# Setting the SELinux
setenforce 0
sed -i 's/=enforcing/=permissive/g' /etc/sysconfig/selinux

# Turn off the firewall
systemctl stop firewalld
systemctl disable firewalld

# Turn off 'Ctrl+Alt+Delete' to reboot
# https://github.com/OpenSCAP/scap-security-guide/issues/293
systemctl mask ctrl-alt-delete.target

# Setting routine for timing
echo '0 1 * * * /usr/sbin/ntpdate -s ntp1.yam.com > /dev/null 2>&1' >> /etc/cron.d/sys

# Setting tty numbers when booting
#sed -i 's/1-6/1-2/g' /etc/init/start-ttys.conf
#sed -i 's/1-6/1-2/g' /etc/sysconfig/init

# Turn off IPv6
#sed -i '$G' /etc/sysctl.conf
#sed -i '$a # Disable IPv6' /etc/sysctl.conf
#sed -i '$a net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.conf

#/etc/init.d/ip6tables stop
#chkconfig ip6tables off

# Setting the share library
sed -i '$a /lib' /etc/ld.so.conf
sed -i '$a /lib64' /etc/ld.so.conf
sed -i '$a /usr/local/lib' /etc/ld.so.conf
sed -i '$a /usr/local/lib64' /etc/ld.so.conf

# Setting snmpd
if [ ! -f /etc/snmp/snmpd.conf-default ]; then
	cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf-default
fi
echo 'rocommunity YamFM' > /etc/snmp/snmpd.conf
/etc/init.d/snmpd start
chkconfig snmpd on
