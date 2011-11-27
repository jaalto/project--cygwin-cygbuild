#!/bin/sh
#
# This file is not used for anything.
#
# This contains snippets of code that can be copy/pasted
# to installation etc. scripts.

PATH="/sbin:/usr/sbin/:/bin:/usr/bin:/usr/X11R6/bin"
LC_ALL="C"

package="packagename"        #!! CHANGE THIS

Environment()
{
    #  Define variables for the rest of the script

    [ "$1" ] && dest="$1"        # install destination

    if [ "$dest" ]; then
        #  Delete trailing slash
        dest=$(echo $dest | sed -e 's,/$,,' )
    fi

    #   This file will be installed as
    #   /etc/postinstall/<package>.sh so derive <package>
    #   But if this file is run from CYGIN-PATCHES/postinstall.sh
    #   then we do not know the package name

    name=$(echo $0 | sed -e 's,.*/,,' -e 's,\.sh,,' )

    if [ "$name" != "postinstall" ]; then
        package="$name"
    fi

    bindir="$dest/usr/bin"
    libdir="$dest/usr/lib"
    libdirx11="$dest/usr/lib/X11"
    includedir="$dest/usr/include"

    sharedir="$dest/usr/share"
    infodir="$sharedir/info"
    docdir="$sharedir/doc"
    etcdir="$dest/etc"

    #   1) list of files to be copied to /etc
    #   2) Source locations

    defaultsdir=$dest/etc/defaults/etc/$package
    manifestdir=$etcdir/postinstall
    conffile="$manifestdir/$package-manifest.lst"
}

Warn ()
{
    echo "$*" >&2
}

Run ()
{
    echo "$@"
    [ "$test" ] || "$@"
}

# End of file
