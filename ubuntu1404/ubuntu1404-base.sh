#!/bin/bash - 
#===============================================================================
#
#          FILE: ubuntu1404-base.sh
# 
#   DESCRIPTION: This script is to deploy Ubuntu quickly, It can be used in 
#                Ubuntu 12.04 & Ubuntu 14.04.
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Cheng-Chung Chen(leocoolchung@gmail.com), 
#  ORGANIZATION: www.yam.com
#       CREATED: 05/25/2015 16:04
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# Install the base softwares.
apt-get install -y aptitude screen ntpdate vim snmpd iptables-persistent sysv-rc-conf lsb-core

# Turn off 'Ctrl+Alt+Delete' to reboot
sed -i 's/exec/#exec/g' /etc/init/control-alt-delete.conf

# Setting routine for timing
echo '0 1 * * * /usr/sbin/ntpdate -s ntp1.yam.com > /dev/null 2>&1' >> /etc/cron.d/sys

# Setting iptables-persistent
cp -f rules.v4 /etc/iptables/
/etc/init.d/iptables-persistent stop

# Setting the share library
sed -i '$a /lib' /etc/ld.so.conf
sed -i '$a /lib64' /etc/ld.so.conf
sed -i '$a /usr/local/lib' /etc/ld.so.conf
sed -i '$a /usr/local/lib64' /etc/ld.so.conf

# Setting snmpd
if [ ! -f /etc/snmp/snmpd.conf-default ]; then
	cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf-default
fi
echo "rocommunity YamFM" > /etc/snmp/snmpd.conf
service snmpd start

# Disable snmp normal logging
cp /etc/default/snmpd /root/defaultfile/etc.default.snmpd
sed -i 's/-Lsd -Lf/-LSwd -Lf/g' /etc/default/snmpd
service snmpd restart

# Setting Fail2Ban
apt-get install -y fail2ban
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.conf.default
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.default
service fail2ban start
