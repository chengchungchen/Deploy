#!/bin/bash

####    Jack Qoo Zoo 2011.0126
####    What I do ?
####    1.      Let MySQL Daemon log "Slow-Query-Log"
####    2.      Rotate the "Slow-Query-Log" every hour
####    3.      Compress the "Slow-Query-Log" after rotate done

####    Your Setting
####    You should change them for your system environment

DBusername='root'
DBpassword='dbpasswd'
#MySQL_Client_Full_Path_Name='/opt/mysql/bin/mysql'
MySQL_Client_Full_Path_Name='/usr/bin/mysql'
#Slow_Query_Log_Path='/var/lib/mysql_slow_query_log'
Slow_Query_Log_Path='/var/lib/mysql_slow_query_log'

####    Default Setting
####    You may not change them

Slow_Query_Log_File_Name=`hostname -s`'-slow.log'
MySQL_Client=$MySQL_Client_Full_Path_Name
Long_Query_Time='10'
MySQL_Daemon_UserName='mysql'
MySQL_Daemon_GroupName='mysql'

####    Do SomeDefine

str_Slow_Query_Log_File=$Slow_Query_Log_Path'/'$Slow_Query_Log_File_Name'.'`date +%Y.%m%d.%H00`

####    Do SomeThing
####	Step 1

/bin/mkdir -p $Slow_Query_Log_Path
/bin/chown $MySQL_Daemon_UserName.$MySQL_Daemon_GroupName $Slow_Query_Log_Path

####    Step 2

str_set_SQL_slow_query_log_file='set global slow_query_log_file=''"'$str_Slow_Query_Log_File'"'
$MySQL_Client -u $DBusername --password=$DBpassword -e "$str_set_SQL_slow_query_log_file"

str_set_SQL_long_query_time=$Long_Query_Time
$MySQL_Client -u $DBusername --password=$DBpassword -e "set global long_query_time=$str_set_SQL_long_query_time"

$MySQL_Client -u $DBusername --password=$DBpassword -e "set global log_slow_queries=ON"

####    Step 3

/bin/gzip $Slow_Query_Log_Path'/'$Slow_Query_Log_File_Name.`date +%Y.%m%d.%H00 --d='1 hour ago'`
/usr/bin/find $Slow_Query_Log_Path -mtime +6 -name "*.gz" -print | /usr/bin/xargs /bin/rm -f

###	End
