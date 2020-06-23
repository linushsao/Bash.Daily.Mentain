#!/bin/bash
#

#exit 0

#CONF_FILE="${home_Dir}ProjectStock/all_stocks/.env.Configure.csv"
PATH_FROM="$1"
PATH_TO="$2"

VERBOSE="TRUE"

#
msg() {
	echo "${DATE} $1"
	#logger "${DATE} $1"
}

file_transfer () { #searching for pending job

	for filename in $( ls ${PATH_FROM} )
	do
		#echo $filename
		FILE_BIG5=${PATH_FROM}${filename}
		FILE_UTF8=${PATH_TO}${filename}
		iconv -f BIG-5 -t UTF-8 ${FILE_BIG5} > ${FILE_UTF8}
		msg "[FINISH] ${FILE_UTF8}"
	done
}

	# main function
	
	main () {

		file_transfer

	}

	main

exit 0
