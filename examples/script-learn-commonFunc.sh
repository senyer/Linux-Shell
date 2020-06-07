#!/bin/bash

DefUsername="sc"
DefUserHome="/home/sc"

# 从properties文件读取value
function getProperty {
	[ -f "$rspResult" ] && grep -P "^\s*[^#]?${1}=.*$" $rspResult | sed 's/\\=/_/g'| cut -d'=' -f2 | sed 's/_/=/g'
}

function checkProperty()
{
	count=0
	/usr/huawei/sc_jdk/jdk/jre/bin/java -jar /usr/huawei/switchcenter/Bin/ScLogTool.jar "INFO" "Waiting for $0 rsp properties." > /dev/null 2>&1
	while [ $count -lt 15 ];
	do
		base64Pwd=$(getProperty "Result")
		OperatorDBPass=`echo $base64Pwd | base64 -d`
		if [ -n "$OperatorDBPass" ] ;then
			/usr/huawei/sc_jdk/jdk/jre/bin/java -jar /usr/huawei/switchcenter/Bin/ScLogTool.jar "INFO" "succeed to get $0 rsp properties." > /dev/null 2>&1
			rm -fr $rspResult
			break
		fi
		
		sleep 1s
		((count++))
	done
	
	if [ $count -ge 15 ];then
		/usr/huawei/sc_jdk/jdk/jre/bin/java -jar /usr/huawei/switchcenter/Bin/ScLogTool.jar "ERROR" "PID:$$ get $0 rsp properties failed!" > /dev/null 2>&1
	fi
	
}

## 检测SC服务是否启动
function checkSC()
{
	checkTime=0
	echo "Waiting for the sc service to start"
	while [ $checkTime -lt 900 ];
	do
		checkAccess=`ps -efww|grep SwitchCenterAccessManager.jar|grep -v grep|wc -l`
		checkBusiness=`ps -efww|grep SwitchCenterBusiness.jar|grep -v grep|wc -l`
		checkFailover=`ps -efww|grep SwitchCenterFailover.jar|grep -v grep|wc -l`
		checkProxy=`ps -efww |grep scproxy|grep -v grep|wc -l`
		checkBackup=`ps -efww |grep scbackupexe|grep -v grep|wc -l`
		checkMedia=`ps -efww |grep scmediaexe|grep -v grep|wc -l`

		if [ $checkAccess -gt 0 ] || [ $checkBusiness -gt 0 ] || [ $checkFailover -gt 0 ] || [ $checkProxy -gt 0 ] || [ $checkBackup -gt 0 ] || [ $checkMedia -gt 0 ];then
			sleep 5s
			echo "SC has started"
			return 0
		fi
		
		sleep 10s
		((checkTime+=10))
	done
	echo "SC service is not started"
	return 1
}

##检测高斯数据库是否正常启动
function checkGaussStatus()
{
	DBStatusFile=$1
	sudo su - ${DefUsername} <<EOF
		ps -efww | grep zengine | grep sc > ${DBStatusFile}
		chmod 740 ${DefUserHome}/${DBStatusFile}
EOF
	gaussStatus=`cat ${DefUserHome}/${DBStatusFile} | grep -v grep | grep sc | wc -l`
	if [ $gaussStatus -eq 1 ];then
		return 0
	else
		return 1
	fi
}

##检测高斯数据库是否正常监听
function checkGaussListen()
{
	listenRet=`netstat -ano| grep :6001 | grep LISTEN | wc -l`
	if [ $listenRet -eq 1 ];then
		echo "Gauss database is normal"
		return 0
	else
		echo "Gauss database is anormal"
		return 1
	fi
}


#===  FUNCTION  ================================================================
#          NAME:  start_GaussDB
#   DESCRIPTION:  start GaussDB service
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function start_GaussDB()
{
	if [ ! -f /usr/huawei/switchcenter/Bin/docker.sig ]; then
		source /etc/profile
	fi
	echo "start_GaussDB"
	usr=`whoami`
	if [ ${usr} == "root" ]; then
		su - sc -c "zctl.py -t start"
	else
		sudo su - sc <<EOF
			zctl.py -t start
EOF
	fi
	sleep 60s
}

#===  FUNCTION  ================================================================
#          NAME:  stop_GaussDB
#   DESCRIPTION:  stop GaussDB service
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function stop_GaussDB()
{
	if [ ! -f /usr/huawei/switchcenter/Bin/docker.sig ]; then
		source /etc/profile
	fi
	echo "stop_GaussDB"
	usr=`whoami`
	if [ ${usr} == "root" ]; then
			su - sc -c "zctl.py -t stop" 
	else
		sudo su - sc <<EOF
			zctl.py -t stop
EOF
	fi

	sleep 10s
}
