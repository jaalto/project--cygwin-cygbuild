#!/usr/bin/make -f
#
#   Copyright information
#
#	Copyright (C) YYYY Firstname Lastname
#
#   License
#
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#       GNU General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with this program. If not, see <http://www.gnu.org/licenses/>.

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
