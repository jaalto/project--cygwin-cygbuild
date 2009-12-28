#!/usr/bin/make -f
#
#   Copyright information
#
#	Copyright (C) 2003-2010 Jari Aalto
#	Copyright (C) YYYY Firstname Lastname
#
#   License
#
#	This program is free software; you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation; either version 2 of the License, or
#	(at your option) any later version.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program. If not, see <http://www.gnu.org/licenses/>.

ifneq (,)
This makefile requires GNU Make.
endif

PACKAGE		= foo
DESTDIR		=
prefix		= /usr
exec_prefix	= $(prefix)
man_prefix	= $(prefix)/share
mandir		= $(man_prefix)/man
bindir		= $(exec_prefix)/bin
sharedir	= $(prefix)/share

BINDIR		= $(DESTDIR)$(bindir)
DOCDIR		= $(DESTDIR)$(sharedir/doc
SHAREDIR	= $(DESTDIR)$(prefix)/share/$(PACKAGE)
LIBDIR		= $(DESTDIR)$(prefix)/lib/$(PACKAGE)
SBINDIR		= $(DESTDIR)$(exec_prefix)/sbin
ETCDIR		= $(DESTDIR)/etc/$(PACKAGE)

# 1 = regular, 5 = conf, 6 = games, 8 = daemons
MANDIR		= $(DESTDIR)$(mandir)
MANDIR1		= $(MANDIR)/man1
MANDIR5		= $(MANDIR)/man5
MANDIR6		= $(MANDIR)/man6
MANDIR8		= $(MANDIR)/man8


LDFLAGS		=
CC		= gcc
GCCFLAGS	= -Wall
DEBUG		= -g
CFLAGS		= $(CC_EXTRA_FLAGS) $(DEBUG) -O2
CXX		= g++
CXXFLAGS	= $(CXX_EXTRA_FLAGS) $(DEBUG) -O2

ifneq ($(WINDIR),)
EXT = .exe
endif

SRCS		= $(PACKAGE).c
OBJS		= $(SRCS:.c=.o)
EXE		= $(PACKAGE)$(EXT)
LIBS		=

INSTALL_OBJS_BIN   = $(EXE)
INSTALL_OBJS_MAN1  = *.1
INSTALL_OBJS_SHARE =
INSTALL_OBJS_ETC   =
INSTALL_OBJS_DOC   =

INSTALL		= /usr/bin/install
INSTALL_BIN	= $(INSTALL) --mode=755 --strip
INSTALL_SCRIPT	= $(INSTALL) --mode=755
INSTALL_DATA	= $(INSTALL) --mode=644
INSTALL_DIR	= $(INSTALL) --mode=644 --directory
INSTALL_SUID	= $(INSTALL) --mode=4755

ASM_SRCS	=
ASM_OBJS	= $(ASM_SRCS:.asm=.o)
ASM_FLAGS	=

.SUFFIXES: .asm

all: $(EXE)

.cc.o:
	$(CXX) $(CXXLAGS) -c -o $*.o $<

.asm.o: $(ASM_OBJS)
	nasm $(ASM_FLAGS) $<

$(EXE): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS) $(LIBS)

# Delete files fromt he build process.
clean:
	# clean
	-rm -f *[#~] *.\#* *.o core \
	*.pyc *.elc \
	*.exe *.stackdump $(PACKAGE)

#  Delete files that are created by configuring or building the program.
#  Leave only the files that were in the distribution.
distclean: clean

#  Delete almost everything that can be reconstructed.
realclean: clean

#  This replaces 'realclean' in new GNU standards.
maintainer-clean: realclean

install-etc:
	# install-etc
	$(INSTALL_DIR) $(ETCDIR)
	$(INSTALL_BIN) $(INSTALL_OBJS_ETC) $(ETCDIR)

install-doc:
	# install-doc
	$(INSTALL_DIR) $(DOCPKGDIR)
	tar --dereference --create --file - $(INSTALL_OBJS_DOC) | \
	tar --directory $(DOCPKGDIR) --extract --file -

install-man:
	# install-man
	$(INSTALL_DIR) $(MANDIR1)
	$(INSTALL_DATA) $(INSTALL_OBJS_MAN1) $(MANDIR1)

install-bin:
	# install-bin
	$(INSTALL_DIR) $(BINDIR)
	$(INSTALL_BIN) $(INSTALL_OBJS_BIN) $(BINDIR)

install: all install-bin install-man

.PHONY: clean distclean realclean install install-bin install-man

# End of file
