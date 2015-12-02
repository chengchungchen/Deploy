#!/bin/sh

rtn=`netstat -an | grep LISTEN | grep 3306 | wc -l`

if [ $rtn -eq 1 ]; then
  wget -O /root/scripts/SQC/db_monitor.html -o /root/scripts/SQC/db_monitor.log "http://sqc.yam.com/sqc/status.jsp?sid=8&status=on&url=blog-slave-db-210"
  echo "port 3306 listen..."
else
  wget -O /root/scripts/SQC/db_monitor.html -o /root/scripts/SQC/db_monitor.log "http://sqc.yam.com/sqc/status.jsp?sid=8&status=off&url=blog-slave-db-210"
  echo "port 3306 not listen..." | mail -s "10.1.198.210-slave DB port:3306 is not listen!! `/bin/date`" changyu_wu@staff.yam.com
fi

