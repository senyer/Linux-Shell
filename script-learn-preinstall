#!/bin/sh
#preinstall_start.sh
# vim: set tabstop=4 shiftwidth=4 fileformat=unix: 
#=======================================================================
#
#          FILE:  preinstall_start.sh
# 
#         USAGE:  ./preinstall_start.sh 
# 
#   DESCRIPTION:  预安装 SwitchCenter 定制版本
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: 
#       COMPANY: Huawei Tech. Co., Ltd.
#       CREATED: 
#      REVISION:  ---
#=======================================================================


#localpath=${PWD}
cmdPath=${PWD}
localpath=`dirname $0`
absolutePath=$(cd `dirname $0`; pwd)
jdkPath="/usr/huawei/sc_jdk/jdk/jre"
DefUserGroup="sc"
DefUsername="sc"
AppUsername="scapp"
DefUserHome="/home/sc"
AppUserHome="/home/scapp"
SysPasswdF="/etc/passwd"
InstallType="reinstall"
StartFlag="stop"
SysCheck="auto"
logfile="/usr/huawei/switchcenter/install.log"
keytoolPath="$jdkPath/bin/keytool"
keystorePath="$jdkPath/lib/security/cacerts"
CAPtah="/usr/huawei/switchcenter/config/SSLCertification/CA_Root"
httpsKeystorePath="/usr/huawei/switchcenter/config/SSLCertification/sckeystore"
OperatorDBPass=""
rspResult="/usr/huawei/switchcenter/security/rsp/preinstall_start.properties"
DefGaussDBUsername="sc"
source $absolutePath/switchcenter/Bin/commonFunction.sh

ParamNum=$#
if [ 1 -eq $ParamNum ]; then
	if [ $1 = "update" ]; then
		InstallType=$1
		StartFlag="start"
	elif [ $1 = "reinstall" ]; then
		InstallType=$1
		StartFlag="start"
	fi
elif [ 2 -eq $ParamNum ]; then
	InstallType=$1
	StartFlag=$2
elif [ 3 -eq $ParamNum ]; then
	InstallType=$1
	StartFlag=$2
	SysCheck=$3
fi
backupDBPass="N"


#判断操作系统
OsType="Euler"
touch $localpath/switchcenter/Bin/Euler.sig
EulerV2R8=`cat /etc/EulerLinux.conf | grep "EulerOS_Server_V200R008" |wc -l`
EulerV2R7=`cat /etc/EulerLinux.conf | grep "EulerOS_V200R007" |wc -l`
if [ 1 -eq $EulerV2R8 ]; then
	touch $localpath/switchcenter/Bin/Euler_V2R8.sig
elif [ 1 -eq $EulerV2R7 ];then
	touch $localpath/switchcenter/Bin/Euler_V2R7.sig
fi

#===  FUNCTION  ================================================================
#          NAME:  stopGaussDB
#   DESCRIPTION:  Stop GaussDB database
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function stopGaussDB()
{ 
	su - ${DefUsername} -c "zctl.py -t stop"
	sleep 30s
	return 0
} 

#===  FUNCTION  ================================================================
#          NAME:  startGaussDB
#   DESCRIPTION:  Start GaussDB database
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function startGaussDB()
{
	echo "start GaussDB"
	su - ${DefUsername} -c "zctl.py -t start"
	sleep 30s
	SLEEP=90
	while [ $SLEEP -ge 0 ]; do
	
		checkGaussStatus "gaussdbStatus.out"
		ret1=$?
		if [ $ret1 -eq 0 ]; then
			sleep 60s
			return 0
		fi
	
		sleep 1	
		SLEEP=`expr $SLEEP - 1 `
	done
	return 1
} 

#===  FUNCTION  ================================================================
#          NAME:  stop_SC
#   DESCRIPTION:  stop SwitchCenter service,run with os user sc
#    PARAMETERS: 
#       RETURNS:
#===============================================================================
function stop_SC()
{
	### Stop Monitor ###
	echo "stop_SC"
	PIDS=`ps -efww |grep startMonitor.sh |grep -v grep | awk '{print $2}'`
	if [ "$PIDS" != "" ]; then
	  ps -efww|grep startMonitor.sh|grep -v grep|awk '{print $2}'|xargs kill -9
	  echo "monitor is now stopped"
	fi
	
	### Stop AccessManager ###
	PIDS=`ps -efww |grep SwitchCenterAccessManager.jar |grep -v grep | awk '{print $2}'`
	if [ "$PIDS" != "" ]; then
	  ps -efww|grep SwitchCenterAccessManager.jar|grep -v grep|awk '{print $2}'|xargs kill -9
	fi

	### Stop Business ###
	PIDS=`ps -efww |grep SwitchCenterBusiness.jar |grep -v grep | awk '{print $2}'`
	if [ "$PIDS" != "" ]; then
	  ps -efww|grep SwitchCenterBusiness.jar|grep -v grep|awk '{print $2}'|xargs kill -9
	fi
	
	### Stop Failover ###
	PIDS=`ps -efww |grep SwitchCenterFailover.jar |grep -v grep | awk '{print $2}'`
	if [ "$PIDS" != "" ]; then
	  ps -efww|grep SwitchCenterFailover.jar|grep -v grep|awk '{print $2}'|xargs kill -9
	fi

	### Stop Reverseproxy ###
	PIDS=`ps -efww |grep SwitchCenterReverseproxy.jar |grep -v grep | awk '{print $2}'`
	if [ "$PIDS" != "" ]; then
	  ps -efww|grep SwitchCenterReverseproxy.jar|grep -v grep|awk '{print $2}'|xargs kill -9
	fi

	### Stop Proxy ###
	PIDS=`ps -efww |grep scproxy |grep -v grep | awk '{print $2}'`
	if [ "$PIDS" != "" ]; then
	  ps -efww|grep scproxy|grep -v grep|awk '{print $2}'|xargs kill -9
	fi

	### Stop Backup ###
	PIDS=`ps -efww |grep scbackupexe |grep -v grep | awk '{print $2}'`
	if [ "$PIDS" != "" ]; then
	  ps -efww|grep scbackupexe|grep -v grep|awk '{print $2}'|xargs kill -9
	fi

	### Stop media ###
	PIDS=`ps -efww |grep scmediaexe |grep -v grep | awk '{print $2}'`
	if [ "$PIDS" != "" ]; then
	  ps -efww|grep scmediaexe|grep -v grep|awk '{print $2}'|xargs kill -9
	fi

	### Stop Iframe ###
	PIDS=`ps -efww |grep msg |grep -v grep | awk '{print $2}'`
	if [ "$PIDS" != "" ]; then
	  ps -efww|grep msg|grep -v grep|awk '{print $2}'|xargs kill -9
	fi
	
	### Stop gaussdb ###
	stopGaussDB
	
	### Stop Cipher ###
	PIDS=`ps -efww |grep SwitchCenterCipher.jar |grep -v grep | awk '{print $2}'`
	if [ "$PIDS" != "" ]; then
	  ps -efww|grep SwitchCenterCipher.jar|grep -v grep|awk '{print $2}'|xargs kill -9
	fi
	
	nginxNum=`ps -efww|grep nginx |grep -v grep |wc -l`
	if [ ${nginxNum} -gt 0 ];then
		/usr/huawei/switchcenter/nginx/sbin/nginx -s stop
	fi
	
	return 0
}

