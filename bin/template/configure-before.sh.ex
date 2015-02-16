#!/bin/sh
# Copyright (C) YYYY Firstname Lastname; Licensed under GPL v2 or later
#
# configure-before.sh -- Custom configure script
#
#   Called as: CYGWIN-PATCHES/configure-before.sh <absolute-install-dir>

PATH="/sbin:/usr/sbin/:/bin:/usr/bin"
LC_ALL="C"

# If sources are old, before ./configure, you may need to call:
# autoreconf --install --force --verbose
#
# Or this is more lightweight. Probably "autoreconf" is safer choice.
# libtoolize --force --copy --install

# End of file
