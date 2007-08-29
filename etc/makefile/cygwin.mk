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
#
#   Cygwin build: How it all works?
#
#	Everything is done under .build/ directory where the released
#	tar files will appear. The first phase is to make world release.
#	You must do it first, because it copies everything under RELEASEDIR
#	which will be exact snapshot of the current package directory (or CVS
#	checkout)
#
#	    .build/package-YYYY.MMDD/		<< RELEASEDIR
#
#	Now, the cygbuild.sh tool will chdir _inside_ this RELEASEDIR directory
#	and will give all packaging commands from there. The results appear
#	one directory above (..), which efectively puts the created files in:
#
#	    .build/
#
#	The 'publish' command works similarly. It enters the RELEASEDIR and looks
#	Cygwin files one directory above (..) and copies them to the default
#	destination directory. This directory is usually configured to Web server
#	and it is seen to the outside world.

CYGBUILD	= cygbuild.sh
CYGBUILDBIN	= bin/$(CYGBUILD)

ETC_CYGWIN	 = etc/cygwin
CYGWIN_SETUP_INI = $(ETC_CYGWIN)/setup.ini

TAR_FILE_CYGWIN	 = $(RELEASE_FILE_PATH)/$(PACKAGEVER)-$(RELEASE)

# ######################################################### &targets ###

# Rule: release-cygwin - [maintenance] Make a Cygwin Net releases. Call: make RELEASE=1 ...
release-cygwin: release-cygwin-bin release-cygwin-source

release-cygwin-bin-check:
	@if [ ! -d $(RELEASEDIR) ] ; then \
	    echo "ERROR: You must first make target 'release-world'"; \
	    false; \
	fi

# Rule: release-cygwin-bin-fix - [maintenance] Make 'install' 'readmefix'
release-cygwin-bin-fix: release-cygwin-bin-check
	@cd $(RELEASEDIR) &&					    \
	$(CYGBUILDBIN) -r $(RELEASE) -x makedirs reshadow install package readmefix

# Rule: release-cygwin-bin-only - [maintenance] Make 'install' and 'package'
release-cygwin-bin-only: release-cygwin-bin-check
	@cd $(RELEASEDIR) &&					    \
	$(CYGBUILDBIN) -r $(RELEASE) -x makedirs install package

# Rule: release-cygwin-bin - [maintenance] Make everything for binary package
release-cygwin-bin: release-cygwin-bin-fix release-cygwin-bin-only
	@ls $(TAR_FILE_CYGWIN).tar.bz2
	tar -jtvf $(TAR_FILE_CYGWIN).tar.bz2

# Rule: release-cygwin-source - [maintenance] Make everything for source package
release-cygwin-source:
	cd $(RELEASEDIR) &&					    \
	$(CYGBUILDBIN) -r $(RELEASE) makedirs source-package
	ls -l $(TAR_FILE_CYGWIN)*.tar.bz2
	@echo Run 'make publish-cygwin' if all looks good

# Rule: release-cygwin-source-verify - [maintenance] Verify source package
release-cygwin-source-verify:
	cd $(RELEASEDIR) &&					    \
	$(CYGBUILDBIN) -r $(RELEASE) mkdirs source-package-verify

# This is not fully automatic. But it helps. The perl program will print
# the modified setup.ini, from which the last entry can be copy/pasted
# to the original setup.ini
#
# Rule: cygwin-setup-ini-update - [maintenance] Update setup.ini
cygwin-setup-ini-update:
	@ini=$(CYGWIN_SETUP_INI);				    \
	tar=$(TAR_FILE_CYGWIN).tar.bz2;				    \
	module=`which cygbuild.pl`;				    \
	[ ! "$$module" ] && echo "Run make install-in-place" && false;	 \
	echo Updating $$ini with $$tar;				    \
	$(PERL) -MEnglish -e "					    \
	    @arr = (shift @ARGV,  shift @ARGV);			    \
	    require qq($$module);				    \
	    CygwinSetupIniUpdate(@arr)" $$ini $$tar
	@echo -e "\n[NOTE] If this looks ok, copy the last paragraph" \
	       "to $(CYGWIN_SETUP_INI)"

# This simply copies the cygwin binary and source packages made after
# target 'kit' to the Web server publishing are from where they are
# available.
#
# Rule: publish-cygwin - [maintenance] Publish Cygwin net release
publish-cygwin:
	cd $(RELEASEDIR) && \
	$(CYGBUILD) -r $(RELEASE) publish

# Rule: list-cygwin: - [maintenance] List content of latest Cygwin Net release.
list-cygwin:
	$(TAR) -jtvf $(TAR_FILE_CYGWIN).tar.bz2

# End of file
