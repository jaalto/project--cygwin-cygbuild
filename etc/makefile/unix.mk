#!/usr/bin/make -f
# -*- makefile -*-
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
#	General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with program. If not, write to the Free Software
#	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
#	02110-1301, USA.
#
#	Visit <http://www.gnu.org/copyleft/gpl.html>

# ######################################################### &targets ###

.PHONY: install-make-etc-dir install-etc install-man
.PHONY: install-bin install-bin-symlink install-unix
.PHONY: clean-temp-files clean-temp-dirs clean-temp-realclean
.PHONY: help help-dev help-devel
.PHONY: release-world list-world
.PHONY: manifest manifest-check

install-make-etc-dir:
	# install-make-etc-dir
	$(INSTALL_BIN) -d $(ETCDIR)

install-etc: install-make-etc-dir
	# install-etc
	@for file in $(OBJS_ETC);					\
	do								\
	    $(INSTALL_DATA) $$file $(ETCDIR);				\
	done

install-man-dir:
	# install-man-dir
	$(INSTALL_BIN) -d $(MANDIR)

install-man: doc install-man-dir
	# install-man
	@for file in `ls $(DOCDIR)/*.1 $(DOCDIR)/man/*.1 2> /dev/null`; \
	do								\
	    echo "Installing $$file => $(MANDIR)";			\
	    $(INSTALL_DATA) $$file $(MANDIR);				\
	done;

install-bin-sh:
	# install-bin-sh
	$(INSTALL_BIN) -d $(BINDIR)
	@for file in $(SH);						\
	do								\
	    $$to=`echo $file | sed 's/.sh//' `;				\
	    $(INSTALL_BIN) $$file $(BINDIR)/$to;			\
	done;

install-bin-pl:
	# install-bin-pl
	$(INSTALL_BIN) -d $(SHAREDIR)/lib
	@for file in $(PL);						\
	do								\
	    $(INSTALL_BIN) $$file $(SHAREDIR)/lib;			\
	done;

install-bin: install-bin-sh install-bin-pl

# Rule: install-bin-symlink - [maintenance] Install from current location using symlinks
# Install perl module to different directory
install-bin-symlink:
	# install-bin-symlink
	$(INSTALL_BIN) -d $(BINDIR) $(SHAREDIR)/lib
	@for file in  $(SRCS);						\
	do								\
	    dir=`$(DIRNAME) $$file`;					\
	    file=`$(BASENAME) $$file`;					\
	    to=`echo $(BINDIR)/$$file | sed 's/.sh//' `;		\
	    if echo $$file | grep  "\.pl" > /dev/null ; then		\
		to=$(SHAREDIR)/lib/$$file;				\
	    fi;								\
	    file=`cd $$dir; pwd`/$$file;				\
	    echo "Installing symlink $$file => $$to";			\
	    ln -sf $$file $$to;						\
	done;

# Rule: install-unix - Standard install (copy files).
install-unix: install-man install-bin

clean-temp-files:
	# clean-temp-files
	-for file in `find . -type f					\
	    '('								\
		-name "*[~#]"						\
		-o -name ".[#]*"					\
		-o -name core						\
	    ')' ` ;							\
	do								\
	    rm -f $$file;						\
	done;

# Rule: clean-temp-dirs - [maintenance] Remove directories that can be generated
clean-temp-dirs:
	-rm -rf .inst/ .sinst/ .build/

# Rule: clean-temp-realclean - [maintenance] Remove files and directories that can be generated
clean-temp-realclean: clean-temp-files clean-temp-dirs

help-dev:
	@egrep -ie '# +Rule:' $(MAKEFILE) $(MAKE_INCLUDEDIR)/*.mk	\
		2> /dev/null						\
	    | sed -e 's/.*Rule://' | sort;

help-devel: help-dev

help:
	@$(MAKE) help-dev | grep -v 'maintenance'

# xRule: release-world - [maintenance] Make a world release
release-world:
	# release-world
	@rm -rf $(RELEASEDIR)/
	@$(INSTALL_BIN) -d $(RELEASEDIR)
	@$(TAR) $(TAR_OPT_NO) -zcf - . | ( cd $(RELEASEDIR); tar -zxf - )
	@cd $(BUILDDIR) &&						    \
	$(TAR) $(TAR_OPT_WORLD) -zcf $(RELEASE_FILE) $(PACKAGEVER)
	@echo Reading installed friles from $(RELEASE_FILE_PATH)
	@tar -ztvf $(RELEASE_FILE_PATH)

# xRule: list-world - [maintenance] List content of world release.
list-world:
	$(TAR) -ztvf $(TAR_FILE_WORLD_LS)

# Rule: manifest: [maintenance] Make list of files in this project into file MANIFEST
# Rule: manifest: [maintenance] files matching regexps in MANIFEST.SKIP are skipped.
manifest:
	# manifest
	$(PERL) -MExtUtils::Manifest=mkmanifest -e 'mkmanifest()'

# Rule: manifest-check: [maintenance] checks if MANIFEST files really do exist.
manifest-check:
	# manifest-check
	perl -MExtUtils::Manifest=manicheck -e \
	     'exit 1 if manicheck()'

# End of file
