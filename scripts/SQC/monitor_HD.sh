#!/bin/sh
space=`df -h |grep /dev/sda3 | awk '{print $5}' | sed -e 's/%//'`
if [ $space -lt 85 ];
then
   wget -O /root/scripts/SQC/HD.html -o /root/scripts/SQC/HD.log "http://sqc.yam.com/sqc/status.jsp?sid=9&status=on&url=blog-d210-HD"
  echo "OK"
else
   wget -O /root/scripts/SQC/HD.html -o /root/scripts/SQC/HD.log "http://sqc.yam.com/sqc/status.jsp?sid=9&status=off&url=blog-d210-HD"
  echo "not ok"
fi

