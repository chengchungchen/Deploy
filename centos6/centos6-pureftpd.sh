#!/bin/bash - 
#===============================================================================
#
#          FILE: centos6-pureftpd.sh
# 
#         USAGE: ./centos6-pureftpd.sh 
# 
#   DESCRIPTION: Setting Pure-FTP
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: Only for CentOS6
#        AUTHOR: Cheng-Chung Chen (leocoolchung@gmail.com), 
#  ORGANIZATION: yam
#       CREATED: 06/17/2015 17:49
#      REVISION: 0.5
#===============================================================================

set -o nounset                              # Treat unset variables as an error

yum install -y pure-ftpd

