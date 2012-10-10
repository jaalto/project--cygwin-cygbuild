# Basic syntax: FROM [TO [MODE]]
#
# Without trailing slash: rename file TO. You can use: $PKG $VER $DOC
# Scripts and manpages are automatically installed; no TO is needed:
# Script suffixes *.pl etc. are stripped on install. Creaete symbolic
# links with "ln" command or directories with "mkdir". See below:
#
#    program usr/bin/
#    program usr/bin/newname
#    ln usr/bin/program aliasname
#    mkdir var/log/program
#    README  $DOC/ 644
#    man.1
#    program.pl

