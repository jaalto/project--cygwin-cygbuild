# Syntax: FROM [TO [MODE; */bin/* defaults to 755]]
# Syntax: ln DESTDIR/FROM TO
#
# Without trailing slash: rename file TO. TO expansions can use
# variables $PKG $VER $DOC. Scripts and manpages are automatically
# installed. Script suffixes *.pl etc. are stripped on install.
#
#    program usr/bin/
#    prg     usr/bin/newname
#    README  $DOC/ 644
#    man.1
#    program.pl
#    ln usr/bin/program newname  => like cd /usr/bin; ln -s program newname
