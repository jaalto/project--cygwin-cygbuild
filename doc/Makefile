#
#   Copyright information
#
#	Copyright (C) 2003-2015 Jari Aalto
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
PL = ../bin/lib/cygbuild.pl

all: doc

# realclean: clean files that can be generated
realclean:
	# Remove generated files
	rm index.txt index.html

clean:
	# clean
	-rm -f *.tmp *[#~] */*[#~]

index.html: $(PL)
	pod2html $? > $@
	rm -f *.tmp

index.txt: $(PL)
	pod2text $? > $@

# doc: [maintenence] generate documentation from source files
doc: index.txt index.html

install-index:
	# install-doc
	$(INSTALL_BIN) -d $(DOCDIR)
	$(INSTALL_BIN) index.txt index.html $(DOCDIR)

install-manual:
	# install-manual
	$(INSTALL_BIN) -d $(DOCDIR)/manual
	$(INSTALL_BIN) manual/* $(DOCDIR)/manual

install-devel:
	# install-devel
	$(INSTALL_BIN) -d $(DOCDIR)/devel
	$(INSTALL_BIN) devel/* $(DOCDIR)/devel

install-license:
	# install-license
	$(INSTALL_BIN) -d $(DOCDIR)/license
	$(INSTALL_BIN) license/* $(DOCDIR)/license

# install: install index, manual, devel, license
install: all install-index	\
	install-manual		\
	install-devel		\
	install-license

# www: [maintenance] copy web pages to ../../<project>-www
www: doc
	name=$$(basename $$(cd .. && pwd)); \
	to=../../$$name-www; \
	echo "Copying to $$to"; \
	find . -type f -name "*.html" | \
	rsync $${test:+"--dry-run"} \
	  --files-from=- \
	  --update \
	  --progress \
	  --verbose \
	  -r \
	  . \
	  $$to/

help:
	@egrep "^# [-a-z]+:" Makefile | sort | sed 's/# //'

.PHONY: all doc clean realclean

# End of file
