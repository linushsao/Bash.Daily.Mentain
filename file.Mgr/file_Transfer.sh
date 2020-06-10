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
SOURCE_DIR="/home/linus/Project/9.Shared.Data/1_Taiwan/www.twse.com.tw/stock.price/1_raw.data/1_toUTF8/"
PREVIEW_PROCESSING_DIR="/home/linus/Project/9.Shared.Data/1_Taiwan/www.twse.com.tw/stock.price/1_raw.data/2_PrePRocessing/"
TARGET_DIR="/home/linus/Project/9.Shared.Data/1_Taiwan/www.twse.com.tw/stock.price/1_raw.data/3_processedDATA/"

ACTION="" 
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
	#logger "${DATE} $1"
}

logger() {
	echo $1 >> ${PATH_LOG}${LOG_FILE}
}

file_transfer () { #searching for pending job

	from_PATH=${1} #list waiting for trassfer
	to_PATH=${2}
	HEADER=${3}
	#clear list at first
	for filename in $( ls ${from_PATH} )
	do
		#echo $filename >> ${LIST_PATH}
		echo "${HEADER}" > "${to_PATH}${filename}"
		cat "${from_PATH}${filename}" >> "${to_PATH}${filename}"
		msg "Finished Transfter ${to_PATH}${filename}"
	done
}

	# main function
	
	main () {

		PREFIX_HEADER="1,2,3,4,5,6,7,8,9,0,11,12,13,14,15,16"
		
		file_transfer ${SOURCE_DIR} ${PREVIEW_PROCESSING_DIR} ${PREFIX_HEADER}
		
		msg "Transfer Finished"

	}

	main

exit 0
