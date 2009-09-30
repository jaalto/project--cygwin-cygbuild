#!/bin/sh
# Copyright (C) YYYY Firstname Lastname; Licensed under GPL v2 or later
#
# patch-after.sh -- Program for 'patch' command
#
# The script will receive one argument: relative path to
# installation root directory. Script is called like:
#
#    $ patch-after.sh .inst
#
# This script is run after [patch] command. NOTE: Echo all messages
# with ">> " prefix".

PATH="/sbin:/usr/sbin/:/bin:/usr/bin:/usr/X11R6/bin"
LC_ALL="C"

Cmd()
{
    echo "$@"
    [ "$test" ] && return
    "$@"
}

Main()
{
    root=${1:-".inst"}

    if [ ! "$root"  ] || [ ! -d "$root" ]; then
        echo "$0: [ERROR] In $(pwd) no such directory: '$root'" >&2
        return 1
    fi

    root=$(echo $root | sed 's,/$,,')  # Delete trailing slash

    # echo ">> Doing something"
    # Cmd echo >> $root/some-file
}

Main "$@"

# End of file
