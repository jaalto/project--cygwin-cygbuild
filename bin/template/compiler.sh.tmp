#!/bin/sh
#
# Note: Libotool does not understand "--mode=compile ccache gcc", because it
# expects one WORD. The workaround is to use separate command file.

bin=/usr/bin/ccache
cc=gcc

if [ -x $bin ]; then
    $bin $cc "$@"
else
    $cc "$@"
fi

# End of file
