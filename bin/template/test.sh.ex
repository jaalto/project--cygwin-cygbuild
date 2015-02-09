#!/bin/sh
# Test basic functionality

set -e

proram=$0
TMPDIR=${TMPDIR:-/tmp}
BASE=tmp.$$
TMPBASE=${TMPDIR%/}/$BASE

case "$0" in
  */*)
        CURDIR=$(cd "${0%/*}" && pwd)
        ;;
    *)  CURDIR=$(pwd)
esac

AtExit ()
{
    rm -f "$TMPBASE"*
}

Run ()
{
    if [ ! "$1" ]; then   # Run '' CMD...
        shift             # Empty message, just command to run
        echo "$*"
    else
        echo "$*"
        shift
    fi

    eval "$@"
}

trap AtExit 0 1 2 3 15

# #######################################################################

file="$CURDIR/example.dat"

Run "%% TEST <case>:" echo $file

# End of file