#===  FUNCTION  ================================================================
#          NAME:  update_Bin
#   DESCRIPTION:  update Bin folder
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function update_Bin()
{
	echo "update_Bin"
	if [ -x "/usr/huawei/switchcenter/Bin/key" ]; then
		cp -rfap /usr/huawei/switchcenter/Bin/key /home/
	fi
	
	if [ -f "/usr/huawei/switchcenter/Bin/keystore1.dat" ]; then
		cp -rfap /usr/huawei/switchcenter/Bin/keystore1.dat /home/
		cp -rfap /usr/huawei/switchcenter/Bin/keystore2.dat /home/
	fi
	
	if [ -f "/usr/huawei/switchcenter/Bin/key.ser" ];then
		cp -rfap /usr/huawei/switchcenter/Bin/key.ser /home/
	elif [ -f "/usr/huawei/switchcenter/Bin/key.pem" ];then
		cp -rfap /usr/huawei/switchcenter/Bin/key.pem /home/
	fi
	
	if [ -f "/usr/huawei/switchcenter/Bin/docker.sig" ]; then
		cp -rfap /usr/huawei/switchcenter/Bin/docker.sig /home/
	fi
	
	if [ -f "/usr/huawei/switchcenter/Bin/netconfig.properties" ]; then
		cp -rfap /usr/huawei/switchcenter/Bin/netconfig.properties /home/
	fi
	
	if [ -x "/usr/huawei/switchcenter/Bin" ]; then
		rm -rf /usr/huawei/switchcenter/Bin
	fi
	
	if [ -x "/usr/huawei/switchcenter/Bin" ]; then
		echo "Update /usr/huawei/switchcenter/Bin failed" >> $localpath/preinstall_save.txt
		echo "fail" >> $localpath/preinstall_result.txt
	exit 1
	fi

	chmod -R 755 $localpath/switchcenter/Bin
	rm -rf /usr/huawei/switchcenter/Bin/AccessManager
	cp -rfap $localpath/switchcenter/Bin /usr/huawei/switchcenter/
	if [ -x "/home/key" ]; then
		cp -rfap /home/key /usr/huawei/switchcenter/Bin
		rm -rf /home/key
	fi
	if [ -f "/home/keystore1.dat" ]; then
		cp -rfap /home/keystore1.dat /usr/huawei/switchcenter/Bin
		rm -rf /home/keystore1.dat
	fi
	if [ -f "/home/keystore2.dat" ];then
		cp -rfap /home/keystore2.dat /usr/huawei/switchcenter/Bin
		rm -rf /home/keystore2.dat
	fi
	
	if [ -f "/home/key.ser" ];then
		cp -rfap /home/key.ser /usr/huawei/switchcenter/Bin
		rm -rf /home/key.ser
	fi
	if [ -f "/home/key.pem" ];then
		cp -rfap /home/key.pem /usr/huawei/switchcenter/Bin
		rm -rf /home/key.pem
	fi
	
	if [ -f "/home/docker.sig" ];then
		cp -rfap /home/docker.sig /usr/huawei/switchcenter/Bin
		rm -rf /home/docker.sig
	fi
	
	if [ -f "/home/netconfig.properties" ];then
		cp -rfap /home/netconfig.properties /usr/huawei/switchcenter/Bin
		rm -rf /home/netconfig.properties
	fi
	
	# 19.1root整改新增
	echo `date`":start move_RootShellToDir for update." >>$logfile
	move_RootShellToDir
	echo `date`":end move_RootShellToDir for update." >>$logfile
}

#===  FUNCTION  ================================================================
#          NAME:  update_Install
#   DESCRIPTION:  update Install folder
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function update_Install()
{
	echo "update_Install"
	if [ -x "/usr/huawei/switchcenter/Install" ]; then
	rm -rf /usr/huawei/switchcenter/Install
	fi

	if [ -x "/usr/huawei/switchcenter/Install" ]; then
	echo "Update /usr/huawei/switchcenter/Install failed" >> $localpath/preinstall_save.txt
	echo "fail" >> $localpath/preinstall_result.txt
	exit 1
	fi

	chmod -R 755 $localpath/switchcenter/Install
	cp -rfap $localpath/switchcenter/Install /usr/huawei/switchcenter/
}

#===  FUNCTION  ================================================================
#          NAME:  update_Uninstall
#   DESCRIPTION:  update Uninstall folder
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function update_Uninstall()
{	
	echo "update_Uninstall"
	if [ -x "/usr/huawei/switchcenter/Uninstall" ]; then
	rm -rf /usr/huawei/switchcenter/Uninstall
	fi

	if [ -x "/usr/huawei/switchcenter/Uninstall" ]; then
	echo "Update /usr/huawei/switchcenter/Uninstall failed" >> $localpath/preinstall_save.txt
	echo "fail" >> $localpath/preinstall_result.txt
	exit 1
	fi

	chmod -R 755 $localpath/switchcenter/Uninstall
	cp -rfap $localpath/switchcenter/Uninstall /usr/huawei/switchcenter/
}

#===  FUNCTION  ================================================================
#          NAME:  update_Tools
#   DESCRIPTION:  update Tools folder
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function update_Tools()
{
	echo "update_Tools"
	if [ -x "/usr/huawei/switchcenter/Tools" ]; then
	rm -rf /usr/huawei/switchcenter/Tools
	fi

	if [ -x "/usr/huawei/switchcenter/Tools" ]; then
	echo "Update /usr/huawei/switchcenter/Tools failed" >> $localpath/preinstall_save.txt
	echo "fail" >> $localpath/preinstall_result.txt
	exit 1
	fi

	chmod -R 755 $localpath/switchcenter/Tools
	cp -rfap $localpath/switchcenter/Tools /usr/huawei/switchcenter/
}

## 更新nginx相关文件
function update_Nginx()
{
    echo "update_Nginx"
    if [ ! -x "/usr/huawei/switchcenter/nginx" ];then
        cp -rfap $localpath/switchcenter/nginx /usr/huawei/switchcenter/
    else
        cp -rfap $localpath/switchcenter/nginx/sbin /usr/huawei/switchcenter/nginx
        cp -rfap $localpath/switchcenter/nginx/conf/nginx.conf /usr/huawei/switchcenter/nginx/conf
        cp -rfap $localpath/switchcenter/nginx/conf/sc_conf/certificate.conf /usr/huawei/switchcenter/nginx/conf/sc_conf
        cp -rfap $localpath/switchcenter/nginx/conf/sc_conf/httpsheader.conf /usr/huawei/switchcenter/nginx/conf/sc_conf
		cp -rfap $localpath/switchcenter/nginx/conf/sc_conf/httpheader.conf /usr/huawei/switchcenter/nginx/conf/sc_conf
        cp -rfap $localpath/switchcenter/nginx/conf/sc_conf/httpslisten.conf /usr/huawei/switchcenter/nginx/conf/sc_conf
        cp -rfap $localpath/switchcenter/nginx/conf/sc_conf/httplisten.conf /usr/huawei/switchcenter/nginx/conf/sc_conf
        cp -rfap $localpath/switchcenter/nginx/conf/sc_conf/websocketheader.conf /usr/huawei/switchcenter/nginx/conf/sc_conf
    fi
	
	if [ ! -f "/usr/huawei/switchcenter/nginx/conf/sc_conf/httplocation.conf" ];then
        cp -rfap $localpath/switchcenter/nginx/conf/sc_conf/httplocation.conf /usr/huawei/switchcenter/nginx/conf/sc_conf
    fi
}

#更新healthy文件夹
function update_healthy()
{
	echo "update_healthy"
	if [ -x "/usr/huawei/switchcenter/healthy" ]; then
	rm -rf /usr/huawei/switchcenter/healthy
	fi

	if [ -x "/usr/huawei/switchcenter/healthy" ]; then
	echo "Update /usr/huawei/switchcenter/healthy failed" >> $localpath/preinstall_save.txt
	echo "fail" >> $localpath/preinstall_result.txt
	exit 1
	fi

	chmod -R 755 $localpath/switchcenter/healthy
	cp -rfap $localpath/switchcenter/healthy /usr/huawei/switchcenter/
}

#转换为Nginx需要的证书
function convertNginxCert()
{
	for line in `cat  /usr/huawei/switchcenter/config/SSLCertification/certificate/sc_key_password.txt`
	do
		chipPwd="`echo $line`"
	done
			
	devPwd=`/usr/huawei/sc_jdk/jdk/jre/bin/java -jar $localpath/switchcenter/Tools/encryptTool.jar "4" $chipPwd ""`
	openssl x509 -outform pem -in /usr/huawei/switchcenter/config/SSLCertification/certificate/sc_cert.pem -out /usr/huawei/switchcenter/config/SSLCertification/certificate_nginx/sc_cert.crt
	openssl rsa -in /usr/huawei/switchcenter/config/SSLCertification/certificate/sc_key.pem -passin pass:$devPwd -out /usr/huawei/switchcenter/config/SSLCertification/certificate_nginx/sc_key.key
}

