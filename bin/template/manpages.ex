# Syntax: FROM [MANSECT [TO]]
#
# Install *upstream* manual pages to usr/share/man$MANSECT/$TO
# If MANSECT is specified, any file name suffix in FROM is replaced
# with it.
#
#  man/*.1
#  man/page.man 1
#  man/page.man 1 newname.1
