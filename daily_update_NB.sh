#!/bin/bash
#

DAILY_RSYNC=(
/home/linus/Project/9.Shared.Data/1_Taiwan/finance.yahoo.com/
/home/linus/Project/9.Shared.Data/1_Taiwan/www.twse.com.tw/foreign.investment.Sales.Summary/1_raw.file/
/home/linus/Project/9.Shared.Data/1_Taiwan/www.twse.com.tw/Margin.Trading_Short.Selling/1_raw.file/
/home/linus/Project/0_Comprehensive.Research/03_Remixed.data/
)

DAILY_TRANS_CODE=(
/home/linus/Project/9.Shared.Data/1_Taiwan/www.twse.com.tw/foreign.investment.Sales.Summary/1_raw.file/ 
/home/linus/Project/9.Shared.Data/1_Taiwan/www.twse.com.tw/foreign.investment.Sales.Summary/2_toUTF8/
/home/linus/Project/9.Shared.Data/1_Taiwan/www.twse.com.tw/Investment.profit_related/1_raw.file/
/home/linus/Project/9.Shared.Data/1_Taiwan/www.twse.com.tw/Investment.profit_related/2_toUTF8/
/home/linus/Project/9.Shared.Data/1_Taiwan/www.twse.com.tw/Margin.Trading_Short.Selling/1_raw.file/
/home/linus/Project/9.Shared.Data/1_Taiwan/www.twse.com.tw/Margin.Trading_Short.Selling/2_toUTF8/
)

home_Dir="/home/linus"

#sync raw file from remote
for ((i=0; i<${#DAILY_RSYNC[@]}; i++)) 
	do 
		${home_Dir}/Project/4_Bash/daily_rsync.sh ${DAILY_RSYNC[i]} 
	done
 
#trans to UTF8 if necessary, local
for ((i=0; i<${#DAILY_TRANS_CODE[@]}; i=i+2)) 

	do 
		id_from=i
		id_to=i+1
		/home/linus/Project/4_Bash/file.Mgr/file_BIG5toUTF8.sh ${DAILY_TRANS_CODE[id_from]} ${DAILY_TRANS_CODE[id_to]}
		#echo ${DAILY_TRANS_CODE[id_from]} 
		#echo ${DAILY_TRANS_CODE[id_to]}
	done
 
