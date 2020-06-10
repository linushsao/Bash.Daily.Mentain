#!/bin/bash
#

#exit 0

#CONF_FILE="${home_Dir}ProjectStock/all_stocks/.env.Configure.csv"
PATH_LOG="${home_Dir}log/"
LOG_FILE="fileMrg_daily.log"
DATE="`date +%Y%m%d_%H:%M:%S`"
PREFIX_TO_NULL=" /dev/null 2>&1"

VERBOSE="TRUE"

#
SOURCE_DIR="/home/linus/Project/9.Shared.Data/1_Taiwan/www.twse.com.tw/stock.price/1_raw.data/"
TARGET_DIR="/home/linus/Project/9.Shared.Data/1_Taiwan/www.twse.com.tw/stock.price/1_raw.data/1_toUTF8/"
ACTION="--big5-to-utf8" 
#
# sub function <<

dbg() {

	if [ "${VERBOSE}" == "TRUE" ]
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


if [ "${SOURCE_DIR=}" == "" ] || [ ${TARGET_DIR} == "" ]
	then
	
	for var in "$@"
	do
		# compare which param to be set value
		if [ "${var}" == "--source-dir" ] # VARIABLE_LEVEL=1
			then
			#PARAM_1="${var}"
			VARIABLE_LEVEL="1A"
			continue
			
			elif [ "${var}" == "--targe-dir" ] # prepare new function
			then
			#PARAM_1="${var}"
			VARIABLE_LEVEL="2A"
			continue
			
			elif [ "${var}" == "--big5-to-utf8" ] # prepare new function
			then
			ACTION="${var}"
			#VARIABLE_LEVEL="3A"
			continue

			elif [ "${var}" == "--utf8-to-big5" ] # prepare new function
			then
			ACTION="${var}"
			#VARIABLE_LEVEL="3A"
			continue
			
				#  set value to launcher application for --gen-launcher-file
				elif [ "${VARIABLE_LEVEL}" == "1A"  ] 
				then
					#GEN_LAUNCHER_FILE="${fileMGR_CONF_PATH}.Launched_Application.${var}"
					# echo ${var} > ${GEN_LAUNCHER_FILE} #generate launch file in .conf
					#msg "generated launch file for ${var} : ${GEN_LAUNCHER_FILE}"
					SOURCE_DIR="${var}"
					#VARIABLE_LEVEL="1B"
					continue
				elif [ "${VARIABLE_LEVEL}" == "2A"  ] 
					then
					TARGET_DIR="${var}"
					#msg "Completely generated ${var} script launcher for ${fileMGR_APPLICATION_REGISTER}"
					continue	
		fi
	done
fi
# precheck param <<


# main function
	
	main () {
			
		iconv_exec () { 
			# example: iconv -f big5 -t utf-8 big5.txt -o utf8.txt
			source_dir=${1}
			target_dir=${2}
			action=${3}
			dbg "1 $1 2 $2 3 $3"
				case ${action} in
					  "--big5-to-utf8")
						from="big5"
						to="utf-8"
						;;
					  "--utf8-to-big5")
						from="utf-8"
						to="big5"
						;;
				  *)   # 其實就相當於萬用字元，0~無窮多個任意字元之意！
					echo "Wrong params ${source_dir} ${target_dir} ${action}"
					exit 0
					;;
				esac

			for filename in $( ls ${source_dir})
			do
				dbg $filename 
				source_file="${source_dir}${filename}"
				target_file="${target_dir}${filename}"
				
				iconv -f ${from} -t ${to} ${source_file} -o ${target_file}
			done			
			
			#for filename in $( ls $1 )
			#do
			  #echo $filename 
			  #iconv -f big5 -t utf-8 big5.txt -o utf8.txt
			#done
		}
		
		iconv_exec ${SOURCE_DIR} ${TARGET_DIR} ${ACTION}
	}

	main

exit 0
