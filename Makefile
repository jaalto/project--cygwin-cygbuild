#!/usr/bin/make -f
# $Id: Makefile,v 1.30 2006/02/19 14:56:43 jaalto Exp $
#
#	Copyright (C)  2003-2006  Jari Aalto
#	Keywords:      Makefile, cygbuild, Cygwin
#
#	This program is free software; you can redistribute it and/or
#	modify it under the terms of the GNU General Public License as
#	published by the Free Software Foundation; either version 2 of the
#	License, or (at your option) any later version

ifneq (,)
This makefile requires GNU Make.
endif

PACKAGE	= cygbuild

MAKE_INCLUDEDIR = etc/makefile

include $(MAKE_INCLUDEDIR)/id.mk
include $(MAKE_INCLUDEDIR)/vars.mk
include $(MAKE_INCLUDEDIR)/unix.mk
include $(MAKE_INCLUDEDIR)/cygwin.mk
include $(MAKE_INCLUDEDIR)/net.mk

PL		= bin/$(PACKAGE).pl
SH		= bin/$(PACKAGE).sh \
		  bin/$(PACKAGE)-rebuild.sh

#   There are directories fromt he archive, not install dirs. See vars.mk

FROM_ETC_MAIN	 = etc/etc
FROM_ETC_TMPL	 = etc/template
ETCDIR_TMPL	 = $(SHAREDIR)/template
ETCDIR_TMPL_USER = $(ETCDIR)/template

SRCS		= $(PL) $(SH)
OBJS		= $(SRCS) Makefile README ChangeLog
OBJS_ETC_TMPL	= `find $(FROM_ETC_TMPL) -maxdepth 1 -type f ! -name ".[\#]*" -a ! -name "*[\#~]" `
OBJS_ETC_MAIN	= `find $(FROM_ETC_MAIN) -maxdepth 1 -type f ! -name ".[\#]*" -a ! -name "*[\#~]" `

# ######################################################### &targets ###

.PHONY: all clean distclean realclean test doc
.PHONY: install-etc-template install-etc-template-symlink install

# Rule: all - Make and compile all.
all:	doc


# Rule: clean - Remove unnecessary files
clean: clean-temp-files

# Rule: distclean - Remove files that can be generated
distclean: clean
	@-rm -rf $(DOCDIR)

# Rule: realclean - Clean everything that is not needed
realclean: distclean

test:
	@echo "Nothing to test. Try and report bugs to <$(EMAIL)>"

# Rule: doc - Generate or update documentation
# "docs" is infact synonym for target "doc"
docs: doc

doc: $(DOCDIR)/$(PACKAGE).1
doc: $(DOCDIR)/$(PACKAGE).html
doc: $(DOCDIR)/$(PACKAGE).txt
doc: $(DOCDIR)/cygbuild-rebuild.1

# Rule: doc-readme - [maintenance] Convert README into HTML, you need perl-text2html.sourceforge.net
doc-readme:
	t2html.pl --title "cygbuild README" \
	    --as-is --simple README > doc/README.html

# Rule: install-etc-dir-template - Create /etc directory
install-etc-dir-template:
	$(INSTALL_BIN) -d $(ETCDIR_TMPL) $(ETCDIR_TMPL_USER)

# Rule: install-etc-main - Install configuration files
install-etc-main: install-etc-dir-template
	@for file in $(OBJS_ETC_MAIN);					\
	do								\
	    if [ -f $$file ]; then					\
		echo $(INSTALL_DATA) $$file $(ETCDIR);			\
		$(INSTALL_DATA) $$file $(ETCDIR);			\
	    fi;								\
	done

# Rule: install-etc-main-symlink - Install symlinks to configuration dir
install-etc-main-symlink: install-etc-dir-template
	@for file in $(OBJS_ETC_MAIN);					\
	do								\
	    if [ -f $$file ]; then					\
		ln -vsf `pwd`/$$file $(ETCDIR)/`basename $$file`;	\
	    fi;								\
	done

# Rule: install-etc-template - Install configuration files to
install-etc-template: install-etc-dir-template
	-rm -f	$(ETCDIR_TMPL)/*
	@for file in $(OBJS_ETC_TMPL);					\
	do								\
	    if [ -f $$file ]; then					\
		echo $(INSTALL_DATA) $$file $(ETCDIR_TMPL);		\
		$(INSTALL_DATA) $$file $(ETCDIR_TMPL);			\
	    fi;								\
	done

# Rule: install-etc-template-symlink - Install symlinks to configuration dir
install-etc-template-symlink: install-etc-dir-template
	-rm -f	$(ETCDIR_TMPL)/*
	@for file in $(OBJS_ETC_TMPL);					\
	do								\
	    if [ -f $$file ]; then					\
		ln -vsf `pwd`/$$file $(ETCDIR_TMPL)/`basename $$file`;	\
	    fi;								\
	done

# Rule: install-etc - Synonym for target [install-etc-template]
install-etc: install-etc-main install-etc-template

# Rule: install-in-place - After CVS checkout, install the package using symlinks
install-in-place: install-etc-template-symlink install-etc-main-symlink \
	install-bin-symlink install-man

# Rule: install - install everything to system directories
install: install-unix install-etc

# ######################################################### &release ###

.PHONY: kit release

release: kit

# Rule: kit - [maintenance] Make a World and Cygwin binary release kits
kit: release-world release-cygwin

# #################################################### &dependencies ###

# Pod generates .x~~ extra files, remove those

.SUFFIXES:
.SUFFIXES: .1 .html .txt .pod

install-docdir:
	$(INSTALL_BIN) -d $(DOCDIR)

$(DOCDIR)/$(PACKAGE).1: $(PL) install-docdir
	perl ./$< help --man > $(DOCDIR)/$(PACKAGE).1
	@-rm -f *.x~~ pod*.tmp

$(DOCDIR)/$(PACKAGE).html: $(PL) install-docdir
	perl ./$< help --html > $(DOCDIR)/$(PACKAGE).html
	@-rm -f *.x~~ pod*.tmp

$(DOCDIR)/$(PACKAGE).txt: $(PL) install-docdir
	perl ./$< help > $(DOCDIR)/$(PACKAGE).txt
	@-rm -f *.x~~ pod*.tmp

$(DOCDIR)/cygbuild-rebuild.1: bin/cygbuild-rebuild.pod install-docdir
	name=`echo $< | sed -e 's/.*\///; s/.pod//'`; pod2man $< > $(DOCDIR)/$$name.1
	@-rm -f *.x~~ pod*.tmp

# End of file