#===  FUNCTION  ================================================================
#          NAME:  update_certificate
#   DESCRIPTION:  update SSLCertification folder
#    PARAMETERS: 校验当前证书是否默认证书
#       RETURNS:
#===============================================================================
function update_certificate()
{
	echo "update_certificate" >>$logfile
	chmod -R 755 $localpath/switchcenter/config
	if [ -f "/usr/huawei/switchcenter/config/SSLCertification/CA_Root/1_sc_root.pem" ]; then 
	    rm -rf "/usr/huawei/switchcenter/config/SSLCertification/CA_Root/1_sc_root.pem"
	fi
	httpKeyStoreCipher=`su - ${DefUsername} -c "zsql scoperator/${OperatorDBPass}@127.0.0.1:6001 -q -c \"select configvalue from configitem where id=4511;\""|grep "="`
	httpKeyStoreIV=`su - ${DefUsername} -c "zsql scoperator/${OperatorDBPass}@127.0.0.1:6001 -q -c \"select iv from configitem where id=4511;\""|grep "="`
	httpsKeyStorePwd=`$jdkPath/bin/java -jar $absolutePath/switchcenter/Tools/encryptTool.jar "4" "${httpKeyStoreCipher}" "${httpKeyStoreIV}"`
	httpsKeyStoreDefaultPwd=`$jdkPath/bin/java -jar $absolutePath/switchcenter/Tools/encryptTool.jar "4" "4nkqfOpNBilDVTH9aobi1w==" "U2u66jhwoNuN0efm91pWww=="`
	if [ ! -n "${httpsKeyStorePwd}" ]; then
		httpsKeyStorePwd=$httpsKeyStoreDefaultPwd
	fi
	#根据sckeystore指纹判断是否替换过证书
	httpsDefaultCertifcationPath=$absolutePath/switchcenter/config/SSLCertification/old/sckeystore
	httpsCertifcationPath=/usr/huawei/switchcenter/config/SSLCertification/sckeystore
	replace_HTTPS_Certificate=`$jdkPath/bin/java -jar $absolutePath/switchcenter/Tools/CheckCert.jar "https" "$httpsCertifcationPath" "$httpsDefaultCertifcationPath" "$httpsKeyStorePwd" "$httpsKeyStoreDefaultPwd"`
	echo "replace_HTTPS_Certificate.$replace_HTTPS_Certificate" >>$logfile
	
	#根据设备证书的指纹判断是否替换过证书
	tlsDefaultCertPath=$absolutePath/switchcenter/config/SSLCertification/old/certificate/sc_cert.pem
	tlsLocalCertPath=/usr/huawei/switchcenter/config/SSLCertification/certificate/sc_cert.pem
	replace_TLS_Certificate=`$jdkPath/bin/java -jar $absolutePath/switchcenter/Tools/CheckCert.jar "tls" "$tlsDefaultCertPath" "$tlsLocalCertPath"`
	echo "replace_TLS_Certificate.$replace_TLS_Certificate" >>$logfile
	
	#判断是否使用了HUAWEI PKI证书
	pkiDefaultCertPath=$absolutePath/switchcenter/config/SSLCertification/DeviceCert/TLS/4/sc_cert.pem
	pkiLocalCertPath=/usr/huawei/switchcenter/config/SSLCertification/certificate/sc_cert.pem
	replace_PKI_Certificate=`$jdkPath/bin/java -jar $absolutePath/switchcenter/Tools/CheckCert.jar "tls" "$pkiDefaultCertPath" "$pkiLocalCertPath"`
	echo "replace_PKI_Certificate.$replace_PKI_Certificate" >>$logfile
	
	#replace_TLS_Certificate=0表示预置，1表示用户导入证书
	if [ ! -d "/usr/huawei/switchcenter/config/SSLCertification/DeviceCert/TLS/701"  ]; then
		if [ "0" ==  "$replace_PKI_Certificate"  ]; then
			echo "Huawei PKI certificate has been used." >>$logfile	
		elif [ "0" ==  "$replace_TLS_Certificate" ] && [ "0" == "$replace_HTTPS_Certificate" ]; then
			echo "Old VC certificate is still been used, so replace new VC certificate." >>$logfile
			rm -rf /usr/huawei/switchcenter/config/SSLCertification/sckeystore
			rm -rf /usr/huawei/switchcenter/config/SSLCertification/sc_key_password.txt
			cp -rfap $localpath/switchcenter/config/SSLCertification/certificate /usr/huawei/switchcenter/config/SSLCertification/
			cp -rfap $localpath/switchcenter/config/SSLCertification/sc_key_password.txt /usr/huawei/switchcenter/config/SSLCertification/
			cp -rfap $localpath/switchcenter/config/SSLCertification/sckeystore /usr/huawei/switchcenter/config/SSLCertification/
			cp -rfap $localpath/switchcenter/config/SSLCertification/CA_Root/* /usr/huawei/switchcenter/config/SSLCertification/CA_Root/
			cp -rfap $localpath/switchcenter/config/SSLCertification/DeviceCert /usr/huawei/switchcenter/config/SSLCertification/
			"${keytoolPath}" -storepasswd -new ${httpsKeyStorePwd} -keystore "${httpsKeystorePath}" -storepass ${httpsKeyStoreDefaultPwd}
		else
			echo "Old VC certificate is still been replaced, so add new VC certificate." >>$logfile
			cp -rfap $localpath/switchcenter/config/SSLCertification/CA_Root/* /usr/huawei/switchcenter/config/SSLCertification/CA_Root/
			cp -rfap $localpath/switchcenter/config/SSLCertification/DeviceCert /usr/huawei/switchcenter/config/SSLCertification/
			if [ -f "/usr/huawei/switchcenter/config/SSLCertification/certificate/TLSKeyVersion.properties" ]; then
				rm -rf /usr/huawei/switchcenter/config/SSLCertification/certificate/TLSKeyVersion.properties
			fi
			if [ -f "/usr/huawei/switchcenter/config/SSLCertification/httpsKeyVersion.properties" ]; then
				rm -rf /usr/huawei/switchcenter/config/SSLCertification/httpsKeyVersion.properties
			fi
		fi
	fi
	
	#判断是否使用了VC延期证书
	newVcDefaultCertPath=$absolutePath/switchcenter/config/SSLCertification/DeviceCert/TLS/3/sc_cert.pem
	newVcLocalCertPath=/usr/huawei/switchcenter/config/SSLCertification/certificate/sc_cert.pem
	replace_VC_Certificate=`$jdkPath/bin/java -jar $absolutePath/switchcenter/Tools/CheckCert.jar "tls" "$newVcDefaultCertPath" "$newVcLocalCertPath"`
	echo "replace_VC_Certificate.$replace_VC_Certificate" >>$logfile
	
	#处理nginx证书
	if [ ! -d "/usr/huawei/switchcenter/config/SSLCertification/certificate_nginx"  ]; then
		mkdir -p /usr/huawei/switchcenter/config/SSLCertification/certificate_nginx
		chown -R scapp:sc /usr/huawei/switchcenter/config/SSLCertification/certificate_nginx
		chmod -R 700 /usr/huawei/switchcenter/config/SSLCertification/certificate_nginx

		if [ "0" ==  "$replace_PKI_Certificate"  ]; then
			echo "Huawei PKI certificate has been used. copy certificate_PKI_nginx" >>$logfile
			cp -rfap $localpath/switchcenter/config/SSLCertification/certificate_PKI_nginx/* /usr/huawei/switchcenter/config/SSLCertification/certificate_nginx/
		elif [ "0" ==  "$replace_VC_Certificate"  ]; then
			echo "VC certificate has been used. copy certificate_nginx" >>$logfile
			cp -rfap $localpath/switchcenter/config/SSLCertification/certificate_nginx/* /usr/huawei/switchcenter/config/SSLCertification/certificate_nginx/
		else
			echo "User-defined certificate has been used. Convert the certificate to the Nginx certificate.." >>$logfile
			convertNginxCert
		fi
		chown -R scapp:sc /usr/huawei/switchcenter/config/SSLCertification/certificate_nginx/*
		chmod -R 600 /usr/huawei/switchcenter/config/SSLCertification/certificate_nginx/*
		
	fi
	
	# 处理国密预置证书
	if [ ! -d "/usr/huawei/switchcenter/config/SSLCertification/DeviceCert/TLS/5"  ]; then
		cp -rfap $localpath/switchcenter/config/SSLCertification/DeviceCert/TLS/5 /usr/huawei/switchcenter/config/SSLCertification/DeviceCert/TLS/	
	fi
}

#===  FUNCTION  ================================================================
#          NAME:  update_Files
#   DESCRIPTION:  update SwitchCenter files except OpenDJ
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function update_Files()
{
	echo "update_Files"
	
	update_Bin
 
	update_Install

	update_Uninstall
	
	update_Tools
	
	update_Nginx
	
	update_healthy
	
	chown -R ${AppUsername}:${DefUserGroup} /usr/huawei
	chown -R ${DefUsername}:${DefUserGroup} /usr/huawei/sc_backupDB > /dev/null 2>&1
	chmod -R 755 /usr/huawei
}

#===  FUNCTION  ================================================================
#          NAME:  update_GaussDB_File
#   DESCRIPTION:  delete old GaussDB and Install a new GaussDB
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function update_GaussDB_File()
{
	echo "update_GaussDB_File"
	
	
}

#===  FUNCTION  ================================================================
#          NAME:  update_OpenDJ_Schema
#   DESCRIPTION:  update OpenDJ
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function update_GaussDB_data()
{
	echo "update_GaussDB_data $1"
	updateFile=$1
	if [ ! -f "$localpath/switchcenter/Update/${updateFile}" ]; then
	  echo "$localpath/switchcenter/Update/${updateFile} is not exist,no need to update" >> $logfile
	  return
	fi
	
	if [ -x /usr/huawei/switchcenter/Update_bak ]; then
		rm -rf /usr/huawei/switchcenter/Update_bak
	fi
	if [ -x /usr/huawei/switchcenter/Update ]; then
		mv /usr/huawei/switchcenter/Update /usr/huawei/switchcenter/Update_bak
	fi
	mkdir -p /usr/huawei/switchcenter/Update
	cp -f $localpath/switchcenter/Update/${updateFile} /usr/huawei/switchcenter/Update
	chown -R ${DefUsername}:${DefGroupName} /usr/huawei/switchcenter/Update
	chmod 755 /usr/huawei/switchcenter/Update/${updateFile}
	su - ${DefUsername} -c "zsql scoperator/${OperatorDBPass}@127.0.0.1:6001 -q -f /usr/huawei/switchcenter/Update/${updateFile} >>/usr/huawei/switchcenter/Update/update.log"
	
	keyStoreCipher=`su - ${DefUsername} -c "zsql scoperator/${OperatorDBPass}@127.0.0.1:6001 -q -c \"select configvalue from configitem where id=3526;\""|grep "="`
	keyStoreIV=`su - ${DefUsername} -c "zsql scoperator/${OperatorDBPass}@127.0.0.1:6001 -q -c \"select iv from configitem where id=3526;\""|grep "="`
	keyStorePwd=`$jdkPath/bin/java -jar $localpath/switchcenter/Tools/encryptTool.jar "4" "${keyStoreCipher}" "${keyStoreIV}"`
	keystoreDefaultPwd=`$jdkPath/bin/java -jar $localpath/switchcenter/Tools/encryptTool.jar "4" "AtRV9YjjbnwRE4MqIgvTSQ==" "aJ865KRy9CnbB/7YR6VjpA=="`
	"${keytoolPath}" -storepasswd -new ${keyStorePwd} -keystore "${keystorePath}" -storepass ${keystoreDefaultPwd}
		
	
	#将CA_Root中的根证书导入到jreKeyStore 若keystore中已导入别名为huawei_sc_ldap_root的证书 ，不再导入别名为huawei_sc_ldap_root.pem的证书
	if [ -x ${CAPtah} ];then
		for storeName in `ls ${CAPtah} |grep .pem$ | grep ^[0-9]` 
		do 
			keyAlias=`echo ${storeName} | sed 's/^[0-9_]*//g'`
			"${keytoolPath}" -list -v -alias `echo ${keyAlias} | sed 's/.pem//g'` -keystore "${keystorePath}" -storepass ${keyStorePwd} > /dev/null 2>&1
			if [ $? -ne 0 ];then
				"${keytoolPath}" -importcert -noprompt -trustcacerts -alias ${keyAlias} -keystore "${keystorePath}" -storepass ${keyStorePwd} -file "${CAPtah}/${storeName}" > /dev/null 2>&1
			fi
		done
	fi
	
	echo "Update DB tables success"
}

