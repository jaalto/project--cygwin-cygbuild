#!/bin/sh
# Extract Debian patches

NAME=quilt
VER=_0.[0-9]*-[0-9]
ext=.diff

Main ()
{
    file=$(ls $NAME$VER$ext | tail -n 1)

    [ "$file" ] || return 1

    ver=$(echo $file | sed -e "s,$NAME[_-],," -e "s,$ext,,")

    [ "$ver" ] || return 2

    filterdiff -i "*/patches/*" $file > $NAME-$ver-debian-patches.patch
}

Main "$@"

# End of file
