#!/bin/bash
#
# Rename Debian diff files to *.patch
#
# 1. Copy debian patches here
# 2. Run this file

while read file
do
    if [ "$file" ] && [ -f $file ]; then
	name=${file%.diff}
	${test+echo} mv -v $file $name.patch
    fi
done < series

# End of file