#===  FUNCTION  ================================================================
#          NAME:  read_NewVersion
#   DESCRIPTION:  get the new SC's versionNum
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function read_NewVersion()
{
	echo "read_NewVersion"
	newVersionPath="$localpath/switchcenter/Bin/version"
	
	if [ ! -f $newVersionPath ]; then
		echo "new version file is not exist" >> $localpath/preinstall_save.txt
		echo "fail" >> $localpath/preinstall_result.txt
		exit 1
    else
		dos2unix $newVersionPath
		new=`sed -n 2p $newVersionPath`
	fi
}

#===  FUNCTION  ================================================================
#          NAME:  read_OldVersion
#   DESCRIPTION:  get the old SC's versionNum
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function read_OldVersion()
{
    echo "read_OldVersion"
	oldVersionPath="/usr/huawei/switchcenter/Bin/version"

	if [ ! -f $oldVersionPath ]; then
		old="0"
    else
		dos2unix $oldVersionPath
		old=`sed -n 2p $oldVersionPath`
   fi
}

#===  FUNCTION  ================================================================
#          NAME:  want_Update_GaussDB
#   DESCRIPTION:  depending on the version number to determine whether you can update
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function want_Update_GaussDB()
{
	echo "want_Update_GaussDB"
	
	### 监听ipv6本地回环地址::1 ###
	sedFile /DB_DATA/data/cfg/zengine.ini "LSNR_ADDR[[:space:]]?*?=" "LSNR_ADDR = 127.0.0.1,::1"
	
	#update_GaussDB_File
	startGaussDB
	pgStatus=$?
	if [ 0 -ne ${pgStatus} ]; then
		echo `date`":The GaussDB can't be started.Faild to update DB." >> $logfile
	else
		sleep 10
		echo `date`":update_certificate" >>$logfile
		update_certificate	
		if [ ! -f /usr/huawei/switchcenter/Bin/docker.sig ]; then	
			update_GaussDB_data "update.sql"
		else
			update_GaussDB_data "update_docker.sql"
		fi		
	fi
	stopGaussDB
}

#===  FUNCTION  ================================================================
#          NAME:  want_Update_OpenDJ
#   DESCRIPTION:  update the OpenDJ
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function update_GaussDB()
{
	echo "update_GaussDB"
	
	if [ "$InstallType" = "update" ]; then
		echo "param : update"
		want_Update_GaussDB
	fi
}

#===  FUNCTION  ================================================================
#          NAME:  copy_SC
#   DESCRIPTION:  copy SwitchCenter Files To The Specified Folder
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function copy_SC()
{
	echo "copy_SC"
	if [ ! -x "/usr/huawei" ]; then
	echo "Create /usr/huawei failed" >> $localpath/preinstall_save.txt
	echo "fail" >> $localpath/preinstall_result.txt
	exit 1
	fi

	if [ ! -x "/usr/huawei/switchcenter" ]; then
	echo "Create /usr/huawei/switchcenter failed" >> $localpath/preinstall_save.txt
	echo "fail" >> $localpath/preinstall_result.txt
	exit 1
	fi

	chmod -R 755 $localpath/switchcenter/
	cp -rfap $localpath/switchcenter /usr/huawei/

	#19.1 root整改新增
	echo `date`":start move_RootShellToDir for install." >>$logfile
	move_RootShellToDir
	echo `date`":end move_RootShellToDir for install." >>$logfile
	
	#日志归档,需要新增归档日志目录
	if [ ! -x /usr/huawei/switchcenter/Log/RotateLog ]; then
	    mkdir -p /usr/huawei/switchcenter/Log/RotateLog
	fi
	
	# 日志重新放置在TodayLog目录,若不存在则创建
	if [ ! -x /usr/huawei/switchcenter/Log/TodayLog ]; then
	    mkdir -p /usr/huawei/switchcenter/Log/TodayLog
	fi
	
	chown -R scapp:sc /usr/huawei/switchcenter/Log
	chmod -R 755 /usr/huawei/switchcenter/Log
	
	ldconfig
}

function install_JDK()
{
	echo "install_JDK"	
	if [ ! -x /usr/huawei/sc_jdk ]; then
		mkdir -p /usr/huawei/sc_jdk
	fi
	rm -rf /usr/huawei/sc_jdk/*
	
	cp -rfap $localpath/switchcenter/Tools/jdk-*.tar.gz /usr/huawei/sc_jdk
	cd /usr/huawei/sc_jdk
	
	tar zxvf ./jdk-*.tar.gz > jdk.out
	
	mv jdk*/ ./jdk
	
	chmod -R 755 /usr/huawei/sc_jdk
	rm -rf /usr/huawei/sc_jdk/jdk-*.tar.gz
	
	ulimitR=`grep "ulimit -r unlimited" /etc/profile | wc -l`
	if [ $ulimitR -eq 0 ]; then
		echo 'ulimit -r unlimited' >> /etc/profile
	fi
	
	ulimitN=`grep "ulimit -n 102400" /etc/profile | wc -l`
	if [ $ulimitN -eq 0 ]; then
		echo 'ulimit -n 102400' >> /etc/profile
	fi
	
	sedFile $jdkPath/lib/security/java.security "jdk.tls.disabledAlgorithms=" "jdk.tls.disabledAlgorithms=RC4, DH keySize < 768"
	if [ 1 -eq $EulerV2R8 ];then
		source  $absolutePath/switchcenter/Tools/importLib64.sh
	fi
	if [ ! -f /usr/huawei/switchcenter/Bin/docker.sig ]; then
		source /etc/profile
	fi
	cd $cmdPath
}

