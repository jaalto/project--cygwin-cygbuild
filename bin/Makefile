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
#	 Rules for install and maintenance

ifneq (,)
    This makefile requires GNU Make.
endif

include ../mk/common.mk

PL		   = lib/cygbuild.pl
INSTALL_OBJS_BIN   = *.sh
INSTALL_OBJS_MAN1  = *.1
INSTALL_OBJS_LIB   = $(PL) lib/*.sh
INSTALL_OBJS_DATA  = data/*.lst
INSTALL_OBJS_ETC   = etc/*.conf
INSTALL_OBJS_TPL   = template/*.tmp

INSTALL		= /usr/bin/install
INSTALL_BIN	= $(INSTALL) -m 755
INSTALL_DATA	= $(INSTALL) -m 644
INSTALL_SUID	= $(INSTALL) -m 4755

all: doc

cygbuild-rebuild.1: cygbuild-rebuild.pod
	pod2text $? > $@

cygbuild.1: lib/cygbuild.pl
	pod2text $? > $@

doc: man

# man: generate manual page
man: cygbuild.1 cygbuild-rebuild.1

# clean: clean temporary files
clean:
	# clean
	-rm -f *.tmp *.\#* *[#~] */*[#~] *.1

distclean: clean

realclean: clean

install-etc:
	# install-etc
	$(INSTALL_BIN) -d $(ETCDIR)
	$(INSTALL_BIN)	  $(INSTALL_OBJS_ETC) $(ETCDIR)

install-man: man
	# install-man
	$(INSTALL_BIN) -d $(MANDIR1)
	$(INSTALL_DATA)	  $(INSTALL_OBJS_MAN1) $(MANDIR1)

install-bin:
	$(INSTALL_BIN) -d $(BINDIR)
	@for file in  $(INSTALL_OBJS_BIN);				\
	do								\
	    to=$$(echo $$file | sed 's/.sh//');				\
	    $(INSTALL_BIN) $$file $(BINDIR)/$$to;			\
	done;

install-lib:
	# install-lib
	$(INSTALL_BIN) -d $(SHAREDIR)/lib
	$(INSTALL_BIN)	  $(INSTALL_OBJS_LIB) $(SHAREDIR)/lib

install-data:
	# install-lib
	$(INSTALL_BIN) -d $(SHAREDIR)/data
	$(INSTALL_BIN)	  $(INSTALL_OBJS_DATA) $(SHAREDIR)/data

install-template:
	# install-template
	$(INSTALL_BIN) -d $(SHAREDIR)/template
	$(INSTALL_BIN)	  $(INSTALL_OBJS_TPL) $(SHAREDIR)/template

# install: install bin, lib, data,man, etc and templates
install: all \
	 install-bin \
	 install-lib \
	 install-data \
	 install-man \
	 install-etc \
	 install-template

# install-symlink: install in place; e.g. version control checkout
install-symlink:
	# Install using symlinks.
	$(INSTALL_BIN) -d $(BINDIR)
	rm -f $(BINDIR)/cygbuild
	ln -s $$(pwd)/cygbuild.sh $(BINDIR)/cygbuild

	$(INSTALL_BIN) -d $(ETCDIR)
	rm -f $(ETCDIR)/*.conf
	ln -s $$(pwd)/etc/programs.conf $(ETCDIR)/programs.conf

	$(INSTALL_BIN) -d $(SHAREDIR)
	rm -rf $(SHAREDIR)/data \
	       $(SHAREDIR)/lib \
	       $(SHAREDIR)/template
	ln -s $$(pwd)/data $(SHAREDIR)/data
	ln -s $$(pwd)/lib $(SHAREDIR)/lib
	ln -s $$(pwd)/template $(SHAREDIR)/template

help:
	@egrep "^# [-a-z]+:" Makefile | sort | sed 's/# //'

.PHONY: clean distclean realclean install help

# End of file
