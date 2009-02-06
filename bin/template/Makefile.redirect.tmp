#!/usr/bin/make -f
#
#	Copyright (C) 2003-2009 Jari Aalto
#	Copyright (C) YYYY Firstname Lastname
#
#	This program is free software; you can redistribute it and/or
#	modify it under the terms of the GNU General Public License as
#	published by the Free Software Foundation; either version 2 of the
#	License, or (at your option) any later version
#
#	This program is distributed in the hope that it will be useful, but
#	WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#	General Public License for more details.
#
#	Visit <http://www.gnu.org/copyleft/gpl.html>

ifneq (,)
This makefile requires GNU Make.
endif

DESTDIR		=
prefix		= /usr
exec_prefix	= $(prefix)
man_prefix	= $(prefix)/share

PACKAGE		= lv
INSTALL		= /usr/bin/install
INSTALL_BIN	= $(INSTALL) -m 755
INSTALL_SUID	= $(INSTALL) -m 4755
INSTALL_DATA	= $(INSTALL) -m 644

OBJDIR		   = src
INSTALL_OBJS_BIN   = $OBJDIR/$(PACKAGE)
INSTALL_OBJS_MAN1  = *.1
INSTALL_OBJS_SHARE =
INSTALL_OBJS_ETC   =

BINDIR		= $(DESTDIR)$(exec_prefix)/bin
SHAREDIR	= $(DESTDIR)$(prefix)/share/$(PACKAGE)
LIBDIR		= $(DESTDIR)$(prefix)/lib/$(PACKAGE)
MANDIR1		= $(DESTDIR)$(man_prefix)/man/man1
MANDIR5		= $(DESTDIR)$(man_prefix)/man/man5
MANDIR8		= $(DESTDIR)$(man_prefix)/man/man8

SBINDIR		= $(DESTDIR)$(exec_prefix)/sbin
DOCDIR		= $(DESTDIR)$(prefix)/share/doc

EXE		= $(OBJDIR)/$(PACKAGE)

all: $(EXE)

$(EXE):
	$(MAKE) -C $(OBJDIR) CC="$(CC)"

clean:
	$(MAKE) -C $(OBJDIR) clean

distclean:
	$(MAKE) -C $(OBJDIR) distclean

realclean:
	$(MAKE) -C $(OBJDIR) realclean

install-man:
	# install-man
	$(INSTALL_BIN) -d $(MANDIR1)
	$(INSTALL_DATA) $(INSTALL_OBJS_MAN1) $(MANDIR1)

install-bin:
	# install-bin
	$(INSTALL_BIN) -d $(BINDIR)
	$(INSTALL_BIN) -s $(INSTALL_OBJS_BIN) $(BINDIR)

install: all install-bin install-man

.PHONY: clean distclean realclean install install-bin install-man

# End of file
