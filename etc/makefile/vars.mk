#!/usr/bin/make -f
# $Id: vars.mk,v 1.19 2006/02/22 22:07:13 jaalto Exp $
#
#       Copyright (C)  Jari Aalto
#       Keywords:      Makefile, cygbuild, Cygwin
#
#       This program is free software; you can redistribute it and/or
#       modify it under the terms of the GNU General Public License as
#       published by the Free Software Foundation; either version 2 of the
#       License, or (at your option) any later version

# ########################################################### &basic ###

DESTDIR =
prefix          = /usr
exec_prefix     = $(prefix)

BINDIR          = $(DESTDIR)$(exec_prefix)/bin
MANDIR          = $(DESTDIR)$(prefix)/share/man/man1
ETCDIR          = $(DESTDIR)/etc/$(PACKAGE)
SHAREDIR        = $(DESTDIR)$(prefix)/share/$(PACKAGE)

DOCDIR          = ./doc
TMPDIR          = /tmp

INSTALL         = /usr/bin/install
INSTALL_BIN     = $(INSTALL) -m 755
INSTALL_DATA    = $(INSTALL) -m 644

BASENAME        = basename
DIRNAME         = dirname
PERL            = perl               # location varies
AWK             = awk
BASH            = /bin/bash
SHELL           = /bin/sh
MAKEFILE        = Makefile
FTP             = ncftpput

TAR             = tar
TAR_OPT_NO      = --exclude='.build'     \
                  --exclude='.sinst'     \
                  --exclude='.inst'      \
                  --exclude='tmp'        \
                  --exclude='*.bak'      \
                  --exclude='*.log'      \
                  --exclude='*[~\#]'     \
                  --exclude='.\#*'       \
                  --exclude='CVS'        \
                  --exclude='RCS'        \
                  --exclude='.git'       \
                  --exclude='.bzr'       \
                  --exclude='.hg'        \
                  --exclude='*.tar*'     \
                  --exclude='*.tgz'      \

TAR_OPT_COPY    = $(TAR_OPT_NO)
TAR_OPT_WORLD   = $(TAR_OPT_NO)


#   RELEASE must be increased if Cygwin corrections are make to same package
#   at the same day.

RELEASE = 1
VERSION = `date '+%Y%m%d'`

BUILDDIR        = .build
SINSTDIR        = .sinst
PACKAGEVER      = $(PACKAGE)-$(VERSION)
RELEASEDIR      = $(BUILDDIR)/$(PACKAGEVER)
RELEASE_FILE    = $(PACKAGEVER).tar.gz
RELEASE_FILE_PATH = $(RELEASEDIR)/$(SINSTDIR)

CYGWIN_RELEASE_FILE      = $(PACKAGEVER)-$(RELEASE).tar.bz2
CYGWIN_RELEASE_FILE_PATH = $(RELEASE_FILE_PATH)/$(CYGWIN_RELEASE_FILE)

TAR_FILE_WORLD_LS  = \
  `ls -t1 $(RELEASE_FILE_PATH)/*.tar.gz | sort -r | head -1`

# ########################################################### &files ###


# Rule: echo-vars - [maintenance] Echo important variables
echo-vars:
        @echo DESTDIR=$(DESTDIR) prefix=$(prefix) exec_prefix=$(exec_prefix)
        @echo BINDIR=$(BINDIR) MANDIR=$(MANDIR) DOCDIR=$(DOCDIR)

# End of file