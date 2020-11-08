#!/usr/bin/bash

# one simple file
mine=`./du.sh test`
original=`du test`
echo -n "Test 1 "
if [[ $mine == $original ]]; then
	echo "SUCCESS"
else
	echo "FAIL"
fi

#two directories
mine=`./du.sh -a test_dir test_dir2 | sort`
original=`du -a test_dir test_dir2 | sort`
echo -n "Test 2 "
if [[ $mine == $original ]]; then
	echo "SUCCESS"
else
	echo "FAIL"
fi