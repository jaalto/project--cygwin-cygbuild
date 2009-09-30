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

PACKAGE		= name
OBJDIR		= src
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

install: all
	$(MAKE) -C $(OBJDIR) install

.PHONY: clean distclean realclean install

# End of file