#===  FUNCTION  ================================================================
#          NAME:  checkOSUserExist
#   DESCRIPTION:  check os user if exist
#    PARAMETERS:
#       RETURNS:
#===============================================================================
checkOSUserExist()
{
    IsExistCnt=`cat ${SysPasswdF}|grep "^${DefUsername}:" |wc -l`
    if [ $IsExistCnt -gt 0 ]; then
        return 1
    else
        return 0
    fi
}


#===  FUNCTION  ================================================================
#          NAME:  install_SC
#   DESCRIPTION:  Install SwitchCenter Runtime Environment And Start SwitchCenter Service
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function install_SC()
{
	### set boot and start the service ###
	echo "install_SC"

	if [ ! -x "/usr/huawei/switchcenter/Install/install_environment.sh" ]; then
	echo "install_environment.sh script does not exist" >> $localpath/preinstall_save.txt
	echo `date`":install_environment.sh script does not exist" >> $logfile
	echo "fail" >> $localpath/preinstall_result.txt
	exit 1
	fi
	cd /usr/huawei/switchcenter/Install
	echo `date`":install_SC start install_environment $StartFlag $SysCheck" >> $logfile
	/usr/huawei/switchcenter/Install/install_environment.sh $StartFlag $SysCheck
	echo `date`":install_SC finish install_environment" >> $logfile
	cd $cmdPath
	if [ ! -x "/usr/huawei/switchcenter/Install/start.sh" ]; then
		echo "start.sh script does not exist" >> $localpath/preinstall_save.txt
		echo `date`":start.sh script does not exis" >> $logfile
		echo "fail" >> $localpath/preinstall_result.txt
		exit 1
	fi
	
	cd $cmdPath
	if [ ! -x "/usr/huawei/switchcenter/Bin/key" ]; then
			mkdir /usr/huawei/switchcenter/Bin/key
	fi
	
	cd $cmdPath
	if [ ! -x "/usr/huawei/switchcenter/Bin/kmcKey" ]; then
			mkdir /usr/huawei/switchcenter/Bin/kmcKey
	fi
	
	cd $cmdPath
	#su - sc <<EOF
	if [ $StartFlag = "start" ]; then
		service syslog stop
		service syslog start
		cd /usr/huawei/switchcenter/Install
		./start.sh
		
	fi
	cd $cmdPath
#EOF

}

