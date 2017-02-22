#!/bin/bash - 
#===============================================================================
#
#          FILE: ubuntu1604-base.sh
# 
#   DESCRIPTION: This script is to deploy Ubuntu quickly, It can be used in 
#                Ubuntu 16.04.
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Cheng-Chung Chen(leocoolchung@gmail.com), 
#  ORGANIZATION: www.yam.com
#       CREATED: 02/22/2017 10:00
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# Install the base softwares.
apt-get install -y aptitude ntpdate snmpd iptables-persistent sysv-rc-conf lsb-core telnetd nfs-common traceroute

# Turn off 'Ctrl+Alt+Delete' to reboot
# https://help.ubuntu.com/lts/serverguide/console-security.html#disable-ctrl-alt-delete
systemctl mask ctrl-alt-del.target
systemctl daemon-reload

# Setting routine for timing
echo '0 1 * * * /usr/sbin/ntpdate -u ntp1.yam.com > /dev/null 2>&1' >> /etc/cron.d/sys

# Setting iptables-persistent
cp -f rules.v4 /etc/iptables/
service netfilter-persistent reload

# Setting the share library
sed -i '$a /lib' /etc/ld.so.conf
sed -i '$a /lib64' /etc/ld.so.conf
sed -i '$a /usr/local/lib' /etc/ld.so.conf
sed -i '$a /usr/local/lib64' /etc/ld.so.conf

# Setting snmpd
if [ ! -f /etc/snmp/snmpd.conf.default ]; then
    cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.default
fi
echo "rocommunity YamFM" > /etc/snmp/snmpd.conf
service snmpd restart

# Disable snmp normal logging
cp /etc/default/snmpd /root/defaultfile/etc.default.snmpd
sed -i 's/-Lsd -Lf/-LSwd -Lf/g' /etc/default/snmpd
service snmpd restart

# Setting Fail2Ban
apt-get install -y fail2ban
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.conf.default
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.default
service fail2ban restart

# Adding time stamp to history
touch /etc/profile.d/history-timestamp.sh
echo '# Adding time stamp to history'>> /etc/profile.d/history-timestamp.sh
echo 'HISTTIMEFORMAT="<%F %T>:"' >> /etc/profile.d/history-timestamp.sh
echo 'export HISTTIMEFORMAT' >> /etc/profile.d/history-timestamp.sh
source /etc/profile
