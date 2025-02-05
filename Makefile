#!/usr/bin/make -f
#
#	Copyright (C) 2003-2025 Jari Aalto
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

# all: run target in doc/ and bin/
all:
	$(MAKE) -C doc all
	$(MAKE) -C bin all

# clean: clean om doc/ and bin/
clean:
	$(MAKE) -C doc clean
	$(MAKE) -C bin clean

realclean: clean

# install: install doc/ and bin/
install:
	$(MAKE) -C doc install
	$(MAKE) -C bin install

# install-symlink: install in place; like from version control checkout
install-symlink:
	$(MAKE) -C bin install-symlink

# install-test: [maintenance] make test install to tmp/
install-test:
	# Rule install-test - for Maintainer only
	mkdir -p tmp
	rm -rf tmp/*
	make DESTDIR=`pwd`/tmp prefix=/. install
	@echo "find tmp -type f | sort"

doc/manual/index.html: bin/lib/cygbuild.pl
	pod2html $< > $@

doc/manual/index.txt: doc/manual/index.html
	lynx -dump $< > $@

# doc: generate documentation and manual pages
doc: doc/manual/index.html doc/manual/index.txt
	$(MAKE) -C bin man

# www: [maintenance] Publish doc/ directory's WWW documentation
www:
	# Rule www - for Maintainer only
	$(MAKE) -C doc www

help:
	@egrep "^# [-a-z]+:" Makefile | sort | sed 's/# //'

.PHONY: all clean distclean realclean install install-test www

# End of file
