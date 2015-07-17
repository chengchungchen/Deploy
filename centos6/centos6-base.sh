#!/bin/bash
# This script is to setting CentOS6, MariaDB  .
# WARNINGS! This only for CentOS6!

# Install the base softwares.
yum install -y wget mlocate ntsysv openssh-clients screen ntpdate net-snmp redhat-lsb vim
#wget http://mirror01.idc.hinet.net/EPEL/6/i386/epel-release-6-8.noarch.rpm
# Install EPEL & SCL
yum install -y epel-release centos-release-SCL
#rpm -Uvh epel-release-6-8.noarch.rpm
yum update -y

# Setting the SELinux
setenforce 0
sed -i 's/=enforcing/=permissive/g' /etc/sysconfig/selinux

# Turn off the firewall
/etc/init.d/iptables stop
chkconfig iptables off

# Turn off 'Ctrl+Alt+Delete' to reboot
sed -i '$s/exec/#exec/g' /etc/init/control-alt-delete.conf

# Setting routine for timing
echo '0 1 * * * /usr/sbin/ntpdate -s ntp1.yam.com > /dev/null 2>&1' >> /etc/cron.d/sys

# Setting tty numbers when booting
sed -i 's/1-6/1-2/g' /etc/init/start-ttys.conf
sed -i 's/1-6/1-2/g' /etc/sysconfig/init

# Turn off IPv6
sed -i '$G' /etc/sysctl.conf
sed -i '$a # Disable IPv6' /etc/sysctl.conf
sed -i '$a net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.conf

/etc/init.d/ip6tables stop
chkconfig ip6tables off

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

# Disable normal logging for snmpd
if [ ! -f /etc/init.d/snmpd-default ]; then
	cp /etc/init.d/snmpd /etc/init.d/snmpd-default
fi
sed -i 's/-LS0-6d/-LS0-5d/g' /etc/init.d/snmpd
/etc/init.d/snmpd restart
chkconfig snmpd on

# Setting Fail2Ban
yum install -y fail2ban
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.conf.default
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.default
sed -i 's/logtarget = SYSLOG/logtarget = \/var\/log\/fail2ban.log/g' /etc/fail2ban/fail2ban.conf
sed -i 's/sender=fail2ban@example.com/sender=fail2ban@yam.com/g' /etc/fail2ban/jail.conf
sed -i 's/dest=you@example.com/dest=chengchungchen@talk2yam.com/g' /etc/fail2ban/jail.conf
/etc/init.d/fail2ban start
chkconfig fail2ban on
