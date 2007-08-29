#!/usr/bin/make -f
#
#	Copyright (C) 2003-2007 Jari Aalto
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
#	Visit <http://www.gnu.org/copyleft/gpl.html>

# ######################################################### &targets ###

.PHONY: install-make-etc-dir install-etc install-man
.PHONY: install-bin install-bin-symlink install-unix
.PHONY: clean-temp-files clean-temp-dirs clean-temp-realclean
.PHONY: help-makefile help
.PHONY: release-world list-world
.PHONY: manifest manifest-check

install-make-etc-dir:
	$(INSTALL_BIN) -d $(ETCDIR)

install-etc: install-make-etc-dir
	@for file in $(OBJS_ETC);					\
	do								\
	    $(INSTALL_DATA) $$file $(ETCDIR);				\
	done

install-man-dir:
	$(INSTALL_BIN) -d $(MANDIR)

install-man: doc install-man-dir
	@for file in `ls $(DOCDIR)/*.1 $(DOCDIR)/man/*.1 2> /dev/null`; \
	do								\
	    echo "Installing $$file => $(MANDIR)";			\
	    $(INSTALL_DATA) $$file $(MANDIR);				\
	done;

install-bin-sh:
	$(INSTALL_BIN) -d $(BINDIR)
	@for file in $(SH);						\
	do								\
	    $$to=`echo $file | sed 's/.sh//' `;				\
	    $(INSTALL_BIN) $$file $(BINDIR)/$to;			\
	done;

install-bin-pl:
	$(INSTALL_BIN) -d $(SHAREDIR)/lib
	@for file in $(PL);						\
	do								\
	    $(INSTALL_BIN) $$file $(SHAREDIR)/lib;			\
	done;

install-bin: install-bin-sh install-bin-pl

# Rule: install-bin-symlink - Install from current location using symlinks
# Install perl module to different directory
install-bin-symlink:
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

# Rule: install-unix - Install files. Run rule 'doc' first
install-unix: install-man install-bin

clean-temp-files:
	-for file in `find . -type f					\
	    '('								\
		-name "*[~#]"						\
		-o -name ".[#]*"					\
		-o -name core						\
	    ')' ` ;							\
	do								\
	    rm -f $$file;						\
	done;

# Rule: clean-temp-dirs - Remove directories that can be generated
clean-temp-dirs:
	-rm -rf .inst/ .sinst/ .build/

# Rule: clean-temp-realclean - Remove files and directories that can be generated
clean-temp-realclean: clean-temp-files clean-temp-dirs

# Rule: help - Display make target summary
help-makefile:
	@egrep -ie '# +Rule:' $(MAKEFILE) | sed -e 's/.*Rule://' | sort

help:
	@egrep -ie '# +Rule:' $(MAKEFILE) $(MAKE_INCLUDEDIR)/*.mk \
	    | sed -e 's/.*Rule://' | sort;

#	@for file in $(MAKEFILE) $(MAKE_INCLUDEDIR)/*.mk;	\
#	do							       \
#	    egrep -e '# +Rule:' $$file | sed -e 's/.*Rule://' | sort;	\
#	done;


# Rule: release-world - [maintenance] Make a world release
release-world:
	@rm -rf $(RELEASEDIR)/
	@$(INSTALL_BIN) -d $(RELEASEDIR)
	@$(TAR) $(TAR_OPT_NO) -zcf - . | ( cd $(RELEASEDIR); tar -zxf - )
	@cd $(BUILDDIR) &&						    \
	$(TAR) $(TAR_OPT_WORLD) -zcf $(RELEASE_FILE) $(PACKAGEVER)
	@echo Reading installed friles from $(RELEASE_FILE_PATH)
	@tar -ztvf $(RELEASE_FILE_PATH)

# Rule: list-world - [maintenance] List content of world release.
list-world:
	$(TAR) -ztvf $(TAR_FILE_WORLD_LS)

# Rule: manifest: Make list of files in this project into file MANIFEST
# Rule: manifest: files matching regexps in MANIFEST.SKIP are skipped.
manifest:
	$(PERL) -MExtUtils::Manifest=mkmanifest -e 'mkmanifest()'

# Rule: manifest-check: checks if MANIFEST files really do exist.
manifest-check:
	perl -MExtUtils::Manifest=manicheck -e \
	     'exit 1 if manicheck()'

# End of file
