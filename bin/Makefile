#
#   Copyright information
#
#	Copyright (C) 2003-2009 Jari Aalto
#
#   License
#
#	This program is free software; you can redistribute it and/or
#	modify it under the terms of the GNU General Public License as
#	published by the Free Software Foundation; either version 2 of the
#	License, or (at your option) any later version
#
#	This program is distributed in the hope that it will be useful, but
#	WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#	General Public License for more details at
#	Visit <http://www.gnu.org/copyleft/gpl.html>.
#
#   Description
#
#	 Rules for maintenance

ifneq (,)
    This makefile requires GNU Make.
endif

include ../mk/common.mk

PL		   = lib/cygbuild.pl
INSTALL_OBJS_BIN   = $(PACKAGE)
INSTALL_OBJS_MAN1  = *.1 lib/*.1
INSTALL_OBJS_LIB   = $(PL) lib/*.sh
INSTALL_OBJS_ETC   = etc/*

INSTALL		= /usr/bin/install
INSTALL_BIN	= $(INSTALL) -m 755
INSTALL_DATA	= $(INSTALL) -m 644
INSTALL_SUID	= $(INSTALL) -m 4755

all: man

cygbuild-rebuild.1: cygbuild-rebuild.pod
	pod2text $? > $@

lib/dyndns.1: $(PL)
	perl $? --Help-man > $@

# Rule: man: generate manual page
man: cygbuild-rebuild.1

clean:
	# clean
	-rm -f *.tmp *.\#* *[#~] */*[#~]

distclean: clean

realclean: clean

install-etc:
	# install-etc
	$(INSTALL_BIN) -d $(ETCDIR)
	$(INSTALL_BIN)	  $(INSTALL_OBJS_ETC) $(ETCDIR)

install-man:
	# install-man
	$(INSTALL_BIN) -d $(MANDIR1)
	$(INSTALL_DATA)	  $(INSTALL_OBJS_MAN1) $(MANDIR1)

install-bin:
	# install-bin
	$(INSTALL_BIN) -d $(BINDIR)
	$(INSTALL_BIN)	  $(INSTALL_OBJS_BIN) $(BINDIR)

install-lib:
	# install-lib
	$(INSTALL_BIN) -d $(SHAREDIR)
	$(INSTALL_BIN)	  $(INSTALL_OBJS_LIB) $(SHAREDIR)

install: all install-bin install-lib install-man install-etc

.PHONY: clean distclean realclean install install-bin install-man

# End of file
