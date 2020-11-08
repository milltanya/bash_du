#!/usr/bin/bash

delimiter="\n"
all=false
files=()

for p in $@; do
	if [[ "$p" == "-0" || "$p" == "--null" ]]; then
		delimiter="\0"

	elif [[ "$p" == "-a" || "$p" == "--all" ]]; then
		all=true

	elif [[ -e "$p" ]]; then
		files+=("$p")

	else
		echo -e "Illegal option \"$p\"" > /dev/stderr
		exit 1
	fi
done

if [[ ${#files[@]} -eq 0 ]]; then
	files=(".")
fi

get_file_info() {

	local size=`ls -s $1 | awk '{print $1}'`

	echo -n "$size|"
	echo -n "$size\t$1$delimiter"
}

get_directory_info() {

	local list_files=(`ls $1`)
	local size=4
	local output=""

	for f in ${list_files[@]}; do

		if [[ -f $1/$f ]]; then
			local result=`get_file_info $1/$f`
			size=$(($size + `echo "$result" | awk -F "|" '{print $1}'`))
			if $all; then
				output="$output`echo "$result" | awk -F "|" '{print $2}'`"
			fi

		elif [[ -d $1/$f ]]; then
			local result=`get_directory_info $1/$f`
			size=$(($size + `echo "$result" | awk -F "|" '{print $1}'`))
			output="$output`echo "$result" | awk -F "|" '{print $2}'`"

		else
			echo "Unknown type of file $1/$f" > /dev/stderr
		fi
	done

	echo -n "$size|"
	echo -n "$output$size\t$1$delimiter"
}

for f in ${files[@]}; do

	if [[ -f $f ]]; then
		result=`get_file_info $f`
		output=`echo "$result" | awk -F "|" '{print $2}'`

	elif [[ -d $f ]]; then
		result=`get_directory_info $f`
		output=`echo "$result" | awk -F "|" '{print $2}'`

	else
		echo "Unknown type of file $f" > /dev/stderr
	fi

	echo -ne "$output"

done



