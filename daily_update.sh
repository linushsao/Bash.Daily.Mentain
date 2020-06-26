#!/bin/bash
#

#exit 0
home_Dir="/home/linus/"

PATH_LOG="${home_Dir}log/"
LOG_FILE="daily.log"
DATE="`date +%Y%m%d_%H:%M:%S`"
PREFIX_TO_NULL=" /dev/null 2>&1"
LOGGER="/home/linus/script/my_log.sh"

PATH_DAILY_UPDATE="/home/linus/.taskMgr/pendingJOB/Keep.Alive/"
PATH_DAILY_ONCE_UPDATE="/home/linus/.taskMgr/pendingJOB/One-time/"
PATH_TRIGGER="/home/linus/Project/0_Comprehensive.Research/"
PATH_DAILY_UPDATE_SCRIPT="/home/linus/Project/1_R/Analysis.of.trading.strategies/TollKit/0_Data.tools/2_yahoo/"
PATH_DAILY_ANALYZE_SCRIPT="/home/linus/Project/0_Comprehensive.Research/01_trading.straregy/"

RM_LIST=(
.ignore.etf.file.csv
.ignore.index.file.csv
.ignore.stock.file.csv
)

DAILY_UPDATE_LIST=(

)

DAILY_UPDATE_KEEPALIVE_LIST=(
web_crawler_stock.yahoo.R
web_crawler.date.twse.R
web_crawler_etf.yahoo.R
web_crawler_index.yahoo.R
)

DAILY_ANALYZE_ONCE_LIST=(
generator.of.analyzedData.R
)

DAILY_ANALYZE_LIST=(
Daily.update.R
)


main () {
	
    if [ "$1" == "--enable-daily-update" ]
		then
		
		for ((i=0; i<${#RM_LIST[@]}; i++)) #rm trigger files
			do 
			FILE_NAME=${PATH_TRIGGER}${RM_LIST[i]} 
			#echo $CHECK
				#if [ -f "$FILE_NAME" ]; then
					rm ${FILE_NAME}
				#fi
			done

		for ((i=0; i<${#DAILY_UPDATE_LIST[@]}; i++))
			do 
			FILE_NAME=${PATH_DAILY_UPDATE_SCRIPT}${DAILY_UPDATE_LIST[i]} 
			#echo $CHECK
				#if [ ! -f "$FILE_NAME" ]; then
					ln -s ${FILE_NAME} ${PATH_DAILY_ONCE_UPDATE}
				#fi
			done
			
		for ((i=0; i<${#DAILY_UPDATE_KEEPALIVE_LIST[@]}; i++))
			do 
			FILE_NAME=${PATH_DAILY_UPDATE_SCRIPT}${DAILY_UPDATE_KEEPALIVE_LIST[i]} 
			#echo $CHECK
				#if [ ! -f "$FILE_NAME" ]; then
					ln -s ${FILE_NAME} ${PATH_DAILY_UPDATE}
				#fi
			done
			
		MSG="ENABLE: Investing data update."	
		${LOGGER} "${DATE} ${MSG}"
			
	   elif [ "$1" == "--enable-daily-analyze" ]
			then
			for ((i=0; i<${#DAILY_ANALYZE_LIST[@]}; i++))
				do 
				FILE_NAME=${PATH_DAILY_ANALYZE_SCRIPT}${DAILY_ANALYZE_LIST[i]} 
				#echo $CHECK
				ln -s ${FILE_NAME} ${PATH_DAILY_UPDATE}
				done
			for ((i=0; i<${#DAILY_ANALYZE_ONCE_LIST[@]}; i++))
				do 
				FILE_NAME=${PATH_DAILY_ANALYZE_SCRIPT}${DAILY_ANALYZE_ONCE_LIST[i]} 
				#echo $CHECK
				ln -s ${FILE_NAME} ${PATH_DAILY_UPDATE}
				done	
				
			MSG="ENABLE: Investing data analyze."	
			${LOGGER} "${DATE} ${MSG}"
			
	   elif [ "$1" == "--disable-daily-update" ]
			then
			
			for ((i=0; i<${#DAILY_UPDATE_LIST[@]}; i++))
				do 
				FILE_NAME=${PATH_DAILY_UPDATE}${DAILY_UPDATE_LIST[i]} 
				#echo $CHECK
				rm ${FILE_NAME}
				done
				
			for ((i=0; i<${#DAILY_UPDATE_KEEPALIVE_LIST[@]}; i++))
				do 
				FILE_NAME=${PATH_DAILY_UPDATE}${DAILY_UPDATE_KEEPALIVE_LIST[i]} 
				#echo $CHECK
				rm ${FILE_NAME}
				done
				
			MSG="DISABLE: Investing data update."	
			${LOGGER} "${DATE} ${MSG}"
			
	   elif [ "$1" == "--disable-daily-analyze" ]
			then
			for ((i=0; i<${#DAILY_ANALYZE_LIST[@]}; i++))
				do 
				FILE_NAME=${PATH_DAILY_ANALYZE_SCRIPT}${DAILY_ANALYZE_LIST[i]} 
				#echo $CHECK
				rm ${FILE_NAME}
				done
			for ((i=0; i<${#DAILY_ANALYZE_ONCE_LIST[@]}; i++))
				do 
				FILE_NAME=${PATH_DAILY_ANALYZE_SCRIPT}${DAILY_ANALYZE_ONCE_LIST[i]} 
				#echo $CHECK
				rm ${FILE_NAME}
				done
				
			MSG="DISABLE: Investing data analyze."	
			${LOGGER} "${DATE} ${MSG}"
		else
		
			echo "--enable-daily-update"	
			echo "--enable-daily-analyze"
			echo "--disable-daily-update"	
			echo "--disable-daily-analyze"	
	fi
}

main "$1"

exit 0

