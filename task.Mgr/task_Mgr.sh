#!/bin/bash
#

#exit 0

# configure <<
home_Dir="/home/linus/"
taskMGR_PATH="${home_Dir}.taskMgr/"
taskMgr_CONF_PATH="${taskMGR_PATH}.config/" 
taskMGR_APPLICATION_REGISTER="${taskMgr_CONF_PATH}taskMGR_List.txt"
taskMGR_PENDING_KeepALIVE_PATH="${taskMGR_PATH}pendingJOB/Keep.Alive/"
taskMGR_PENDING_OneTIME_PATH="${taskMGR_PATH}pendingJOB/One-time/"
taskMGR_LIST="taskMGR.txt"

CONF_FILE="${home_Dir}ProjectStock/all_stocks/.env.Configure.csv"
PATH_LOG="${home_Dir}log/"
LOG_FILE="daily.log"
DATE="`date +%Y%m%d_%H:%M:%S`"
PREFIX_TO_NULL=" /dev/null 2>&1"

VERBOSE="TRUE"
DEBUG="FALSE"

# extra check
EXTRA_CHECK="/home/linus/Project/0_Comprehensive.Research/.ignore.stock.file.csv"

# configure <<


# sub function <<

dbg() {

	if [ "$DEBUG" == "TRUE" ]
	then
		echo $1
	fi
}

msg() {
	echo "${DATE} $1"
	logger "${DATE} $1"
}

logger() {
	echo $1 >> ${PATH_LOG}${LOG_FILE}
}

msg " "
msg "-----------------Param Info-----------------"

#Function <<
job_list () { #searching for pending job
	LIST_PATH=${2} #list waiting for launch
	#clear list at first
	echo "" > ${LIST_PATH} #reset list
	for filename in $( ls $1 )
	do
	  echo $filename >> ${LIST_PATH}
	done
}

exec_script () {
	if [ "${VERBOSE}" != "TRUE" ]
		then
		PREFIX_TO_NULL=""
	fi
	ENGAGE="${1} ${2}"
	msg "Prepare script :${2}"
	msg "Launcher Application :${1}"
	msg "Engage Cmd :${ENGAGE} "
	if [ "${DEBUG}" == "TRUE" ]; then
		msg "Launch Mod :Rscript Launch Simulation, Not Really Run Target Script ."

		else
		#Rscript ${1}
		${ENGAGE} 
		
	fi
}

