#!/bin/bash
#

DAILY_RSYNC=(
/home/linus/Project/9.Shared.Data/ 
/home/linus/Project/0_Comprehensive.Research/03_Remixed.data/
)

home_Dir="/home/linus"

for ((i=0; i<${#DAILY_RSYNC[@]}; i++)) 
	do 
	${home_Dir}/script/daily_rsync.sh ${DAILY_RSYNC[i]} 
	done
 

