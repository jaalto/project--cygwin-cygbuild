#!/usr/bin/make -f
#
#	Copyright (C) 2003-2008 Jari Aalto
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

ifneq (,)
    This makefile requires GNU Make.
endif

all:
	$(MAKE) -C doc all
	$(MAKE) -C bin all

clean:
	$(MAKE) -C doc	     clean
	$(MAKE) -C bin	     clean

realclean: clean

install:
	$(MAKE) -C doc	     install
	$(MAKE) -C bin	     install

install-test:
	# Rule install-test - for Maintainer only
	mkdir -p tmp
	rm -rf tmp/*
	make DESTDIR=`pwd`/tmp prefix=/. install
	@echo "find tmp -type f | sort"

www:
	# Rule www - for Maintainer only
	$(MAKE) -C doc www

.PHONY: all clean distclean realclean install install-test www

# End of file