get_launcher_application () {
	
	REGISTED_LIST=( ` cat ${taskMGR_APPLICATION_REGISTER} ` )
	FILE_NAME="${TARGET_DIR}${1}"

	for ((i=0; i<${#REGISTED_LIST[@]}; i++))
		do 
		RELATED_LIST=` cat ${taskMgr_CONF_PATH}.Launched_Application.${REGISTED_LIST[i]}` 
		for ((ii=0; ii<${#RELATED_LIST[@]}; ii++))
			do
				CHECK=`cat "${FILE_NAME}" | grep "${RELATED_LIST[$ii]}" ` #$1 is script name
				if [  "${CHECK}" != "" ]
					then	
					echo ${REGISTED_LIST[i]} #retuen launcher application
				fi
			done
		done
}

exec_Lists () {
		
	for ((i=0; i<${#R_SCRIPT[@]}; i++))
	do 
		if [  ${R_SCRIPT[$i]} != "" ]
			then
			#CHECK=`cat ${CONF_FILE} | grep ${MARK_SIGNAL[$i]}`
			#CHECK=`echo "${CHECK:18:30}" | sed -r 's/["]+//g'`
			LAUNCHE_SCRIPT="${TARGET_DIR}${R_SCRIPT[$i]}"	
			Launched_Application=`get_launcher_application ${R_SCRIPT[$i]}` 
			MARK_CHECK=` cat ${taskMgr_CONF_PATH}.Application_MARK.${Launched_Application} ` 
			CHECK_PID=` ps -aux | grep ${R_SCRIPT[$i]} | grep ${MARK_CHECK}  `
			EXTRA_CHECK_FLAG=` tail -n 1 ${EXTRA_CHECK} `
			if [ "${VERBOSE}" == "TRUE" ]; then
				msg " "
				msg "-----------------Debug Info-----------------"
				#msg "taskMgr BringUp Cmd: ${PARAM_1} ${PARAM_2} ${PARAM_3}"
				msg "DEBUG MODE: ${DEBUG}"
				msg "VERBOSE MODE: ${VERBOSE}"
				msg "CHECK_PID: ${CHECK_PID:6:12}"
				msg "LOG FILE: ${PATH_LOG}${LOG_FILE}"
				msg "LAUNCHE_SCRIPT: ${LAUNCHE_SCRIPT}" 
				msg "EXTRA_CHECK_FLAG : ${EXTRA_CHECK_FLAG}"
				msg "--------------------------------------------------"
				
			fi

			if [ "${CHECK_PID}" == ""  ] # Relaunch process
				then
					msg "Result :Rscript was crash."
					msg "Relaunch process : ${LAUNCHE_SCRIPT}"
					LAUNCHER=`get_launcher_application ${R_SCRIPT[$i]}`
					exec_script  ${LAUNCHER} ${LAUNCHE_SCRIPT}

				else #unnecessary to relaunch.
					msg "Result :${R_SCRIPT[$i]} is processing ..."
					
			fi
		fi

	done

}

# sub function <<


# precheck param <<

menu () {
	
	echo "--gen-launcher-file    <launch application> < file.extension>  : generate launche file data"
	echo "--regist-launcher      <launch application>                    : regist launche application data"
	echo "--regist-launcher-mark <launch application> <application mark> : regist pplication mark data"	
}

VARIABLE_LEVEL="FALSE" #level of param

for var in "$@"
do
    # compare which param to be set value
	if [ "${var}" == "--gen-launcher-file" ] # VARIABLE_LEVEL=1
		then
		PARAM_1="${var}"
		VARIABLE_LEVEL="1A"
		continue
		
		elif [ "${var}" == "--regist-launcher" ] # prepare new function
		then
		PARAM_1="${var}"
		VARIABLE_LEVEL="2A"
		continue
		
		elif [ "${var}" == "--regist-launcher-mark" ] # prepare new function
		then
		PARAM_1="${var}"
		VARIABLE_LEVEL="3A"
		continue
		
			#  set value to launcher application for --gen-launcher-file
			elif [ "${VARIABLE_LEVEL}" == "1A"  ] 
			then
				GEN_LAUNCHER_FILE="${taskMgr_CONF_PATH}.Launched_Application.${var}"
				# echo ${var} > ${GEN_LAUNCHER_FILE} #generate launch file in .conf
				#msg "generated launch file for ${var} : ${GEN_LAUNCHER_FILE}"
				PARAM_2="${var}"
				VARIABLE_LEVEL="1B"
				continue
			#  set file extension value for launcher application for --gen-launcher-file
			elif [ "${VARIABLE_LEVEL}" == "1B"  ] 
				then
				#Launched_Application=${var} #setup which tools to launch from Bash script.
				echo ${var} > ${GEN_LAUNCHER_FILE} #setup launch file
				msg "Completely generated ${var} script launcher for ${GEN_LAUNCHER_FILE}"
				PARAM_3="${var}"
				exit 0
			elif [ "${VARIABLE_LEVEL}" == "2A"  ] 
				then
				echo ${var} > ${taskMGR_APPLICATION_REGISTER} #setup launched application list
				msg "Completely generated ${var} script launcher for ${taskMGR_APPLICATION_REGISTER}"
				exit 0		
			#  set value to launcher application for --gen-launcher-file
			elif [ "${VARIABLE_LEVEL}" == "3A"  ] 
			then
				GEN_LAUNCHER_FILE="${taskMgr_CONF_PATH}.Application_MARK.${var}"
				# echo ${var} > ${GEN_LAUNCHER_FILE} #generate launch file in .conf
				#msg "generated launch file for ${var} : ${GEN_LAUNCHER_FILE}"
				PARAM_2="${var}"
				VARIABLE_LEVEL="3B"
				continue
			elif [ "${VARIABLE_LEVEL}" == "3B"  ] 
				then
				echo ${var} > ${GEN_LAUNCHER_FILE} #setup launch file
				msg "Completely registed ${var} launcher mark for ${GEN_LAUNCHER_FILE}"
				PARAM_3="${var}"
				exit 0
		elif [ "${var}" == "--help" ] # prepare new function
		then
			menu
			exit 0			
		else
		menu
		exit 0

	fi
done

# precheck param <<


# main function

while  :
do

	main () {
		
		CURRENT_LIST=${taskMGR_PATH}${taskMGR_LIST} #list waiting for launch

		# script One-time.
		TARGET_DIR=${taskMGR_PENDING_OneTIME_PATH} 
		job_list ${TARGET_DIR} ${CURRENT_LIST} #gen CURRENT_LISt
		R_SCRIPT=( ` cat ${CURRENT_LIST} ` )
		for ((i=0; i<${#R_SCRIPT[@]}; i++))
		do 
			if [ ${R_SCRIPT[$i]} != "" ]
				then
				exec_Lists 
			fi
			echo '' >  ${CURRENT_LIST}
		done
			
		# script Keep.Alive.
		TARGET_DIR=${taskMGR_PENDING_KeepALIVE_PATH}
		job_list ${TARGET_DIR} ${CURRENT_LIST} #gen CURRENT_LISt
		R_SCRIPT=( ` cat ${CURRENT_LIST} ` )
		for ((i=0; i<${#R_SCRIPT[@]}; i++))
		do 
			if [ ${R_SCRIPT[$i]} != "" ]
				then
				exec_Lists 
			fi
		done

	}

	main
	
	sleep 3
	
done

exit 0