#===  FUNCTION  ================================================================
#          NAME:  change_passwd
#   DESCRIPTION:  change os user password
#    PARAMETERS:
#       RETURNS:
#===============================================================================
change_passwd()
{   
    echo "change_passwd"
    if [ $# != 2 ]; then
        echo "Invalid usage, need two parameters [$#][$*]!"
        return 1
    fi

    user_name=$1
    shift 1
    password=($*)

    grep "^${user_name}:" ${SysPasswdF} >/dev/null 2>&1
    if [ $? != 0 ]; then
        echo "User not exist [${user_name}]!"
        return 2
    fi

    if [ "-${password[*]}" == "-" ]; then
        echo "Null password!"
        return 3
    fi

    #if [ -x /usr/sbin/chpasswd ]; then
       # echo "${user_name}:${password[*]}" | /usr/sbin/chpasswd
    #else
        (sleep 1; echo "${password[*]}"; sleep 2; echo "${password[*]}") | passwd ${user_name}>/dev/null 2>&1
    #fi
    return $?
}

function configSysctl()
{
	echo "configSysctl"
	sed -i '/net.ipv4.conf.all.arp_filter/d' /etc/sysctl.conf
	sed -i '/net.ipv4.conf.all.rp_filter/d' /etc/sysctl.conf
	sed -i '/net.ipv4.neigh.default.gc_thresh1/d' /etc/sysctl.conf
	sed -i '/net.ipv4.neigh.default.gc_thresh2/d' /etc/sysctl.conf
	sed -i '/net.ipv4.neigh.default.gc_thresh3/d' /etc/sysctl.conf
	sed -i '/net.ipv4.neigh.default.gc_stale_time/d' /etc/sysctl.conf
	sed -i '/kernel.msgmax/d' /etc/sysctl.conf
	sed -i '/kernel.msgmnb/d' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.all.accept_dad/d' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.default.accept_dad/d' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.eth0.accept_dad/d' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.eth1.accept_dad/d' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.eth2.accept_dad/d' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.eth3.accept_dad/d' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.eth4.accept_dad/d' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.eth5.accept_dad/d' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.eth6.accept_dad/d' /etc/sysctl.conf
	sed -i '/net.core.wmem_max = 1048576/d' /etc/sysctl.conf
	sed -i '/net.core.rmem_max = 1048576/d' /etc/sysctl.conf
	
	
	echo "net.ipv4.conf.all.arp_filter = 1" >> /etc/sysctl.conf
	echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf
	echo "net.ipv4.neigh.default.gc_thresh1 = 512" >> /etc/sysctl.conf
	echo "net.ipv4.neigh.default.gc_thresh2 = 2048" >> /etc/sysctl.conf
	echo "net.ipv4.neigh.default.gc_thresh3 = 4096" >> /etc/sysctl.conf
	echo "net.ipv4.neigh.default.gc_stale_time = 240" >> /etc/sysctl.conf
	echo "kernel.msgmax = 65535" >> /etc/sysctl.conf
	echo "kernel.msgmnb = 2097152" >> /etc/sysctl.conf
	echo "net.ipv6.conf.all.accept_dad = 0" >> /etc/sysctl.conf
	echo "net.ipv6.conf.default.accept_dad = 0" >> /etc/sysctl.conf
	echo "net.ipv6.conf.eth0.accept_dad = 0" >> /etc/sysctl.conf
	echo "net.ipv6.conf.eth1.accept_dad = 0" >> /etc/sysctl.conf
	echo "net.ipv6.conf.eth2.accept_dad = 0" >> /etc/sysctl.conf
	echo "net.ipv6.conf.eth3.accept_dad = 0" >> /etc/sysctl.conf
	echo "net.ipv6.conf.eth4.accept_dad = 0" >> /etc/sysctl.conf
	echo "net.ipv6.conf.eth5.accept_dad = 0" >> /etc/sysctl.conf
	echo "net.ipv6.conf.eth6.accept_dad = 0" >> /etc/sysctl.conf
	echo "net.core.wmem_max = 1048576" >> /etc/sysctl.conf
	echo "net.core.rmem_max = 1048576" >> /etc/sysctl.conf
	
        #开启dump
	sed -i '/fs.suid_dumpable/d' /etc/sysctl.conf
	echo "fs.suid_dumpable = 1" >> /etc/sysctl.conf
	if [ ! -f /usr/huawei/switchcenter/Bin/docker.sig ]; then
		sysctl -p
	fi
}

#文件内容替换函数（确保覆盖）
function sedFile()
{
	sourceFile=$1
	compStr=$2
	sedStr=$3
	tmpFile1=$sourceFile.huawei.tmp
	tmpFile2=$tmpFile1.tmp
	echo "sedFile: $sourceFile||$compStr||$sedStr"
	#如果源文件不存在就不替换
	if [ ! -f $sourceFile ]; then
		echo "no such file $sourceFile"
		return
	fi
	
	#拷贝源文件生成临时文件
	cp $sourceFile $tmpFile1
	cp $sourceFile $tmpFile2
	#已有未注释配置项，覆盖第一条
	ret=`egrep -n "^[[:space:]]?*?[[:space:]]?$compStr" $tmpFile1|wc -l`
	if [ $ret -gt 0 ]; then
		line=`egrep -n "^[[:space:]]?*?[[:space:]]?$compStr" $tmpFile1|cut -d ":" -f 1|head -1`
		if [ $line -gt 0 ]; then
			echo "sedFile: exist line$line"
			sed ${line}c\ "$sedStr" $tmpFile2 > $tmpFile1
		fi
		cat $tmpFile1 > $sourceFile
		rm -rf $tmpFile1
		rm -rf $tmpFile2
		return
	fi
	
	#配置项被注释掉，覆盖第一条
	ret=`egrep -n "^[[:space:]]?*?[[:space:]]?#[[:space:]]?*?[[:space:]]?$compStr" $tmpFile1|wc -l`
	if [ $ret -gt 0 ]; then
		line=`egrep -n "^[[:space:]]?*?[[:space:]]?#[[:space:]]?*?[[:space:]]?$compStr" $tmpFile1|cut -d ":" -f 1|head -1`
		if [ $line -gt 0 ]; then
			echo "sedFile: comment line$line"
			sed ${line}c\ "$sedStr" $tmpFile2 > $tmpFile1
		fi
		cat $tmpFile1 > $sourceFile
		rm -rf $tmpFile1
		rm -rf $tmpFile2
		return
	fi
	echo "3"
	#没有这种配置项，文件尾部添加一条
	echo "sedFile: not exist"
	echo "$sedStr" >> $sourceFile
}

#创建容灾需要的文件
function mkdirFailoverFile()
{
	localFailoverPath="/usr/huawei/switchcenter/Bin"

	if [ -f $localFailoverPath/KeyVersion.properties ];then
		chown scapp:sc $localFailoverPath/KeyVersion.properties
	fi
	if [ -f $localFailoverPath/TLSKeyVersion.properties ];then
		chown scapp:sc $localFailoverPath/TLSKeyVersion.properties
	fi

	chown -R scapp:sc /usr/huawei/switchcenter/config

	failoverDataPath="/usr/huawei/switchcenter/Bin/failoverData"

	if [ ! -x $failoverDataPath/Active ];then
			mkdir -p $failoverDataPath/Active
			echo `date`":mkdir Active" >>$logfile
	fi
	if [ ! -x $failoverDataPath/Temp ];then
			mkdir -p $failoverDataPath/Temp
			echo `date`":mkdir Temp" >>$logfile
	fi
	if [ ! -x $failoverDataPath/Standby ];then
			mkdir -p $failoverDataPath/Standby
			echo `date`":mkdir Standby" >>$logfile
	fi
	chmod -R 755 /usr/huawei/switchcenter/Bin/failoverData
	chown -R scapp:sc /usr/huawei/switchcenter/Bin/failoverData

	failoverSFTP="/usr/huawei/switchcenter/Bin/share"
	if [ ! -x $failoverSFTP ];then
			mkdir -p $failoverSFTP/failover
			echo `date`":mkdir failover" >>$logfile
	fi
	chmod -R 755 $failoverSFTP
	chown -R scapp:sc $failoverSFTP
	
	#umask 0022
}
#===  FUNCTION  ================================================================
#          NAME:  move_RootShellToDir
#   DESCRIPTION:  Install SwitchCenter Runtime Environment And Start SwitchCenter Service
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function move_RootShellToDir()
{
	# 19.1 root用户整改 新增目录/usr/huawei_sc/存放root用户权限的脚本
	if [ -x /usr/huawei_sc/ ]; then
		rm -rf /usr/huawei_sc/
	fi
	
	mkdir /usr/huawei_sc/
	
	mv /usr/huawei/switchcenter/Bin/restartAllExec.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/runUpdate.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/recovery.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/oneTouchBackup.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/abnormalRollBack.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/scappReboot.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/setRoute.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/startNtp.sh /usr/huawei_sc/
	
	mv /usr/huawei/switchcenter/Bin/stopNtp.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/stopCrontab.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/startCrontab.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/startRotateScLog.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/startNginxRotateLog.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/startCheckSshdListenAddress.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/portRedirect.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/checkPortLic.sh /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/startCheckLookDoorDog.sh /usr/huawei_sc/
	
	# 使用logrotate调用sclog进行日志归档,sclog文件所属需要为root用户，权限需要为644
	mv /usr/huawei/switchcenter/Bin/sclog  /usr/huawei_sc/
	mv /usr/huawei/switchcenter/Bin/scNginxLog  /usr/huawei_sc/
	chown -R root:root /usr/huawei_sc/
	chmod -R 750 /usr/huawei_sc/
	chmod 644 /usr/huawei_sc/sclog
	chmod 644 /usr/huawei_sc/scNginxLog
}

#===  FUNCTION  ================================================================
#          NAME:  service_rollback
#   DESCRIPTION:  service rollback when check rpm package missing
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function service_rollback()
{
	echo `date`":Enter service_rollback" >> $logfile
	chkconfig --del SwitchCenterUpdateService
	rm -rf /etc/init.d/SwitchCenterUpdateService
	
	cp -rf /usr/huawei/SwitchCenterService /etc/init.d/
	
	chmod 755 /etc/init.d/SwitchCenterService
	chkconfig --add SwitchCenterService
	
	reboot
}

#===  FUNCTION  ================================================================
#          NAME:  main
#   DESCRIPTION:  
#    PARAMETERS:
#       RETURNS:
#===============================================================================
function main()
{
	#默认开启coredump并且修改相关权限
    if [ ! -d "/var/crash/sc" ]; then
        mkdir -p /var/crash/sc
    fi
    chmod 700 /var/crash/sc
    if ! grep "ulimit -c unlimited" /etc/profile
    then
    echo "the contents of coreDume are appended to /etc/profile"
    cat<<"EOF">>/etc/profile
	iam=`whoami`
	if [ $iam == "root" ]; then
		ulimit -c unlimited
		echo 1 > /proc/sys/kernel/core_uses_pid
		echo "/var/crash/sc/core-%e-%p-%t" > /proc/sys/kernel/core_pattern
		
	fi
EOF
	if [ ! -f /usr/huawei/switchcenter/Bin/docker.sig ]; then
		source /etc/profile
	fi
	fi
	echo `date`":start" >> $localpath/switchcenter/install.log
	
	chmod -R 755 /etc
	chmod -R 400 /etc/ssh > /dev/null 2>&1
	#只有Euler需要停止以下服务
	if [ $OsType = "Euler" ]; then
		service nfs stop > /dev/null 2>&1
		service rpcbind stop > /dev/null 2>&1
		service cups stop > /dev/null 2>&1
		chkconfig --del nfs > /dev/null 2>&1
		chkconfig --del rpcbind > /dev/null 2>&1
		chkconfig --del cups > /dev/null 2>&1
		
		#euler安装SC的rpm包时，可能euler还没有加固，先修改passwd文件，避免使用blowfish算法
		sed -i "s/^CRYPT_FILES=.*/CRYPT_FILES=sha256/g" /etc/default/passwd > /dev/null 2>&1
		sed -i "s/^CRYPT=.*/CRYPT=sha256/g" /etc/default/passwd > /dev/null 2>&1
		sed -i "s/^BLOWFISH_2a2x=.*/BLOWFISH_2a2x=no/g" /etc/default/passwd > /dev/null 2>&1
		#去除切换用户打印登录信息
		sed -i "/session[[:space:]]*include[[:space:]]*postlogin/d" /etc/pam.d/su > /dev/null 2>&1
	fi
	if [ ! -f /usr/huawei/switchcenter/Bin/docker.sig ]; then
		ulimit -r unlimited
		ulimit -n 20000
	fi
	# 19.1整改root用户运行进程为scapp，修改/etc/sudoers文件，使用sudo命令
	# 将tab替换为空格(欧拉/etc/sudoers中格式为root-TAB-ALL导致无法匹配上)
	sed -i "s/\t/ /g" /etc/sudoers
	
	#root用户切换 欧拉V1R1及部分suse netstat scapp用户无执行权限
	chmod 755 /bin/netstat
	
	user_scapp=`cat /etc/sudoers | grep "scapp ALL=(root) NOPASSWD" | wc -l`
	if [ ${user_scapp} -eq 0 ]; then
		sed -i "s+^root *ALL=(ALL) *ALL+root ALL=(ALL) ALL\nscapp ALL=(root) NOPASSWD:/bin/date,/sbin/hwclock,/bin/su - sc,/sbin/chkconfig --del SwitchCenterService,/usr/sbin/iptables,/usr/sbin/ip6tables,/usr/sbin/iptables-save,/usr/sbin/ip6tables-save,/usr/sbin/dmidecode,/usr/bin/du,/usr/sbin/logrotate,/usr/huawei_sc/restartAllExec.sh,/usr/huawei_sc/runUpdate.sh,/usr/huawei_sc/recovery.sh,/usr/huawei_sc/oneTouchBackup.sh,/usr/huawei_sc/abnormalRollBack.sh,/usr/huawei_sc/scappReboot.sh,/usr/huawei_sc/setRoute.sh,/usr/huawei_sc/startNtp.sh,/usr/huawei_sc/stopCrontab.sh,/usr/huawei_sc/stopNtp.sh,/usr/huawei_sc/portRedirect.sh,/usr/huawei_sc/checkPortLic.sh+" /etc/sudoers
	else
		sed -i "s|scapp ALL=(root) NOPASSWD:.*|scapp ALL=(root) NOPASSWD:/bin/date,/sbin/hwclock,/bin/su - sc,/sbin/chkconfig --del SwitchCenterService,/usr/sbin/iptables,/usr/sbin/ip6tables,/usr/sbin/iptables-save,/usr/sbin/ip6tables-save,/usr/sbin/dmidecode,/usr/bin/du,/usr/sbin/logrotate,/usr/huawei_sc/restartAllExec.sh,/usr/huawei_sc/runUpdate.sh,/usr/huawei_sc/recovery.sh,/usr/huawei_sc/oneTouchBackup.sh,/usr/huawei_sc/abnormalRollBack.sh,/usr/huawei_sc/scappReboot.sh,/usr/huawei_sc/setRoute.sh,/usr/huawei_sc/startNtp.sh,/usr/huawei_sc/stopCrontab.sh,/usr/huawei_sc/stopNtp.sh,/usr/huawei_sc/portRedirect.sh,/usr/huawei_sc/checkPortLic.sh|g" /etc/sudoers
	fi
	
	if [ -f /usr/huawei/switchcenter/Uninstall/stop.sh ]; then
		chage -M 9999 -W 15 sc
		/usr/huawei/switchcenter/Uninstall/stop.sh
		echo "all stoped"
	fi
	
	echo `date`":stat configSysctl" >>$logfile
	configSysctl
	echo `date`":finish configSysctl" >>$logfile
	if [ ! -f /usr/huawei/switchcenter/Bin/docker.sig ]; then
		sedFile /etc/ssh/sshd_config "Port[[:space:]]*[[:space:]]" "Port 22"
	fi
	if [ ! -x /usr/sc_rollback ]; then
		mkdir /usr/sc_rollback
	fi
	cp -rf $localpath/rollback.sh /usr/sc_rollback/
	cp -rf $localpath/rollback_for_old_version_pgsql.sh /usr/sc_rollback/
	chmod 740 /usr/sc_rollback/*.sh
	
	if [ -x /usr/huawei/switchcenter/Bin -a $InstallType = "update" ]; then
		echo `date`":start backup data" >>$logfile
		
		/usr/huawei/switchcenter/Bin/startCipher.sh
		### 数据库密码请求
		usr=`whoami`
		echo $usr
		if [ ${usr} == "root" ]; then
			su - scapp <<EOF
			echo "ReqType=1" > /usr/huawei/switchcenter/security/req/preinstall_start.properties
EOF
		else
			echo "ReqType=1" > /usr/huawei/switchcenter/security/req/preinstall_start.properties
		fi
		### 处理密码响应
		checkProperty

		stop_SC

		chage -M 9999 -W 15 sc
		if [ ! -x "/usr/huawei/sc_backup" ]; then
			mkdir /usr/huawei/sc_backup
		fi
		
		rm -rf /usr/huawei/sc_backup/*
		
		if [ ! -d "/usr/huawei/switchcenter/Log/TodayLog" ];then
			mkdir -p /usr/huawei/switchcenter/Log/TodayLog
		fi
		if [ -d "/usr/huawei/switchcenter/Bin/backup" ]; then 
		   mv /usr/huawei/switchcenter/Bin/backup/* /usr/huawei/switchcenter/Log/TodayLog
        fi
		
		cd /usr/huawei	
		tar -zcf ./switchcenter_bak.tar.gz --exclude=./switchcenter/Log ./switchcenter
		cd /
		echo `date`":start backup DB" >>$logfile
		tar -zcf ./DB_DATA_bak.tar.gz ./DB_DATA
		echo `date`":finish backup DB" >>$logfile
		cd $cmdPath
		mv /usr/huawei/switchcenter_bak.tar.gz /usr/huawei/sc_backup
		mv /DB_DATA_bak.tar.gz /usr/huawei/sc_backup
		
		if [ -x /usr/huawei_sc ]; then
			cp -rf /usr/huawei_sc/ /usr/huawei/sc_backup/
		fi
		
		# 欧拉V2R7和V2R8 需要备份 SwitchCenter.service
		if [ $OsType = "Euler" ]; then
			echo `date`":backup SwitchCenter.service" >>$logfile
			cp -f /usr/lib/systemd/system/SwitchCenter.service /usr/huawei/
			echo `date`":backup SwitchCenter.service success" >>$logfile
		fi
		
		if [ -x /usr/huawei/sc_jdk ]; then
			cp -rf /usr/huawei/sc_jdk/ /usr/huawei/sc_backup/
		fi
		
		echo `date`":finish backup data" >>$logfile
		
		sleep 10
		
		useradd ${AppUsername} -s /bin/bash -m -d ${AppUserHome} -g ${DefUserGroup}
		
		if [ ! -x "${AppUserHome}" ]; then
			mkdir ${AppUserHome}
			chown -R ${AppUsername}:${DefUserGroup} ${AppUserHome}
			chmod -R 755 ${AppUserHome}
		fi		
		
		echo `date`":start install_JDK" >>$logfile
		install_JDK
		echo `date`":finish install_JDK" >>$logfile
		
		os_pass=`$jdkPath/bin/java -jar $localpath/switchcenter/Tools/encryptTool.jar "1" "f6d3f965c844b450b17ab1f3cbef57c179baa576dfa8a0f7ae7271857ec7ceea"`
		
		change_passwd ${DefUsername} ${os_pass}
		change_passwd ${AppUsername} ${os_pass}
		chage -M 9999 -W 15 sc
		chage -M 9999 -W 15 scapp

		echo `date`":update_GaussDB" >>$logfile
		update_GaussDB
		echo `date`":start update_Files" >>$logfile
		update_Files
		echo `date`":finish update_Files" >>$logfile
		
		#去除HostKeyAlgorithms +ssh-dss弱加密算法，改用RSA算法
		if [ ! -f /usr/huawei/switchcenter/Bin/docker.sig ]; then
			cat /root/.ssh/known_hosts | grep "122\ ssh-dss"
			if [ $? -eq 0 ];then
				sed -i "/ssh-dss/d" /root/.ssh/known_hosts > /dev/null 2>&1
				rm -rf /usr/huawei/switchcenter/Bin/key.ser
				sed -i "/ssh-dss/d" /root/.ssh/config > /dev/null 2>&1
			fi
		fi
		
		#升级时，修改已有日志文件的权限
		chmod 640 /tmp/scproxy.log > /dev/null 2>&1
		chmod 640 /tmp/scbackup.log > /dev/null 2>&1
		chmod 640 /tmp/mediaproxy.log > /dev/null 2>&1
		
		rm -rf /usr/bin/readelf > /dev/null 2>&1
		rm -rf /usr/bin/objdump > /dev/null 2>&1
		
		if [ -d "/usr/huawei/switchcenter/Bin/backup" ]; then
			chmod 640 /usr/huawei/switchcenter/Bin/backup/*
		fi
		
		# root整改后，修改下已有日志文件的所属用户（故障收集时会操作相关日志）
		chown scapp:sc /tmp/*.log > /dev/null 2>&1
		chown scapp:sc /*.log.tar.gz > /dev/null 2>&1
		
		# root用户整改,修改下/var/crash/sc/下dump文件的所属用户(故障收集时会操作相关文件)
		chown scapp:sc /var/crash/sc/* > /dev/null 2>&1
		
		#DTS2020030700865 现网问题/var/log/addit目录下日志爆满，修改auditd.conf日志,使用欧拉默认配置ROTATE
		cat /etc/audit/auditd.conf | grep "max_log_file_action = keep_logs"
		if [ $? -eq 0 ]; then
			sed -i "/max_log_file_action/d" /etc/audit/auditd.conf
			sed -i "/admin_space_left_action/d" /etc/audit/auditd.conf
			echo "max_log_file_action = ROTATE">>/etc/audit/auditd.conf
			echo "admin_space_left_action = SUSPEND">>/etc/audit/auditd.conf
		else
			echo "the audit is ok"
		fi
	else
		
		##新安装前先卸载
		if [ -x /home/sc ] || [ -x /DB_DATA ] || [ -x /usr/huawei ];then
			$localpath/switchcenter/Uninstall/remove.sh
		fi
		
		groupadd ${DefUserGroup}
		
		useradd ${DefUsername} -s /bin/bash -m -d ${DefUserHome} -g ${DefUserGroup}
		useradd ${AppUsername} -s /bin/bash -m -d ${AppUserHome} -g ${DefUserGroup}

		
		
		if [ ! -x "/usr/huawei" ]; then
			mkdir /usr/huawei
		fi
		if [ ! -x "${DefUserHome}" ]; then
			mkdir ${DefUserHome}
			chown -R ${Defusername}:${DefUserGroup} ${DefUserHome}
			chmod -R 755 ${DefUserHome}
		fi
		
		if [ ! -x "${AppUserHome}" ]; then
			mkdir ${AppUserHome}
			chown -R ${AppUsername}:${DefUserGroup} ${AppUserHome}
			chmod -R 755 ${AppUserHome}
		fi
		
		echo `date`":start install_JDK" >>$logfile
		install_JDK
		echo `date`":finish install_JDK" >>$logfile
		
		os_pass=`$jdkPath/bin/java -jar $localpath/switchcenter/Tools/encryptTool.jar "1" "f6d3f965c844b450b17ab1f3cbef57c179baa576dfa8a0f7ae7271857ec7ceea"`
		
		change_passwd ${DefUsername} ${os_pass}
		change_passwd ${AppUsername} ${os_pass}
		chage -M 9999 -W 15 sc
		chage -M 9999 -W 15 scapp
		
		mkdir /usr/huawei/switchcenter
		mkdir /usr/huawei/sc_update
		mkdir -p /usr/huawei/switchcenter/security/req
		mkdir -p /usr/huawei/switchcenter/security/rsp
		
		echo `date`":start copy_SC" >>$logfile
		copy_SC
		echo `date`":finish copy_SC" >>$logfile
		
		chown -R ${AppUsername}:${DefUserGroup} /usr/huawei
		chown -R ${DefUsername}:${DefUserGroup} /usr/huawei/switchcenter/DB
		chmod -R 755 /usr/huawei
		## 解密进程依赖libcbbJNI.so，必须在解密进程启动前拷贝此文件
		cp -rf /usr/huawei/switchcenter/Tools/lib64/libcbbJNI.so /usr/lib64/
		chmod 755 /usr/lib64/libcbbJNI.so
		sleep 3
		
		cp -rf /usr/huawei/switchcenter/Install/preinstall_licenseload.sh /etc
		chmod 755 /etc/preinstall_licenseload.sh
		
		if [ -f /opt/docker.sig ]; then
			cp /opt/docker.sig /usr/huawei/switchcenter/Bin/
			chown ${AppUsername}:${DefUserGroup} /usr/huawei/switchcenter/Bin/docker.sig
			chmod 755 /usr/huawei/switchcenter/Bin/docker.sig
		fi
		
#		/usr/huawei/switchcenter/Bin/startCipher.sh
		/usr/huawei/switchcenter/Install/installDB.sh
	fi
	
	
	sleep 30
	
	if [ -x "/home/scapp/l42278" ]; then
		rm -rf /home/scapp/l42278
	fi
	
	mkdir -p /home/scapp/l42278
	chown -R scapp:sc /home/scapp/l42278
	chmod 755 /home/scapp/l42278
	if [ ! -f /home/scapp/.bashrc ]; then
		touch /home/scapp/.bashrc
		chown scapp:sc /home/scapp/.bashrc
		chmod 755 /home/scapp/.bashrc
	fi
	chown scapp:sc /var/crash/sc
	chmod 550 /usr/huawei/switchcenter/Bin/*.sh
	chmod 660 /usr/huawei/switchcenter/Bin/*.properties
	chmod 440 /usr/huawei/switchcenter/Bin/version
	chmod 440 /usr/huawei/switchcenter/Bin/version_B
	chmod 550 /usr/huawei/switchcenter/Install/*.sh
	chmod 550 /usr/huawei/switchcenter/Uninstall/*.sh
	chmod 550 /usr/huawei_sc/*.sh
	chmod 644 /usr/huawei_sc/sclog
	chmod 644 /usr/huawei_sc/scNginxLog
	
	sedFile /home/scapp/.bashrc "export PATH=" "export PATH=/sbin:/usr/local/bin:/usr/bin:/bin:\$PATH"    > /dev/null 2>&1
	
	#如果系统默认tcp重试次数大于6，那么改成6，必须在服务启动前，否则重启网卡可能会导致默认路由丢失
	TcpRetryTime=$(cat /proc/sys/net/ipv4/tcp_retries2)
	if [ $TcpRetryTime -gt 6 ];then
        echo `date`":change the tcp retry time to 6" >>$logfile
        echo "6" > /proc/sys/net/ipv4/tcp_retries2
		if [ ! -f /usr/huawei/switchcenter/Bin/docker.sig ]; then
			service network restart
		fi
	fi
	
	echo `date`":start install_SC" >>$logfile
	install_SC
	echo `date`":finish install_SC" >>$logfile
	
	rm -rf /usr/huawei/switchcenter/Install/create_table_index.sql
	rm -rf /usr/huawei/switchcenter/Install/init_data_linux.sql
	rm -rf /usr/huawei/switchcenter/Install/init_data_docker.sql
	rm -rf /usr/huawei/switchcenter/Update/update.sql
	rm -rf /usr/huawei/switchcenter/Update/update_docker.sql
	rm -rf /usr/huawei/switchcenter/Update_bak/update.sql
	cd $cmdPath
	
	mkdirFailoverFile
	
	#修改umask为077
	sed -i '/^umask/d' /etc/profile
	echo "umask 0077" >> /etc/profile
	
	if [ ! -f /usr/huawei/switchcenter/Bin/docker.sig ]; then
		source /etc/profile
	fi
    
	euauserSig=`grep "euauser" /etc/passwd | wc -l`
	if [ $euauserSig -gt 0 ]; then
		chage -M 9999 -W 15 euauser
	fi
	
	gaussuserSig=`grep "gaussuser" /etc/passwd | wc -l`
	if [ $gaussuserSig -gt 0 ]; then
		chage -M 9999 -W 15 gaussuser
	fi
	
	### back successful intallation flag ###
	echo `date`":finish" >>$logfile
	echo "Installation Finished"
	echo "pass" >> $localpath/preinstall_result.txt
	if [ $InstallType = "update" ]; then
		cd /usr/huawei/sc_update
		rm -rf *
	fi
	
	#修改安装日志的文件权限
	chmod 640 /usr/huawei/switchcenter/*.log > /dev/null 2>&1
	
	#安装或者升级完成修改日志权限 安全整改duw
	if [ -d "/usr/huawei/switchcenter/Update" ]; then
		chmod 640 /usr/huawei/switchcenter/Update/update.log > /dev/null 2>&1
	fi
	if [ -d "/usr/huawei/switchcenter/Update_bak" ]; then
		chmod 640 /usr/huawei/switchcenter/Update_bak/update.log > /dev/null 2>&1
	fi
	chmod 640 /var/log/tuned/tuned.log > /dev/null 2>&1
	#end
	
	#19.1root用户权限切为scapp
	if [ -f /etc/sysconfig/network-scripts/ ]; then
		chown scapp:sc /etc/sysconfig/network-scripts/routes > /dev/null 2>&1
		chown scapp:sc /etc/sysconfig/network-scripts/ifcfg-* > /dev/null 2>&1
	fi
	
	if [ -d "/usr/huawei/switchcenter/config/SSLCertification/old" ]; then
		rm -rf  /usr/huawei/switchcenter/config/SSLCertification/old
	fi
	
	if [ -d "/usr/huawei/switchcenter/config/SSLCertification/certificate_PKI_nginx" ]; then
		rm -rf  /usr/huawei/switchcenter/config/SSLCertification/certificate_PKI_nginx
	fi
	
	#DTS2020031816200 修改所有证书权限为640
	find /etc /usr -name "*.pem" | xargs chmod 640 -R > /dev/null 2>&1
	
	if [ ! -f /usr/huawei/switchcenter/Bin/docker.sig ]; then
		reboot
	else
		echo "docker_install_success.sig" >/usr/huawei/switchcenter/Bin/docker.sig
	fi

	exit 0
}

main

