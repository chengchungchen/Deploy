#!/bin/bash - 
#===============================================================================
#
#          FILE: ubuntu1404-pureftpd.sh
# 
#         USAGE: ./ubuntu1404-pureftpd.sh 
# 
#   DESCRIPTION: Setting Pure-ftpd
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: Only for Ubuntu12.04 & Ubuntu14.04
#        AUTHOR: Cheng-Chung Chen (leocoolchung@gmail.com), 
#  ORGANIZATION: yam
#       CREATED: 06/17/2015 11:51
#      REVISION: 0.5
#===============================================================================

set -o nounset                              # Treat unset variables as an error

apt-get install -y pure-ftpd
ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/PureDB
echo "5000 5010" > /etc/pure-ftpd/conf/PassivePortRange
