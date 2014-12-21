#! /bin/bash
#
## source system - functions
. /lib/init/vars.sh
. /lib/lsb/init-functions

# Shell Variables sourced from 
# "LAUS calling Client"/etc/default/laus-setup
. /etc/default/laus-setup
## ENABLE_AUTOUPDATE="yes"
# Server hosting all LAUS - scripts:
## LAUS_SERVER="laus01"
# Rootpath,where LAUS - directory is stored:
## PATH_ON_LAUS_SERVER="/autoinstall"
# Directory, relativ to PATH_ON_LAUS_SERVER, where laus_server.sh - script is stored:
## LAUS_PATH="laus"
# Mountpoint on client, for Serverdirectory
## MOUNT_PATH_ON_CLIENT="/opt/autoinstall"
# Path, where updatelogfiles are written to:
## UPDATE_LOG_DIR="/var/log/laus"

# Updatescripts may not be executed on LAUS-SERVER!
if [ $(hostname) = ${LAUS_SERVER} ];
then
	log_action_begin_msg "Updatescript may not run on  laus - Server!"
	echo "Updatescript may not run on  laus - Server!"
	exit 7
fi

######################################################################################
################## Helper Function ###################################################
######################################################################################

# Function for executing all Scripts in Directory
function executeScripts {
	hc=$1
	if [ -z ${hc} ];
	then
		CLASSPATH="ALLCLASSES";
	else
		CLASSPATH="ALLCLASSES."${hc//\//.};
	fi

	fileList=$(ls)
	for file in ${fileList}; 
	do
		# test, if file is executable and does not end with ~
		if [ -f ${file} -a -x ${file} -a ${file} = ${file%"~"} ];
		then
			# test, if script has already been executed on this workstation
			if [ -f ${UPDATE_LOG_DIR}"/"${CLASSPATH}"."${file} ]
			then
				log_action_begin_msg "already executed --> "${CLASSPATH}"."${file}
				#echo "already executed --> "${CLASSPATH}"."${file}
			else
				log_action_begin_msg "running LAUS script --> "${CLASSPATH}"."${file}
				#echo "running LAUS script --> "${CLASSPATH}"."${file}
				"./"${file} ${startParameter}
				# if script has been executed, log it"
				if [ $? -eq 0 ];
				then
					cp ${file} ${UPDATE_LOG_DIR}"/"${CLASSPATH}"."${file}
				fi
			fi
		fi
	done
}


######################################################################################
################## S T A R T   O F   S C R I P T #####################################
######################################################################################

# set HOSTCLASS Variable from File hostsToClasses
# check like tftp:
# for hostname r001pc12
# test following Strings:
# #1: r001pc12
# #2: r001pc1
# #3. r001pc
# ...
# #8: r
#
# and collect all information in:
# HOSTCLASS, SUBHOSTCLASS and SUBSUBHOSTCLASS
#
# see: HOSTCLASS=${HOSTCLASS}" "$(grep ^${TESTSTRING}";" hostsToClasses | awk 'BEGIN { FS = ";" } { print $2 }')
# and so on!
#
# hostsToClasses in format:
# HOSTNAME;HOSTCLASS;SUBHOSTCLASS;SUSUBHOSTCLASS
# r001pc50;TEACHER BEAMER;BEAMER_1024x768
# r001;R001
# => HOSTCLASS for PC with hostname r001pc50: TEACHER BEAMER R001
#    and SUBHOSTCLASS=BEAMER_1024x768
#
TESTSTRING=$(hostname)
for ((length=${#TESTSTRING};  length > 0; length--)) 
do
	TESTSTRING=${TESTSTRING:0:length}
	HOSTCLASSES=${HOSTCLASSES}" "$(grep ^${TESTSTRING}":" hostsToClasses | awk 'BEGIN { FS = ":" } { print $2 }')
done

# souround List of hosts with () to cast to array
HOSTCLASSES=(${HOSTCLASSES})

echo ${HOSTCLASSES[@]}
log_action_begin_msg "LAUS START --------------------------------------"

#### Startparameter mitteilen z.B: start, stop, cron
startParameter=$1

# run scripts for all hosts
cd scriptsForClasses
executeScripts

# run scripts for classes

for hostclass in ${HOSTCLASSES[@]}; do
	if test -d ${hostclass}; 
	then
		CURRENTRIR=$(pwd)
		cd ${hostclass};
		executeScripts ${hostclass};
		cd ${CURRENTRIR};
	fi;
done

log_action_begin_msg "LAUS STOP ---------------------------------------"



