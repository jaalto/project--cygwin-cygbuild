#!/usr/bin/perl
#
#   cygbuild.pl --- A Perl library for Cygwin Net Release packager
#
#       Copyright (C) 2003-2009 Jari Aalto
#
#   License
#
#       This program is free software; you can redistribute it and/or
#       modify it under the terms of the GNU General Public License as
#       published by the Free Software Foundation; either version 2 of
#       the License, or (at your option) any later version.
#
#       This program is distributed in the hope that it will be useful, but
#       WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#       General Public License for more details.
#
#    Description
#
#       This program is part of the cygbuild: Utilities for Cygwin package
#       maintainers.
#
#       This file is bifunctional. It's a callable perl script, but also a perl
#       function library. It is controlled from cygbuild.sh which see:
#
#           $ cygbuild --help

require 5.10.0;                 # perlre: Named backreferences
use strict;
use integer;

use autouse 'Pod::Text'     => qw( pod2text                 );
use autouse 'Pod::Html'     => qw( pod2html                 );
use autouse 'Text::Tabs'    => qw( expand                   );
use autouse 'File::Copy'    => qw( copy move                );
use autouse 'File::Path'    => qw( mkpath rmtree            );
use autouse 'File::Basename'=> qw( dirname basename         );
use autouse 'File::Find'    => qw( find                     );

package File::Find;
    use vars qw($name $fullname);
package main;

use English;
use Cwd;
# use Getopt::Long;
# use POSIX qw(strftime);

# ..................................................................

IMPORT:
{
    use Env;

    #   SYSTEMROOT is WinNT/W2k install root directory

    use vars qw
    (
	$SYSTEMROOT
	$NAME
	$DEBFULLNAME
	$CYGBUILD_FULLNAME
	$EMAIL
	$CYGBUILD_EMAIL
    );
}

my $systemName  = $CYGBUILD_FULLNAME || $NAME || $DEBFULLNAME;
my $systemEmail = $CYGBUILD_EMAIL    || $EMAIL;

my $CYGWIN_PACKAGE_LIST_DIR = "/var/lib/cygbuild/list";

#   Sites that use RETURN, i.e. empty, passwords
my $PASSORD_RET_SITES = 'sourceforge';

#   When called as library (from cygbuild.sh), the PATH isn't there.
$PROGRAM_NAME = "cygbuild.pl"   if  $PROGRAM_NAME eq '-e';

# ..................................................................

use vars qw ( $VERSION );

#   This is for use of Makefile.PL and ExtUtils::MakeMaker
#   So that it puts the tardist number in format YYYY.MMDD
#   The REAL version number is defined later

#   The following variable is updated by Emacs setup whenever
#   this file is saved.

$VERSION = '2009.0205.1557';

# ..................................................................

my $LIB       = "cygbuild.pl";
my $debug     = 0;          # Don't touch. use SetDebug();

#  See wanted() functions

my @FILE_FILE_LIST;
my @FILE_DIR_LIST;
my @FILE_ALL_LIST;
my $FILE_REGEXP;
my $FILE_REGEXP_PRUNE = '\.(build|s?inst)';  # Dynamic variable

# ..................................................................

=pod

=head1 NAME

cygbuild - Cygwin source and binary package build script

=head1 SYNOPSIS

    cygbuild [options] [-r RELEASE] CMD [CMD ...]

=head1 DESCRIPTION - A QUICK OVERVIEW

The directories used in the program are as follows:

  ROOT/package
       <original upstream package source(s): package-1.2.3.tar.gz>
       |
       +- package-1.2.3/
	  <upstream *.tar.gz unpacked>
	  <All cygbuild commands must be given in *this* directory>
	  |
	  +- .build/
	  |  <generic working area of temporary files>
	  |  |
	  |  +- build/
	  |  |  <separate "shadow" directory where compiling happens>
	  |  |  <contains only symlinks and object *.o etc. files>
	  |  |
	  |  +- package-1.2.3-orig/
	  |     <Used during taking a diff for Cygwin source package>
	  |
	  +- .inst/
	  |  <The "make install" target directory>
	  |
	  +- .sinst/
	      <diffs, signatures, binary and source packages appear here>

B<CASE A)> to build Cygwin Net Release from a package that includes a
standard C<./configure> script, the quick path for porting would be in
the fortunate case:

    $ export NAME="Firstname Lastname"
    $ export EMAIL="foo@example.com"

    ... make a project directory

    $ mkdir -p /tmp/package
    $ cd /tmp/package
    $ wget http://example.com/package-N.N.tar.gz
    $ tar -zxvf package-N.N.tar.gz

    ... source has now been unpacked, go there

    $ cd package-N.N/

    ... If this is the first port ever, it is better to run commands
    ... individually to see possible problems.
    ...
    ... If you have GPG key, you can add options -s "SignerKeyID"
    ... -p "pass phrase" to commands 'package', 'source-package' and
    ... 'publish'. Option -r marks "release 1".

    $ cygbuild -r 1 makedirs
    $ cygbuild -r 1 files
    $ cygbuild -r 1 readmefix       # Fill in CYGWIN/package.README
    $ cygbuild -r 1 shadow          # prepare sources to .build/build
    $ cygbuild -r 1 configure
    $ cygbuild -r 1 make
    $ cygbuild -r 1 -v -t install   # "verbose test mode" first
    $ cygbuild -r 1 install         # The "real" install
    $ find .inst/ -print            # Verify install structure
    $ cygbuild -r 1 -v check        # Do install integrity check
    $ cygbuild -r 1 package         # Make Net install binary
    $ cygbuild -r 1 source-package  # Make Net install source
    $ cygbuild -r 1 publish         # Copy files to publish area (if any)

There is also shortcut 'import', which runs all steps up till 'make'

    $ cygbuild -r 1 import
    ...  Package is configured. Did it succeed? Run test install
    $ cygbuild -r 1 -v -t install
    ...  If ok, continue just like in the example above

To make this easier, an alias will help.

    $ alias cb="cygbuild --color --sign $GPGKEY"
    $ cb -r 1 import
    ...

B<CASE B)> If the downloaded Cygwin source release package is
controlled by cygbuild, then commands B<[all]> and B<[almostall]> can
be used to check the binary build:

    $ mkdir -p /tmp/package
    $ cd /tmp/package
    $ tar -xf /path/to/package-N.N-RELEASE-src.tar.bz2
    $ ./*.sh --color --verbose all

=head1 OPTIONS

=over 4

=item B<-b, --bzip2>

Use bzip2 compression instead of default package compression. This
affects the manual pages and the usr/share/doc/*/ content.

=item B<-c, --color>

Activate colors in displayed messages.

=item B<--cygbuiddir DIR>

PATH where all the temporary files are kept; object files, taking diffs
etc. The default value is C<./.build>.

=item B<--cyginstdir DIR>

PATH where C<make install> will install the source package's executable
files, documentation files etc. The default value is C<./.inst>.

=item B<--cygsinstdir DIR>

PATH where ready Cygwin Net Release packages and patch files are put.
etc. The default value is C<./.sinst>.

=item B<-d, --debug LEVEL>

Turn on debug. Usually means running external shell files with -x
enabled.

=item B<-e, --email EMAIL>

Set email address. This effectively sets variable C<CYGBUILD_EMAIL>
that is used in B<[readmefix]> command.

=item B<-g, --gbs>

Activate g-b-s compatibility mode -- that is -- behave like Cygwin Build
Script. This changes behavior and command in the following manner:

=over 4

=item commands: B<[all]>, B<[binary-package]> and B<[source-package]>

Move the generated source package C<package-N.N.tar.bz2> and binary package
C<package-N.N-src.tar.bz2> to one directory up C<../> instead the default
location <./sinst>.

=back

=item B<-f, --file FILE>

Specify package file and version, like C<foo-1.11.tar.gz> from which the
VERSION and possible RELEASE numbers can be derived. This option is needed
only if the current directory is not in format C<package-version>. Problems
in 99% of the cases are in the source file names. See 'Packages with
non-standard versioning schemes' how to deal with unusual packages when
doing porting.

This option comes handy with command B<[check]> when someone else's
binary package results are being checked. An example:

  $ ls
    foo-2.1.tar.gz
    foo-2.1-1.tar.bz2
    foo-2.1-1-src.tar.bz2
  ... make "pseudo" install directory
  $ mkdir .inst
  ... examine the binary package
  $ (cd .inst ; tar -jxvf ../foo-2.1-1.tar.bz2)
  $ cygbuild -f foo-2.1-1.tar.bz2 --cyginstdir .inst --verbose check

=item B<-h>

Print program's internal short help.

=item B<--help>

Print long help (this page).

=item B<--install-prefix PREFIX>

Set custom install PREFIX. The value must be path (no leading slash)
relative to install dir C<./.sinst>. The default is to install using prefix
value I<usr>, which puts files in directories like:

    usr/bin
    usr/share/doc
    ...

=item B<--install-usrlocal>

Arrange all relevant prefixes to use C<usr/local> install structure instead
of the default C<usr>. With this option the packages created are suitable
for private installation. Keep this option with every command, so that
program knows about the special port:

    cygbuild --release 1 --install-usrlocal CMD ...

=item B<-l, --lzma>

Use lzma compression instead of default package compression. This
affects the manual pages and the usr/share/doc/*/ content.

=item B<-p, --passphrase "PASS PHRASE">

Signing pass phrase. In multiuser environment, consider security carefully
before using this option.

=item B<-r, --release RELEASE>

This option is required option by almost all commands.

Specify build release: 1, 2, 3 etc. If this is word "date", then derive
build number from date(1) in format YYYYMMDDHHMM

=item B<-s, --sign SIGNKEY>

GPG key to use for signing. It is best to use the hexadecimal unique key
id to avoid picking the wrong key from key ring. See C<gpg --list-keys>.

=item B<-t, --test>

Run in test mode. This option is respected when B<[install]> command is
run: no actual changes or install is done. This is good way to check that
Makefile doesn't mistakenly install to system directories.

=item B<-v, --verbose>

Print more informational messages.

=item B<-V, --version|--Version>

Print version number.

=item B<-x, --no-strip>

Do not strip executables or check strip status before command B<[package]>.
Use this option if package contains only interpreted files like Perl,
Python or Shell scripts etc.

B<NOTE:> This options should be avoided and it may be removed. Program is
99% in the cases able to detect if and when strip is needed.

=back

=head1 PACKAGE MAINTENANCE COMMANDS

=head2 Preparation commands

=over 4

=item B<mkdirs>

Make Cygwin build directories

    package-N.N/.build/                    Scratch work area
    package-N.N/.inst/                     Binary package
    package-N.N/.sinst/                    Source package
    package-N.N/CYGWIN-PATCHES/            Control directory

=item B<files>

Install default files into C<package-N.N/CYGWIN-PATCHES/>. You have to edit
two mandatory files, C<README> and C<setup.hint>, before running building a
binary package with command B<[package]>. Files that include extension
C<.tmp> are examples. These files are only needed if package cannot be
ported directly by using standard C<./configure> or C<make install> calls.

    package.README          Mandatory, edit this
    setup.hint              Mandatory, edit this
    conf.sh.tmp             optional; If there is no ./configure
    build.sh.tmp            optional; If standard "make all"
				      doesn't do it
    install.sh.tmp          optional; If "make install"
				      doesn't do it
    install-after.sh.tmp    optional; If "make install"
				      quite didn't do it right. E.g
				      moving .inst/etc/* files elsewhere
    postinstall.sh.tmp      optional; Things to do after system
				      install for binary packages

If you remove the extension C<.tmp>, the shell scripts are automatically
noticed and used. You can leave the files alone if you do not use them,
because all files ending to C<.tmp> are ignored during
packaging commands B<[package]> or B<[source-package]>.

=back

=head2 Build commands

=over 4

=item B<configure>

Run user supplied C<package-N.N/CYGWIN-PATCHES/configure.sh>. If not found,
try C<package-N.N/configure> or C<package-N.N/buildconf> with
predefined Cygwin switches

Before this command, the source files should have been prepared with
command B<[shadow]> (which see).

=item B<build>

Run user supplied C<package-N.N/CYGWIN-PATCHES/build.sh>. If not found, then
run command which resembles something like below (cf. B<ENVIRONMENT>):

    LDFLAGS= CFLAGS="-O2 -g" make CC=gcc CXX=g++

=item B<make>

Synonym for command B<[build]>.

=item B<[dist|real]clean>

Run any I<make> target whose name ends to C<clean>. That is: clean,
distclean, realclean etc.

=back

=head2 Install commands (in order of execution)

=over 4

=item B<strip>

Strip C<*.exe> and C<*.dll> files under C<package-N.N/.inst/>

=item B<install>

Install package to directory C<package-N.N/.inst/>. If use supplied
C<package-N.N/CYGWIN-PATCHES/install.sh> exist, run it instead of normal:

    make install

When porting for the first time, accompany this command with the test
option B<-t> so that no harm is done even if Makefile would try to place
files to weird places.

    cygbuild --release 1 --test install

=item B<import>

Start porting the project. Effectively runs steps B<[makedirs]>,
B<[files]>, B<[configure]>, B<[make]>.

=item B<check>

Run various checks to ensure that the install to directory .inst/ look
good. It is highly recommended that you use this command with verbose
option B<--verbose>. Some of the checks include:

    - Check that there is no temporary files in install directory
    - Check that package.README looks ok
    - Check if there are info files, but no postinstall script to
      install those info files.
    - Check that all executables also have associated manual pages
      Each program should have manual page, even if it only
      suggests looking elsewhere.
    - etc.

The directory being checked is C<./.inst> by default, but this
can be changed, e.g. if checking some other package's install
results:

    cygbuild --cyginstdir /other/path/.inst --verbose check

See also description of option B<--file> how to check other
developer's binary packaging.

=item B<check-deps>

Check that all dependencies are listed in C<package.README> and
C<setup.hint>. It is highly recommended that you use this command with
verbose option B<--verbose>.

=item B<postinstall>

Run C<package-N.N/CYGWIN-PATCHES/postinstall.sh> if it exists. The
destination install root directory C<package-N.N/.inst/> is used. This
command is meant for testing the C<postinstall.sh> script if it is
supplied.

=item B<preremove>

Run C<package-N.N/CYGWIN-PATCHES/preremove.sh> if it exists. The
destination install root directory C<package-N.N/.inst/> is used. This
command is meant for testing the C<preremove.sh> script if it is
supplied.

=back

=head2 Packaging commands

=over 4

=item B<mkpatch>

Run user supplied C<package-N.N/CYGWIN-PATCHES/diff.sh>. If it does not exists,
run diff between original package and current modifications. You must:

  1. chdir to directory C<package-N.N/>
  2. Provide original package directly above current run
     directory; that is ../
     (See option -f in case source cannot be found by the program)

=item B<package>

Make binary package C<PACKAGE-VERSION-REL.tar.bz2> to directory C<.sinst/>.

=item B<package-devel> or B<pkgdev>

For library distributions, this command splits the binary distribution into
three categories:

    libPACKAGE-N.N-REL.tar.bz2       *.dll from  usr/
    libPACKAGE-devel-N.N-REL.tar.bz2 all   from  usr/include  usr/lib
    libPACKAGE-doc-N.N-REL.tar.bz2   all   from  usr/doc      usr/man

The prefix 'lib' is not added in front of PACKAGE if PACKAGE name already
starts with string 'lib'. In order to make a library release, there must be
separate setup hint files for each in directory C<CYGWIN-PATCHES/>.
Program will warn if any of these are missing

     setup.hint             for the runnable *.dll
     setup-devel.hint       for the development libraries *.a *.la
     setup-bin.hint         Client files from usr/bin/
     setup-doc.hint         for the documentation

When command B<[publish]> is run, these setup files and the generated bz2
files are copied to appropriate release directories like this:

    ROOT   ( $CYGBUILD_PUBLISH_DIR/libpackage/ )
    |
    | setup.hint
    | libPACKAGE-N.N-REL.tar.bz2
    | libPACKAGE-N.N-REL-src.tar.bz2
    |
    +-devel
    | libPACKAGE-devel-N.N-REL.tar.bz2
    | setup.hint (was setup-devel.hint)
    |
    +-bin
    | libPACKAGE-bin-N.N-REL.tar.bz2
    | setup.hint (was setup-bin.hint)
    |
    +-doc
      libPACKAGE-doc-N.N-REL.tar.bz2
      setup.hint (was setup-doc.hint)

Take for example a sample garbage collection library, whose name is simply
'gc' available at <http://www.hpl.hp.com/personal/Hans_Boehm>. There
are no executable files in. You should not use the name C<gc> to package
this. The problem is the initial unpack directory name C<gc-6.2.1.6> which
is used to generate the package names. The following is not optimal:

    $ cd /usr/src/build
      ... make sure contains only source file
    $ tar zxvf gc6.2alpha6.tar.gz
    $ cd gc6.2alpha6  gc-6.2.1.6
    $ cygbuild mkdirs files conf make
      ... edit README and setup.hint
      ... Now make binary package for this library
    $ cygbuild package-devel
    -- Making packages [devel] from /usr/src/build/gc-6.2.1.6/.inst
    --   [devel-lib] /usr/src/build/libgc-6.2.1.6-1.tar.bz2
    --   [devel-doc] /usr/src/build/gc-doc-6.2.1.6-1.tar.bz2
    --   [devel-dev] /usr/src/build/gc-devel-6.2.1.6-1.tar.bz2

It would be better to use the C<libgc6> name, as it is used in Debian,
instead of the homepage's name C<gc>, like this:

    ... Unpack as above, but symlink to 'lib' directory
    $ ln -s gc6.2alpha6  libgc6-6.2.1.6
    $ cd libgc6-6.2.1.6
    ... likewise as above for the configure, make etc. and finally ...
    $ cygbuild package-devel
    -- Making packages [devel] from /usr/src/build/libgc6-6.2.1.6/.inst
    --   [devel-lib] /usr/src/build/libgc6-6.2.1.6-1.tar.bz2
    --   [devel-doc] /usr/src/build/libgc6-doc-6.2.1.6-1.tar.bz2
    --   [devel-dev] /usr/src/build/libgc6-devel-6.2.1.6-1.tar.bz2
				    ======

Notice how all released files now correctly include prefix C<libgc6>.

=item B<source-package>

Make source package C<PACKAGE-VERSION-REL-src.tar.b2> to directory
C<.sinst/>. This command will first run B<[clean]> followed by
B<[mkpatch]>. This means that all object files and files that can be
generated will be wiped away as if:

    make clean distclean

was called. So, to build binary package after command B<source-package>
means that the steps have to be started over. Like this:

    cygbuild --release 1 configure make install package

=item B<repackage-all> or B<repkg>

Run commands B<[configure]>, B<[make]>, B<[install]>, B<[check]>,
B<[package]>, B<[readmefix]>, B<[package]>, B<[source-package]> and
B<[publish]>. In other words, this command remakes complete Cygwin Net
release. This is the command to start all from the beginning and go to the
finish. This is needed if files C<package.README> or C<setup.hint> is
changed.

=item B<repackage-bin> or B<repkgbin>

Same as B<repackage-all> but stop after binary package has been made. This
command does not proceed to source package or publishing. Handy in
situations where only binary package needs to be remade after corrective
actions to problems found in installation structure:

    eyeball C<.inst/> directory, fix whatever is needed and
    run command [repackage-bin]

    [repeat] eyeball ./inst ... until looks good.

=item B<repackage-devel> or B<repkgdev>

Like above repackage commands, but for libraries. Run all steps
from beginning to publish.

=item B<readmefix>

Update files in C<CYGWIN-PATCHES/*> to reflect current package's
mainteiner, version and release numbers. E.g. 'Cygwin port maintained
by' and Copyright statements and any C<Firstname Lastname>, C<PKG>,
C<VER>, C<REL> tags are replaced with the correct values (see
ENVIRONMENT). Remember to supply B<--release REL> with this command.

Files with  I<*.tmp> extension are ignored.

=item B<finish>

Remove source unpack directory C<package-N.N/>. This command is
dangerous. It might be better to use C<rm(1)> manually.

Really, user should never run this command. It is mostly reserved for
internal build process testing command B<[all]>.

=item B<publish>

If environment variable C<CYGBUILD_PUBLISH_BIN> is set, the external
program is called with 3 mandatory and 2 optional arguments from options
B<--sign> and B<--passphrase> if those were available. The shell call
will be in form:

    $CYGBUILD_PUBLISH_BIN \
	/directory/where/package-N.N/.sinst/
	<package string>
	<version string>
	<release number>
	[gpg sign id]
	[gpg pass phrase]

If no C<CYGBUILD_PUBLISH_BIN> exists, source and binary packages are copied
under publish directory C<$CYGBUILD_PUBLISH_DIR/package/>.

It makes sense to run publish command only after commands
B<[source-package]> and B<[package]>. If command B<[package-devel]>
was used, then the published files are copied to separate
subdirectories below C<$CYGBUILD_PUBLISH_DIR/package/>. See command
B<[package-devel]> for more information.

=back

=head2 Digital signature commands

=over 4

=item B<sign>

Sign all created packages and the B<*.patch> under directory C<.sinst/>.
Commands B<[package]> and B<[source-package]> can accept sign key option
B<--sign> which add the digital signature to archives after they have been
built. Only if you accidentally remove the C<*.sig> files, or if you forgot
to use signing options, you need to separately call this command.

or archive builds.

=item B<verify>

Verify all signatures belonging to current package in current directory or
in C<.sinst/>.

=back

=head2 Patch management commands

=over 4

=item B<patch>

Apply all I<*.patch> files found recursively under C<CYGWIN-PATCHES/>
to original sources (see command B<patch-list>). The applied patches
are recorded in C<CYGWIN-PATCHES/done-patches.tmp> so that they won't
be applied multiple times.

The directories and filenames are best to be prefixed with a
sequential number, like:

  0001-Makefile-rewrite-install.patch
  0002-command.c-add-ifdef-Cygwin.patch

The filenames can include extra I<strip+N> keyword to instruct what is
the B<--strip=N> option that should be passed to command patch(1):

    <package>-*.strip+N.patch

An example:

    foo-1.2-this-fixes-segfault.strip+2.patch

NOTE: The use of I<strip+N> argument is usually unnecessary, because
the program heuristics can in most cases determine what is the proper
B<--strip> option to B<patch(1)> command.

See also command B<[unpatch]>.

=item B<patch-check|pchk>

Display content of C<CYGWIN-PATCHES/done-patches.tmp> if any and list
filenames from result of command B<[mkpatch]>.

=item B<patch-list|plist>

Display patch list of C<CYGWIN-PATCHES/>. The order is apply order.
Effectively runs command:

    find CYGWIN-PATCHES -name "*.patch" | sort

=item B<unpatch>

Deapply all *.patch files found using find(1), followed by sort(1),
under C<CYGWIN-PATCHES>. On success, the record keeping file
C<CYGWIN-PATCHES/done-patches.tmp> is deleted. The opposite of
B<[patch]> command.

=back

=head2 Other commands

=over 4

=item B<all>

Run all relevant steps: B<prep, conf, build, install, strip, package,
source-package, finish>. This command is used to test the integrity of
Cygwin net release. Like this:

    root@foo:/usr/src/build# tar -xvf package-N.N-1-src.tar.bz2
	package-N.N-1.sh
	package-N.N-1.patch
	package-N.N-src.tar.gz

    root@foo:/usr/src/build# ./package-N.N-1.sh all

If the build process breaks, then the fault is in the packaging.
Contact maintainer of C<package-N.N-1-src.tar.bz2> for details.

=item B<almostall>

Same as command B<[all]> but without the B<[finish]> step.

=item B<cygsrc [-b|--binary] [<--dir|-d>] PACKAGE>

NOTES: 1) This command must be run at an empty directory and 2) No
other command line options are interpreted. This is a stand alone
command.

Download both Cygwin source net release package. If option B<--dir> is
given, create directory with name I<PACKAGE>, cd to it and start
downloading I<PACKAGE>. If option B<--binary> is given, download only
binary package.

This command is primarily used for downloading sources of orphaned
package in order to prepare ITA (intent to adopt) to Cygwin
application mailing list.

  1. The content of *-src.tar.bz2 and setup.hint are store
  2. the *.bz2 is unpacked
  3. the CYGWIN-PATCHES is extracted from *.patch
  4. the rest of the patches (excluding CYGWIN-PATCHES) is stored
     to *-rest.patch

See ENVIRONMENT for changing the download URL location to closer
local Cygwin package mirror site.

=item B<prepare>

This command is not part of the porting commands. It is meant to be used as
a preparation to build Cygwin Net release source package from scratch.
Something like -b option in "source build" commands in C<.deb> and C<.rpm>
packaging managers.

Extract C<package-VERSION-REL-src.tar.bz2> to current directory and apply
patch C<package-VERSION-REL*.patch> and run build command B<[makedirs]>.

=item B<reshadow>

Regenerate all links. Run this command if a) changes are made to the
original source by adding or removing files or b) you've moved the sources
to another directory and the previous links become invalid. Effectively
runs B<[rmshadow]> and B<[shadow]>. Notice that all compile objects files
are gone too, so you need to recompile everything.

=item B<rmshadow>

Remove shadowed source directory recursively. The directory root
is preserved. If you move the original directory to another place, the
shadowed source file links become invalid.

=item B<shadow>

Copy all files from source directory to build directory. The source files
are shadowed by drawing symbolic links to directory C<./build/build>.
The compilation will done there. Usually this command can be replaced with
command C<[reshadow]>.

This command is not usually needed, because the B<[configure]> will notice
missing shadow directory and make it as needed.

=item B<download>

Check upstream site for new versions. External program I<mywebget.pl>
http://freshmeat.net/projects/perlwebget is used to do the download. The
configuration file C<CYGWIN-PATCHES/upstream.perl-webget> must contain URL
and additional parameters how to retrieve newer versions. See
I<mywebget.pl>'s manual for more information. Here is an example
configuration file to download and extract new versions of package:

  tag1: foo
    http://prdownloads.sourceforge.net/foo/foo-0.9.1.tar.bz2 new: x:

=item B<vars>

Print variables and quit. Use this option to see what files and directories
program thinks that it will be using.

=back

=head1 DESCRIPTION

This program builds Cygwin binary and source packages. Refer to I<Cygwin
Package Contributor's Guide> at http://cygwin.com/setup.html for more
information about the details of packaging phase. Due to complex nature of
various source packages out there, it is impossible to completely automate
the packaging steps. Some manual work will always be needed. The hairy
ports are those that have very vague and misbehaving C<Makefile> which
install files to all over the system and distribute copies of files with
cp(1) instead of install(1). Ahem, you as "the porter", know the
drill and have to use your hands to C<Makefile> mud tar pit. Solid
C<Makefile> experience is therefore a requirement before thinking to port
any packages to Cygwin.

If gpg(1) is installed, the patch, binary and source package can be
cryptographically signed. See options B<--sign> and B<--passphrase>.

=head2 Packages with no version number

To port a package which does not have a version number, one has to be
generated out of the blue. Program relies on the fact that the VERSION is
available both in the original package name and in the unpack directory.
The package extensions can be C<.gz>, C<*.bz2> or C<*.tgz>. The recognized
package filename formats include:

    package-N[.N]+.tar.gz                Universal packaging format
    package_N[.N]+.orig.tar.gz           Debian source packages

Like in here:

    foo-1.2.tar.gz, foo-0.0.2.tar.bz2, foo-12.0.2.1.tgz

The package name can consist of many words separated by hyphens:

    package-name-long-N[.N]+.tar.gz         Uses hyphens only
    package_name_invalid-N[.N]+.tar.gz      Underscores not allowed

In case file uses some other naming and numbering scheme, it's a problem.
Similarly if the unpack directory structure does not use universal scheme
C<package-N.N>, it's a problem. Suppose a package unpacks like this:

    $ tar zxvf package-beta-latest.tar.gz
	...
	package-latest
	package-latest/src
	package-latest/doc

The situation can be coped by making a symbolic link to whatever is
appropriate for the version number. If unsure, pick a YYYYMMDD in case
there is no relevant version that can be used for the package.

    $ ln -s package-beta-latest.tar.gz package-YYYYMMDD.tar.gz
    $ ln -s package-latest/ package-YYYYMMDD/

It is important that you do all your work inside the directory with VERSION
number, not in directory C<package-latest/>.

    $ cd package-YYYYMMDD/
    ... now proceed with the porting

=head2 Packages with non-standard versioning schemes

=head2 Packaging directly from version control repositories

It is easy to make build snapshots by using symlinks with time based
version numbers, like C<package-20010123>, which effectively means
YYYYMMDD. To make a release, it could be done like this:

    $ cvs -d :pserver:<remote> co foopackage
    $ date=$(date "+%Y%M%d")
    $ ln -s foopackage foopackage-$date
    $ cd foopackage-$date
    ... proceed to package this snapshot
    $ cygbuild -r 1 mkdirs files conf make install package source-package

=head1 MAKING CYGWIN NET RELEASES

=head2 Preliminary setup

=over 4

1. Create an empty directory, copy original source package there and unpack
it

    $ mkdir -p /tmp/build/
    $ cd /tmp/build                   << go here

    $ rm *
    $ cp /tmp/foo-1.13.tar.gz .
    $ tar zxvf foo-1.13.tar.gz

2. Test and verify that you can compile package. Run C<./configure>,
C<./buildconf>, C<./autogen.sh> or C<./autoconf> (if the package includes
only C<*.in> files) as needed. In case of errors, use Google, search
mailing lists, talk to maintainers and find solutions until you can build
package without errors. Modify the files in place as long as it takes to
get package to build. B<Do not proceed to other steps until the build
succeeds>.

    $ cd foo-1.13/                     << go here
    $ <run ./config or whatever>
    $ <run make(1). Oops, did not work, edit & fix ...>

3. [this step is optional] Take a diff of your current changes and move the
diff file to safe place. Knowing that you are secured in case something
goes wrong, greatly reduces your stress when you know you don't have to
start all from scratch. Alternatively use some source control tool right
from the start.

    <you're at directory package-N.N/>
    $ cygbuild mkpatch
    $ find .sinst/ -name "*patch"    << copy this to safe place

=back

=head2 Now the real thing; making a Cygwin package

=over 4

4. Stay at directory C<package-N.N/> and run few commands, which make
additional Cygwin directories and template files. If this is the first
release, add build release option B<-r 1>. Remember to increase build count
if you make more releases of the same package.

    $ cd /tmp/build/foo-1.13/
    $ cygbuild -r 1 -v makedirs files
			  ==============

Command B<[makedirs]> created three dot-directories which should be
C<foo-1.13/{.build,.inst,.sinst}>. Command B<[files]> wrote few template
files of which two must be modified. The other C<.tmp> files are just
examples they are needed for tricky packages.

    $ cd /tmp/build/foo-1.1/CYGWIN-PATCHES/

Make sure you README and hint files are edited before preceding to building
binary and source packages. If any of the extra scripts are needed, remove
extension C<.tmp> from them to make the scripts active.

    foo.README          Modify this file and fill in the '<Headings>:'
    setup.hint          Modify this file

    install.sh.tmp      optional; if 'make install' does not do it
    postinstall.sh.tmp  optional; things to do after installation
    build.sh.tmp        optional; if 'make all' does not do it

5. Preparations are now ready. It's time to make Cygwin Net release binary
packages. It will appear in directory C<./.sinst>:

   $ cd /tmp/build/foo-1.13/
   $ cygbuild -r 1 -v install strip package
			 =====================

6. Examine carefully the install phase and double check that the created
archive looks correct. Run C<find(1)> to check the directory structure:

   $ cd /tmp/build/foo-1.13/
   $ find .inst/ -print
   $ cygbuild -r 1 -v check      << Run various checks

Did the manual pages (*.1, *.5, *.8 etc.) got installed correctly under
C<usr/share/man/manX/>? How about C<*.info> files at C<usr/share/info>? Are
the libraries C<.a> and C<.la> or C<*dll*> under C<usr/lib>? Are
executables under C<usr/bin>? If everything is not in order, then you need
to study the package's C<Makefile> and fix it to put files in proper
locations.

Here is a shortened listing of a typical library package:

    usr/lib/libgc.la
    usr/lib/libgc.a
    usr/man/man3/gc.3
    usr/share/doc/gc-6.1/README.QUICK
    usr/share/doc/gc-6.1/README
    usr/share/doc/gc-6.1/debugging.html
    usr/share/doc/gc-6.1/gc.man
    usr/share/doc/gc-6.1/gcdescr.html
    usr/share/doc/gc-6.1/leak.html
    usr/share/doc/gc-6.1/tree.html
    usr/share/doc/Cygwin/gc-6.1.README

And here is a shortened listing from a typical executable package:

    etc/postinstall/glimpse.sh
    usr/bin/glimpseindex.exe
    usr/bin/glimpse.exe
    usr/bin/glimpseserver.exe
    usr/share/man/man1/glimpse.1
    usr/share/man/man1/glimpseindex.1
    usr/share/man/man1/glimpseserver.1
    usr/share/man/man1/agrep.1
    usr/share/doc/glimpse-4.17.4/CHANGES

7. Building source packages is much harder, because the program needs to
know more details about configure and build phases. If the default source
packaging command B<[source-package]> does not succeed, you probably have
to guide the process slightly by the shell scripts provided under directory
C<package-N.N/CYGWIN-PATCHES/>. Try this first:

   <your still at directory package-N.N/>
   $ cygbuild -r 1 -v source-package
			 ==============

That's it, if all succeeded. At directory up C<./.sinst> you should see two
complete Cygwin Net release shipments: a binary package and a source
package. The RELEASE number is the result of the B<-r> option.

    foo-1.13-1.tar.bz2
    foo-1.13-1-src.tar.bz2

=back

=head2 Contributing packages

Refer to "Submitting a package" at http://cygwin.com/setup.html for
full description.

To contribute your package, place them somewhere available and send message
to <cygwin-apps@cygwin.com> with following message. The ITP acronym used is
borrowed from Debian and it means "intent to package":

    Subject: [ITP] package-N.N

B<Package submittal:> Include contents of C<setup.hint> and the binary
package listing C<tar jtvf foo-1.13-RELEASE.tar.bz2>. Provide complete to a
ftp/http server download links to package files where they can be
downloaded when you submit a contributed package.

B<Licensing:> As a package maintainer, the licensing responsibility is on
your shoulders. If the upstream package's license if not OSD compatible
(see <http://www.opensource.org/docs/definition_plain.html>) there may be
problems, as the Cygwin glue code (libcygwin.a) is linked in on all
cygwin-targets, thus rendering the compiled result GPL'd (see
http://www.cygwin.com/licensing.html ), unless the license is OSD
approved (see <http://www.opensource.org/licenses/>).

The Cygwin net release is a volunteer effort. If you, the volunteer, do not
feel comfortable with the licensing, then ask for advice on the cygwin-apps
mailing list.

B<TTL; Time To Live:> If a submitted package has been on the pending
packages list for two months or more, without receiving any votes or no
follow-ups (when requested) it may be dropped from the list. You can
re-submit your package again at a later time, if you choose to do so.
Packages that are already included in major Linux distributions like
Debian, Ubuntu, Redhat, SUSE, Gentoo, Slackware do not need voting
procedure. Mention the link to the distribution page where package is
maintained.

B<Publishing:> In case you're running Apache web server and world known IP
address, you can publish your files to the world directly. Add this line to
your C<httpd.conf> and make apache(1) read configuration again with
I<apachectl restart>. Check that your connection can see the files with
lynx(1).

    Alias /cygwin /usr/src/cygwin-packages

As a finishing touch, there is command command B<[publish]> which copies
ready source package, binary package and setup.hint to publish area:

   <you're still at directory package-N.N/>
   $ cygbuild publish

=head1 GPG EXAMPLES

Let's assume that you have added following build alias command to your
C<~/.bashrc>:

    alias cb="cygbuild --color --sign $GPGKEY"

You don't want the second alias presented below to be stored in
permanent places, because it contains your GPG identification details.
Copy/paste if to opern terminals as needed.

    $ alias bb="cygbuild -s gpg-key-id -p 'gpg-password'"

Assuming there already unpacked original package, which has been tested to
build correctly, it's a simple matter of making GPG signed releases.
Perhaps there is something in C<*.README> that needs some correction or
final words. Maybe it had typos. Or C<setup.hint> needed updating. Okay,
run this to make new install which replaced older C<*.README> file:

    $ cd foo-1.13/
    $ cb -r 1 -v install check

Look closely at the results of check command. If anything needs to be
edited or corrected, repeat the command after edit. Verify the
installation:

    $ find .inst/ -print | sort

If all looks good, the signed packages can be made. If you don't have gpg
installed, then substitute plain "b" instead of for "bb" below:

    $ bb -r 1 package source-package

In case there is permanent Internet connection where files can be put to a
publish area (Apache, Ftp), the last step copies packages elsewhere on
local disk:

    $ bb 1 publish

=head1 OPTIONAL EXTERNAL DIRECTORIES

All files in I<CYGWIN-PATCHES/bin> are installed as executables into
directory C<.inst/usr/bin>. The location can be changed if any of the
files contains tag B<cyginstdir:> to point to new location. An example:

    #!/bin/sh
    # cyginstdir: /bin
    ...

=head1 OPTIONAL EXTERNAL FILES

The following list of scripts is alphabetically ordered. The name of
the script indicates when it is run or which command runs it. All
files in C<CYGWIN-PATCHES/> that have suffix C<.tmp> are temporary
templates and not used.

=over 4

=item B<build.options>

If this file exists, it is sourced to read custom flags and other I<make(1)>
options. The content of the file should be like this. These are the default
values

  CYGBUILD_CFLAGS="-O2 -g"
  CYGBUILD_LDFLAGS=""          # set to -no-undefined for libraries
  CYGBUILD_MAKEFLAGS="CC=gcc CXX=g++"

And they are used in a call to initialize C<make(1)> variables in call like
this:

  make CFLAGS="$CYGBUILD_CFLAGS"   \
       LDFLAGS="$CYGBUILD_LDFLAGS" \
       $CYGBUILD_MAKEFLAGS

=item B<build.sh>

Perhaps simple C<make all> did not compile the package. In that case a custom
C<CYGWIN-PATCHES/build.sh> can be used to give correct options and
commands:

   1. chdir has been done to a source directory package-N.N/
   2. Script receives three arguments: package name, version and
      release number.

    make ... whatever options are needed ...
    make ... perhaps it need other targets as well ...

=item B<configure.env.options>

If this file exists, it is sourced to read custom environment settings just
before C<./configure> is being run.

    source configure.env.options

For example to use B<ccache gcc> with autotool packages (these with
configure.in, Makefile.am etc) to speed up compilation, there is example
script C<CYGWIN-PATCHES/compiler.sh.tmp> which you can take into use by
removing the C<.tmp> extension. After put this line to the file. Notice
that there is no path in front of C<compiler.sh> because during the
execution the B<PATH> variable will include also C<CYGWIN-PATCHES/>.

    # Start of CYGWIN-PATCHES/configure.env.options
    CYGBUILD_CC=compiler.sh
    # End of file

=item B<configure.options>

If this file exists, all options in this file are appended to the default
Cygwin options set during call to C<./configure>. Comments may be added to
preceding lines with a hash-mark. An example:

    # Include these options during configure:
    --disable-static        # Do not use static libraries
    --enable-tempstore
    --enable-threadsafe
    --with-tcl=/usr

=item B<configure.sh>

In case the package does not include a standard GNU C<./configure>
script, a custom script C<CYGWIN-PATCHES/configure.sh> can guide all
configure steps. If there is nothing to configure, leave this script
out. For the custom program:

   1. chdir has been done to a source directory package-N.N/
   2. Script receives one argument: absolute path to install root
      directory (that'd be <path>/package-N.N/.inst)

To start with the custom script, here are the standard Cygwin configure
switches, which you can incorporate:

    ./configure
	--target=i686-pc-cygwin
	--srcdir=/usr/src/cygbuild/package/package-N.N
	--prefix=/usr
	--exec-prefix=/usr
	--sysconfdir=/etc
	--libdir=/usr/lib
	--includedir=/usr/include
	--localstatedir=/var
	--libexecdir='${sbindir}'
	--datadir='${prefix}/share'

=item B<diff.options>

By default the C<[patch]> command excludes files that it thinks do not
belong there, but in many case package generate other extra files that
should be excluded too. In this file it is possible to supply extra options
to C<diff(1)> while comparing the original source directory against the
current package directory. The options to diff must be listed one line at a
time. Comments can start with hash-character.

    # diff.options -- exclude these files from patch

    --exclude=Makefile.in
    --exclude=Makefile

    # End of file

There a re couple of options that affect cygbuild itself. If following
option is found, then no automatic guessing what files might have been
auto-generated, is done. This is effectively a pseudo option that
says "turn off internal check":

    --exclude=cygbuild-ignore-autochecks

To completely suppress all default cygbuild exclude options like those
of C<*.~, *# *.orig> and other files), start the file with use this
line:

    --exclude=cygbuild-ignore-all-defaults

B<Warning:> due to shell expansions in the program, it is not possible
to use wildcards with short option names, like this:

    -x *.tmp

Please use the long option notation instead:

    --exclude=*.tmp

=item B<diff-before.sh>

When the original source has been unpacked, it may include files that
prevent taking clean diff. IT could happen that the source package
mistakenly included compiled object files or included dangling symlinks to
the original authors files. This is the chance to "straighten up" things
before diff engages.

=item B<diff.sh>

Sometimes the default B<[mkpatch]> command - which runs C<diff(1)> with
conservative set of options - is not enough. If package uses many different
file extensions, a custom C<CYGWIN-PATCHES/diff.sh> program can be used to
produce correct differences. The custom program is called with three
arguments:

    1. Original package root directory
    2. Modified package root directory
    3. Output file (will be under CYGWIN-PATCHES/.sinst/)

Program should not change any of these parameters, but only adjust only
C<diff(1)> options. Program must return standard shell status 0 on success
and non-zero on failure.

An example is presented below. For GNU C<diff(1)>, don't forget to add the
final C<[ "$?" = "1" ]> statement, which converts the GNU diff ok exit
status 1 to a standard shell ok exit status 0. GNU diff returns
unconventionally 1 on success and N > 1 on error.

    #!/bin/sh
    # CYGWIN-PATCHES/diff.sh -- custom diff

    diff -urN $1 $2             \
	    --exclude='.build'  \
	    --exclude='.inst'   \
	    --exclude='.sinst'  \
	    --exclude='*.o'     \
	    --exclude='*.a'     \
	    --exclude='*.dll'   \
	    --exclude='*.exe'   \
	    --exclude='*.bak'   \
	    --exclude='*.tmp'   \
	    --exclude='*~'      \
	    --exclude='*#'      \
	    --exclude='.#*'     \
	    --exclude='.hg'     \
	    --exclude='.bzr'    \
	    --exclude='.git'    \
	    --exclude='CVS'     \
	    --exclude='RCS'     \
	     ...[your options here]...\
    > $3

    [ "$?" = "1" ]
    # End of file

=item B<install.sh>

This script is for binary packaging commands B<[package]> and
B<[package-devel]>.

If a Makefile (run by C<make install>) includes hard coded paths or uses
cp(1) to copy files, to absolute locations, a custom installation procedure
may be needed. It would also help if the author of the original package were
contacted and suggested that a possible new releases of package would lean
to use install(1) and Makefile variables. Those could be set externally and
controllable manner.

Examine the Makefile and its installation rules and write a script to mimic
same steps. When custom script is called:

  1. chdir has been done to source root package-N.N/
  2. it receives one argument: relative root of
     installation directory .inst/

Be careful and double check the file locations after your custom install.sh
has been run:

  $ cd package-N.N/
  $ find .inst/ -print      << print directory structure

When the final binary package is installed by some user, it must not
unintentionally overwrite anything that is already in the system.

B<NOTE:> Instead of this file, it would be much better to gets hands dirty
and modify directly the original C<Makefile>. Even if that meant writing
the whole installation from scratch. Copy install example from template
file C<CYGWIN-PATCHES/Makefile.tmp>.

=item B<install-after.sh>

This script is for binary packages commands B<[package]> and
B<[package-devel]>. If this script exists, it is called after
cygbuild has run it's standard installation steps.

Sometimes there is no need to write full custom C<install.sh>, but only
combine efforts of packages standard command "make install" with a little
cleanup afterward. For example, suppose that after packages "make install"
the directory structure would look like this (listing has been condensed):

    /tmp/build/foo-1.13$ find .inst/ -print
    .inst/
    .inst/usr
    .inst/usr/share/doc
    .inst/usr/share/doc/foo-1.13
    .inst/usr/share/doc/foo-1.13/AUTHORS
    .inst/usr/share/doc/foo-1.13/BUGS
    .inst/usr/share/doc/foo-1.13/INSTALL
    .inst/usr/share/doc/foo-1.13/NEWS
    .inst/usr/share/doc/Cygwin
    .inst/usr/share/doc/Cygwin/foo-1.13.README
    .inst/usr/lib
    .inst/usr/lib/libfoo.la
    .inst/usr/lib/libfoo.a
    .inst/usr/lib/pkgconfig
    .inst/usr/lib/pkgconfig/foo.pc
    .inst/usr/include
    .inst/usr/include/foo
    .inst/usr/include/foo/ne_request.h
    .inst/usr/bin
    .inst/usr/bin/foo-config
    .inst/usr/share
    .inst/usr/share/man/man3
    .inst/usr/share/man/man3/ne_add_request_header.3
    .inst/usr/share/man/man3/ne_addr_destroy.3
    .inst/usr/share/man/man1
    .inst/usr/share/man/man1/foo-config.1
    .inst/usr/share/doc
    .inst/usr/share/doc/foo-1.13
    .inst/usr/share/doc/foo-1.13/html
    .inst/usr/share/doc/foo-1.13/html/apas01.html

Does everything look good? No. Documentation appears to be installed twice.
In this case it is due to fact that cybuild.sh always runs it's own default
install for files under package's C<doc/> directory. But if run "make
install" also does the same, it's a problem as in this case. The target
directory was just a little different. The documentation must appear in
directory C<usr/share/doc/> and not C<usr/doc/> over, so the
C<install-after.sh> script's work is to remove the extra files:

    #!/bin/sh

    rm -rf .inst/usr/doc

    # End of file

=item B<install.env.options>

The B<[install]> csommand runs series of install phases. After all the
Cygwin documentation is copied to directory C</usr/share/doc/foo-1.12>, the
standard C<make install> phase is run. If you need to set any environment
variables or arrange other things, do it in this file. It will be called
like

    source install.env.options

If you need exotic 'make install' options, this is the place to configure.
For example, if C<Makefile> does not use I<DESTDIR> option, but a variable
I<INSTALLROOT>, you can add that to 'make install' by defining generic
C<CYGBUILD_MAKEFLAGS> make option. This works, because variables
C<$instdir> and C<$PREFIX> are set in the program and contain the needed
information.

    # Start of CYGWIN-PATCHES/install.env.options
    CYGBUILD_MAKEFLAGS="INSTALLROOT=$instdir$PREFIX"
    # End of file

=item B<install.tar.options>

The B<[install]> command runs series of install phases. In the first, The
Cygwin documentation for package directory C</usr/share/doc/foo-1.12> is
populated from files in the original package. Those of INSTALL, COPYRIGHT
and README are copied. Then any C<doc/> directory if it is included. The
default rules exclude most common files MANIFEST, *.bak, *.rej etc. and
version control subdirectories.

In this file it is possible to supply extra tar options to exclude more
files not to be included. Perhaps package's C<doc/> directory contains
subdirectories that are targeted to software developers porting the
software etc. The format of file is presented below. Empty lines are
ignored. Comments must be placed in separate lines.

    # install.tar.options -- exclude these files from documentation

    --exclude=*RISC*
    --exclude=*README.vms

    #  Include files
    --include=notes.txt

    # End of file

If following option is defined, the automatic detection of possible
documentation directory is suppressed. Standard options like
B<--include=dir> are still obeyed.

    --exclude=cygbuild-no-docdir-guess

If following option is defined, only standard COPYING, TODO etc. files
found from top-level source directory are installed. No other
directories.

    --exclude=cygbuild-no-docdir-install

=item B<mandir>

If this file exists, it should contain only one line: the dorectory
name relative to CYGWIN-PATCHES where the manual pages are stored. An
example (which is also the default location):

   $ cat CYGWIN-PATCHES/mandir
   manpages

This instructs to read manual pages from subdirectory
C<CYGWIN-PATCHES/manpages/> instead of root of C<CYGWIN-PATCHES/>.

=item B<manualpage.1.pod>

In case package does not include manual page or pages for certain
binaries, this file can be used as a template for manual pages. The
format is Perl's plain old documentation (pod) and the file itself is
self explanatory. Just fill in the text and rename the file according
to binaries that are documented. The page number is automatically read
from file name:

       X11 programs use section "x"
				  |
   cp manualpage.1.pod  xprogram.1x.pod
   cp manualpage.1.pod  program.8.pod
      |                 |
      Template file     copy to <program>.<section>.pod

The typical sections are:

   1  Normal binaries
   5  Configuration files
   8  Administrative binaries: /sbin

Here are some markup help to use in C<*.pod> files. See more
information by running C<perldoc perlpod> or visit
http://perldoc.perl.org/perlpod.html

  B<bold text>
  I<italics>
  C</some/file/name.here>

The I<*.pod> files can be put to separate directory
C<CYGWIN-PATCHES/manpages>.

=item B<package-bin.sh>

If a single standard binary packaging command B<[package]> or library
packaging command B<[package-devel]> methods are not suitable, it is
possible to write a custom script. There may be need for separating files
into different tar.bz2 files etc. When custom script is called:

  1. chdir has been done to installation directory
     CYGWIN-PATCHES/.inst/

  2. script receives 4 arguments:
     PACKAGE VERSION RELEASE TOPDIR

The C<TOPDIR> is the location where the script should place the I<tar.bz2>
files. It is typically directory above the sources: package-N.N/..

=item B<package-source.sh>

A custom script for making source packages. The call syntax and behavior is
same as C<package-bin.sh> explained above.

=item B<postinstall.sh>

This file is for command B<[package]>, which makes binary packages. The
C<postinstall.sh> is run when user installs Cygwin Net release package in
his system. Here you can clean, move or copy files, check environment and
do other things as needed. Postinstall scripts should assume that C<PATH>
is I<unset>, and all executables should be explicitly specified or the
patch must be set explicitly in script.

=item B<prepare.sh>

A custom script to run when package is prepared. Commands B<[all]> and
B<[prepare]> run the script. The purpose is to arrange everything to
be ready for the B<[configure]> and B<[make]> commands.

Normally command B<[clean]> would be run along with the standard
preparations. The purpose of the clean is to make sure the source package
did not mistakenly include compiled files. If it did, that would later
prevent 'make' command to do nothing. Doing clean, makes it all pristine.

=item B<preremove.sh>

Copy this file as C<.inst/etc/preremove/foo.sh>. It will be called just
before the package is uninstalled (setup.exe uninstalls the old version
before installing the upgraded version).

=item B<preremove-manifest.lst>

If I<postinstall.sh> file copies any default setup files to C</etc>
directory, the absolute path names of files (one or many) must be listed
here. See topic I<CYGWIN PACKAGE POLICY NOTES::Using preremove.sh and
postinstall.sh for upgrading /etc files>.

=item B<preremove-manifest-from.lst>

This file is used by I<preremove.sh>. Contains B<list> original
configuration files that are copied to locations mentioned in
I<preremove-manifest.lst> file. A special tag C<#PKGDOCDIR> can be used to
refer to the latest installed directory of
C</usr/share/doc/package-version>.

An example. Content of C<preremove-manifest.lst> lists the target file that
contains the site wide setup:

    /etc/foo.conf

The previous version of package C<foo> has put documentation in directories:

    ...
    /usr/share/doc/foo-1.2
    /usr/share/doc/foo-1.3
    /usr/share/doc/foo-1.4

so the site wide configuration file could had come from the last
directory. Let's suppose upstream has put the example in:

    /usr/share/doc/foo-1.4/examples/foo.conf

When new version of package is about to be installed by I<setup.exe>, the
I<preremove.sh> script can examine if the system wide setup file(s) pointed
by C<preremove-manifest.lst> hasn't been changed from the package's
upstream examples listed in <preremove-manifest-from.lst> which now can
simply read:

    $PKGDOCDIR/examples/foo.conf

The special tag C<#PKGDOCDIR> is just a shorthand pointer to the latest
documentation directory. If these two files do not differ, the
<preremove.sh> can safely delete C</etc/foo.conf> and let the
C<postinstall.sh> to install new file from upstream source that is
mentioned in <preremove-manifest-from.lst>. This effectively means:

    preremove: if files listed in C<preremove-manifest.lst>
       have not been changed, remove them.

    postinstall: if there are no files that are listed in
	C<preremove-manifest.lst> file then install new upstream files
	pointed by <preremove-manifest-from.lst>

=item B<publish.sh>

A custom script to publish package.

=back

=head1 MANAGING A BUILD TREE

=head2 How to organize Cygwin Net Release builds

If you intend to port many packages to Cygwin, a good directory structure
helps keeping things organized. Suppose you have 3 packages (foo, bar,
quux) of which 2 have been updated twice (there has been two ported
releases):

    ROOT/           ( /usr/src/cygwin-build )
    |
    +--foo/         ( /usr/src/cygwin-build/foo )
    |  +--foo-1.3/
    |  +--foo-1.4/
    |  |
    |  foo-1.3.tar.gz
    |  foo-1.3-1.tar.bz2
    |  foo-1.3-1-src.tar.bz2
    |  |
    |  foo-1.4.tar.gz
    |  foo-1.4-1.tar.bz2
    |  foo-1.4-1-src.tar.bz2
    |
    +--bar/
    |  +--bar-3.12/
    |  +--bar-3.17/
    |  |
    |  bar-3.12.tar.gz
    |  bar-3.12-1.tar.bz2
    |  bar-3.12-1-src.tar.bz2
    |  |
    |  bar-3.17.tar.gz
    |  bar-3.17-1.tar.bz2
    |  bar-3.17-1-src.tar.bz2
    |
    +--quux/
       +--quux-2.2/
       |
       quux-2.2.tar.gz
       quux-2.2-1.tar.bz2
       quux-2.2-1-src.tar.bz2

At first sight this may look complex, but with this structure you can
manage several packages easily. For each package, reserve a separate
directory where you do your work: C<foo/>, C<bar/>, C<quux/> etc. Download
original packages to these directories and unpack the sources. Let's examine
package C<foo>

    $ cd /usr/src/cygwin-build/foo
    $ wget <URL>/foo-1.4.tar.gz

After unpack, you should see a clean directory name:

    $ tar zxvf foo-1.4.tar.gz

    foo-1.4/

Sometimes the packages unpacks to an uncommon directory:

    foo1.4b/

Use previously recommended symlink approach to convert the name into more
standard form. Here the 'b' is minor release '2':

    $ ln -s foo1.4b/ foo-1.4.2/

There isn't much to do after that. You do your builds in the unpack
directories as usual. Supposing this is "standard" looking GNU package
which includes a C<./configure>, making a Net release should be as simple
as running:

    $ cd foo-1.4/
    $ cygbuild files

    ...  Now edit files in CYGWIN-PATCHES/

    $ cygbuild configure make install

    ... Verify install results

    $ find .inst/

    ... If all look okay, make binary and source Net releases

    $ cygbuild -r 1 install package readmefix install package source-package

With these commands, Cygwin Net release packages are copied one directory
up to the same place where the original compresses source kit is:

    /usr/src/cygwin-build/foo/foo-1.4-1.tar.bz2
    /usr/src/cygwin-build/foo/foo-1.4-1-src.tar.bz2

If you have a web server that can serve the package, copy the files to
publish area with command:

    foo-1.4$ cygbuild publish

=head2 Rebuilding packages

NOTE: This section is highly experimental and the program has not yet been
tested well. (FIXME)

As Cygwin is improved, the main library file C<cygwin1.dll> may change and
periodically all packages must be rebuilt so that they link to the latest
function calls. In this case you have to rebuild every package you
maintain. Instead of going to every directory and typing the relevant
"cygbuild clean conf make install ..", there is a helper script that
automates the task. If you use the standard build layout as described in
previous topic, you can use rebuild script to do the steps. Is is also a
good chance to verify that the package build process is repeatable:

    $ cygbuild-rebuild.sh -d /usr/src/cygwin-build -i 1 2>&1 | tee build.log
			   |                       |
			   |                       increase releases by 1
			   |
			   directory where to start recursive build

If something goes wrong, you have to manually fix the package. Do not run
the rebuild script again until you have fixed the build process for a
broken package.

=head1 LIBRARY USAGE

In addition to I<cygbuild> being a builder program, it can be used as a
library that can be sourced to any bash program. This makes it possible to
selectively use functions in it. The library feature is enabled by setting
variable C<CYGBUILD_LIB> before C<source> command. When invoked this way,
the I<cygbuild's> C<Main()> function in not invoked and options or
commands are bypassed.

B<WARNING:> All the functions are name space clean and contain prefix
B<Cygbuild*>, but many global variables are defined that do not
include the prefix: C<$instdir>, C<$builddir> etc.

To get access to full power of the functions, these steps are needed:

    #!/bin/sh

    CYGBUILD=$(which cygbuild)

    #   Load "as library"

    CYGBUILD_LIB=1 source $CYGBUILD

    #   Provided that the current directory's PWD is inside
    #   some/path/foo-1.13. If not, then please skip this part
    #   completely.

    local tdir=$(pwd)
    local -a array=( $(CygbuildSrcDirLocation $tdir) )
    local top=${array[0]}
    local src=${array[1]}

    CygbuildDefineGlobalMain    \
	"$top"                  \
	"$src"                  \
	"$RELEASE"              \

    #   Now any function can be called. Like installing documentation

    CygbuildInstallPackageDocs
    CygbuildInstallCygwinPart

    #   End of example

=head1 CYGWIN PACKAGE POLICY NOTES

=head2 Using preremove.sh and postinstall.sh for upgrading /etc files

The /etc directory is meant for configuration files for programs. The first
installation typically copies the package's default setup file there but
subsequent installations won't overwrite existing files in order to
preserve user's modifications. If new version of the package includes new
features, those are not found from the "old" /etc configuration files.

Let's suppose user has not yet modified system wide configuration file
C</etc/foo.conf> and package includes newer one in
C</usr/share/doc/foo-1.2/foo.conf.example>. In this case the installation
should copy the new example file over C</etc/foo.conf> to reflect possible
new features in the program.

The trick is to include a I<preremove.sh> script in the Cygwin Net Release
binary package. A file named C</etc/preremove/foo.sh> will be called just
before the package is uninstalled (setup.exe uninstalls the old version
before installing the upgraded version), so in that script, if
C</etc/foo.conf> exists and is identical to
C</usr/share/doc/foo.conf.example>, the I<preremove.sh> should delete it
and let I<postinstall.sh> install new one. If the C</etc/foo.conf> is
modified, it must be left alone.

Also, it is a good idea to have a file C</etc/preremove/foo-manifest.lst>,
which lists every file that was created by the I<postinstall.sh> script,
and which will be removed on I<preremove.sh> if untouched by the user.
Someday, C<cygcheck -c> might parse the manifest lists to help diagnose if
postinstall has not completed.

=head2 Music file formats *.mp3, *.ogg etc.

It is allowed to include any music related code if MP3 related code is not
compiled in (cf.
 http://permalink.gmane.org/gmane.os.cygwin.applications/11360 )

As long as Cygwin is released on US based server, the general rules
are that it is permissible to include and not include in Cygwin are
basically the same as for the Fedora project
<http://fedoraproject.org/wiki/ForbiddenItems>:

  * If it is proprietary, it cannot be included in Cygwin.
  * If it is legally encumbered, it cannot be included in Cygwin.
  * If it violates US Federal law, it cannot be included in Cygwin.

This is different from SUSE and Debian. SUSE is located in another
country may even pay royalties. Debian has a different legal point of
view than Red Hat
(cf. <http://lists.debian.org/debian-legal/2005/07/msg00081.html>). Due to
Cygwin's presence on a Red Hat server, the project is bound to Red Hat
rules.

=head1 TROUBLESHOOTING

=head2 Porting and Python os.rename

If python application contains calls to I<os.rename(from, to)> or
I<osutils.rename(from, to)>, these will cause unlock race
condition under Cygwin.

  OSError: [Errno 13] Permission denied

Please contact the upstream to negotiate how to solve this. One possible
solution is to rewrite all calls to:

    import os, shutil

    def saferename(a, b):
	shutil.copy2(a, b)
	os.unlink(a)

=head2 General errors

Make always sure that you work inside well formed source directory
C<package-VERSION/>, like C<foo-1.13/>. If you issue command anywhere
else, the program does not know where it is.

=head2 Problem with command [all]

If you get an error, make sure that you have a clean build directory.
Nothing else other than:

    1. a source file
    2. a possible patch to make package work under Cygwin

The B<[all]> is special and it should not be run only for testing already
packages Cygwin Net Releases. It unpacks and patches the source package. If
any other commands are run patch may be tried to apply second time which
naturally fails and script execution stops. Something like

    The next patch would create the file ...
    which already exists!  Skipping patch.
    1 out of 1 hunk ignored -- saving rejects to file ...
    [FATAL] status is 1.

Start all from fresh. Remove unpack directory C<rm -rf package-N.N/> and
repeat command B<[all]>.

=head2 Command [check] cannot find files

The full error reads something like this:

    cygbuild.pl.CygcheckDepsCheckMain: Nothing to do, no *.exe *.dll found in /usr/src/build/package/package-5.07/.inst

Command B<[check]> was ran, but commands B<[conf]> B<[make]> and
B<[install]> were not. The B<[install]> phase copies files under C<.inst/>
directory where the B<[check]> command expects them.

=head2 Problem with command [install]

Following error is displayed:

    $ cygbuild -v -r 1 package

    [ERROR] no package-0.5/.inst/usr/share/doc/Cygwin.
    Did forget to run 'files' before 'install'?

The check did not find anything inside
C<.inst/usr/share/doc/Cygwin> which is mandatory directory for Cygwin
binary packages. Check that directory C<package-N.N/CYGWIN-PATCHES/>
includes files C<package.README> and C<setup.hint>. These files can be
initially created with command B<[files]>.

=head2 Command [package] displays warnings

Following warning while making a binary package is displayed:

    -- Wait, reading and preparing variables based on current directory
    -- Hm, no *.exe or *.dll files, skipping strip.
    /usr/src/build/ask/package-1.1/.inst/usr/share/doc/Cygwin/package.README:1:<PKG>
    /usr/src/build/ask/package-1.1/.inst/usr/share/doc/Cygwin/package.README:24:  unpack <PKG>-VER-REL-src.tar.bz2

The warning means, that file C<CYGWIN-PATCHES/package.README> looked
like a template. Edit C<package.README> file and leave all <PKG>, <VER>
and <REL> tags alone. Then run command B<[readmefix]> which will substitute
proper values for these tags.

=head2 While making source package, the mkpatch step dies with an error

Program uses predefined set of ignore rules to exclude binary files
from the difference comparison. There is always a possibility that the
package you compiled generated binary files that are unknown. In those
cases, examine the diff output carefully hinted by message:

    [ERROR] Making a patch failed, check /usr/src/foo-N.N/.sinst/foo-*.patch

Run following command to determine the problematic files in the
diff(1) listing:

    $ egrep -n -i 'files.*differ' /usr/src/foo-N.N/.sinst/foo-*.patch

Add problematic file patterns file F<CYGWIN-PATCHES/diff.options> or
in difficult cases write custom C<CYGWIN-PATCHES/diff.sh> script. See
section "Optional external scripts" for more information.

=head1 ENVIRONMENT

Default values for command B<[install]>:

    CYGBUILD_INSTALL=/usr/bin/install
    CYGBUILD_INSTALL_DATA="-m 644"
    CYGBUILD_INSTALL_BIN="-m 755"

Default values for command B<[publish]>:

    CYGBUILD_PUBLISH_DIR=/usr/src/cygwin-packages
    CYGBUILD_PUBLISH_BIN=

Default values for command B<[readmefix]> are below. The lines below mean
that if C<CYGBUILD_FULLNAME> is not set, the C<NAME> is tried, and last Debian
C<DEBFULLNAME> variable. See also option B<--email>.

    CYGBUILD_FULLNAME || NAME
    CYGBUILD_EMAIL    || EMAIL

Default values for command B<[cygsrc]>. The value must point to
URL directory where Cygwin Net Release setup.ini file resides.

    CYGBUILD_SRCPKG_URL=http://mirror.switch.ch/ftp/mirror/cygwin

Temporary values can be given from /bin/bash prompt like this:

    bash$ EMAIL=me@example.org cygbuild [options] -r RELEASE <commands>

=head1 FILES

Temporary files are created to C</tmp/cygbuild.tmp.*>. They are removed at
the end of program.

Command B<[files]> creates template files under C<./CYGWIN-PATCHES>.
Default templates are located in directory
C</usr/share/cygbuild/template>. Developer's own templates can
be placed in directory C</etc/cygbuild/template>. These overwrite those in
C</usr/share/cygbuild/template>.

=head1 STANDARDS

Cygwin Package Contributor's Guide' at http://cygwin.com/setup.html .
Remember to compile libraries using B<-Wl,--enable-auto-image-base>
Cf. 2005-12-19 <http://cygwin.com/ml/cygwin-apps/2005-12/msg00101.html>.

A generic Bourne Shell build script can be found at page
http://cygwin.com/setup.html and also available at

  cvs -d :pserver:anoncvs@sources.redhat.com:/cvs/cygwin-apps checkout packaging/templates

Consult list of packages before intent to port [ITP]: See file
/etc/setup/installed.db or oage <http://cygwin.com/packages/>.

File system Hierarchy Standard at <http://www.pathname.com/fhs/>

=head1 BUGS

=head2 Commands must be ordered

The application does not check the sanity of the command line
arguments. For example running commands in wrong order. It makes no
sense trying to make a binary I<package> before the package has been
built or installed.

   cygbuild -r 1 package conf make install

The commands are always executed in listed order.

=head2 Other archive formats like *.zip are not recognized

This porting tool only handles C<*.tar.gz>, C<*.tar.bz2>,
C<*.tar.lzma> archives. To port e.g. a C<*.zip> archive, you need to
manually convert it to recognized format:

    unzip foo-N.N.zip
    tar -cvf foo-1.1.tar.gz foo-N.N/
    ... Now proceed normally
    cd foo-N.N/
    cygbuild -r 1 mkdirs files conf make install

=head2 Reporting bugs

If you ran into a bug, run script in debug mode and send complete
output listing to the maintainer. Provide also an URL link to the
source package that you tried to build.

    $ echo http://example.com/source      >  ~/tmp/error.log
    $ pwd; ls -la . ..                    >> ~/tmp/error.log
    $ bash -x cygbuild [options] CMD ...  >> ~/tmp/error.log 2>&1

=head2 Slow program startup

You may notice that the startup is a little slow. This is due to way
the program determining what many global variables need to be
available at runtime. The method of checking environment is not
particularly efficient (due to bash-scripting limitations in general).
E.g. same checks of version and release numbers are called multiple
times.

=head1 MISCELLANEOUS

=head2 Makefiles and compiling libraries

To compile libraries for Cygwin, the C<LDFLAGS> should include option
C<-no-undefined>. If there is C<Makefile(.in|.am)>, after patching
them manually, you can regenerate the Makefiles with

    $ autoreconf --install --force --verbose

=head2 yacc or lex file compiling notes

Sometimes the C<*.y> file won't compile. See thread "ftpcmd.y --
syntax error" at
<http://lists.gnu.org/archive/html/help-bison/2004-04/msg00015.html>.

    bison -y ftpcmd.y
    ftpcmd.y:185.17: syntax error, unexpected "="

    ...There are occurrences of "<tab>=<tab>{" in ftpcmd.y (in the
    wu-ftpd 2.6.2 source release). Changing all of these to "<tab>{"
    fixes the problem -- and doesn't cause problems for Berkeley yacc,
    or for earlier versions of bison.

=head2 Cygwin postinstall script conventions

If program X's C<postinstall> is doing a C<cp>, it does not preserve the ACL
permissions. The C<postinstall> script must be accompanied with C<touch(1)>
to create the new file before copying unto it or a call to C<chmod> to set
reasonable permissions after the copying. If that's not done, the user may
end up having unreadable files. NOTE: C<cp -p> will not work, but C<install
-m> would.
(Cf. <http://cygwin.com/ml/cygwin-apps/2005-01/msg00148.html>).

=head2 Use of hard links

Some ported packages may rely on hard links. Those are efficient only
under NTFS and not FAT. Please include note to <package>.README that
the utility may not be best under FAT file systems.

=head2 setup.hint should list all dependencies

The I<requires:> line is not only an indication of what to pull in,
but also what the package actually uses. These dependences are also
used to find the order of postinstall scripts (so, if package has any
postinstall scripts with C<#!/bin/sh>, the scripts may not work
because the bash postinstall script was not run). So include all
direct dependences in the I<requires:> line, even if they are in
B<Base> category.
(Cf. <http://cygwin.com/ml/cygwin-apps/2008-03/msg00070.html>).

=head1 AVAILABILITY

http://freshmeat.net/projects/cygbuild

=head1 OSNAMES

Cygwin

=head1 SEE ALSO

cygport(1)
gpg(1)

=head1 AUTHOR

Copyright (C) 2003-2009 Jari Aalto. This program is free software; you
can redistribute and/or modify program under the terms of Gnu General
Public license v2 or, at your option, any later version.

=cut

sub Help (;@)
{
    local ($ARG) = @ARG;

    #   The name will be "-e" if this is included as a libraly like:
    #
    #       "require qq(cygbuild.pl)"

    return if $PROGRAM_NAME =~ /^\s*$|^-/;

    if ( /html/ )
    {
	pod2html $PROGRAM_NAME;
    }
    elsif ( /man/ )
    {
	eval "use Pod::Man";
	$EVAL_ERROR  and  die "Cannot generate Man $EVAL_ERROR";

	my %options;
	$options{center} = 'Cygwin source and binary packge build script';

	my $parser = Pod::Man->new(%options);
	$parser->parse_from_file ($PROGRAM_NAME);
    }
    else
    {
        # FIXME: Perl 5.x bug.
        # Can't use string ("") as a symbol ref while "strict refs" in use at /usr/lib/perl5/5.10/Pod/Text.pm line 249.
	# pod2text $PROGRAM_NAME;

        exec qq(pod2text $PROGRAM_NAME);
    }
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Activate or deactivate debug
#
#   INPUT PARAMETERS
#
#       $level          Positive integer. Zero is no debug.
#
#   RETURN VALUES
#
#       $str
#
# ****************************************************************************

sub SetDebug ($)
{
    my $id = "$LIB.SetDebug";

    $debug = shift;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Convert DOS path to Cygwin
#
#   INPUT PARAMETERS
#
#       none
#
#   RETURN VALUES
#
#       $str
#
# ****************************************************************************

sub PathToCygwin ($)
{
    my $id       = "$LIB.PathToCygwin";
    local ($ARG) = @ARG;

    $debug  > 2 and  warn "$id: input $ARG\n";

    if ( m,^(.):(.*), )
    {
	$ARG = "/cygdrive/$1$2";
    }

    $debug  > 2 and  warn "$id: RET $ARG\n";

    $ARG;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Return ISO 8601 date YYYY-MM-DD-HHMM
#
#   INPUT PARAMETERS
#
#       -utc        If set, return in UTC format
#       -time       If set, return "YYYY-MM-DD HH:MM"
#
#   RETURN VALUES
#
#       $str
#
# ****************************************************************************

sub Date (%)
{
    my $id          = "$LIB.Date";
    my %hash        = @ARG;

    my $utc         = $hash{-utc};
    my $time        = $hash{-time};

    my (@time)      = localtime(time);
    (@time)         = gmtime(time)      if   $utc;

    my $YY          = 1900 + $time[5];
    my ($DD, $MM)   = @time[3..4];
    my ($mm, $hh)   = @time[1..2];

    $time           = sprintf " %02d:%02d", $hh, $mm   if   $time;

    $debug  > 1 and  warn "$id: @time\n";

    #   Count from zero, That's why +1.

    my $ret = sprintf "%d-%02d-%02d%s", $YY, $MM + 1, $DD, $time;

    $debug  and  warn "$id: $ret\n";
    $ret;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Print content of hash (debugging)
#
#   INPUT PARAMETERS
#
#       $       string
#       %       hash
#
#   RETURN VALUES
#
#       None
#
# ****************************************************************************

sub PrintHash ($%)
{
    my $id   = "$LIB.PrintHash";
    my $str  = shift;
    my %hash = @ARG;

    $str  and  print $str;

    while ( my($key, $val) = each %hash )
    {
	warn "HASH: [$key] => [$val]\n";
    }
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Read release number (single number) from filename. The release
#       number start is indicated by a hyphen, like in package-VERSION-RELEASE.
#
#   INPUT PARAMETERS
#
#       $string     Filename
#
#   RETURN VALUES
#
#       $           Release
#
# ****************************************************************************

sub Release ($)
{
    my $id = "$LIB.Release";
    local($ARG) = @ARG;

    my $ret = $1 if /-([1-9]|\d\d)[^-]*$/;     # Max NN numbers

    $debug  and  warn "$id: RET $ARG => [$ret]\n";

    $ret;
}


# ****************************************************************************
#
#   DESCRIPTION
#
#       Read version number from filename. The version number is like
#       foo-N.N[.N]* or non-numeric version scheme like foo-1.1alpha3
#       or foo-1.80+dbg-0.61.tar.gz
#
#   INPUT PARAMETERS
#
#       $string     Filename
#
#   RETURN VALUES
#
#       $           Version
#
# ****************************************************************************

sub Version ($)
{
    my $id = "$LIB.Version";
    local($ARG) = @ARG;

    $debug  and  warn "$id: INPUT [$ARG]\n";

    #   foo-N.N, foo-YYYYMMDD

    s/(-src)?(\.orig)?\.t.+$//;         # Remove orig.tar.gz

    $debug > 2  and  warn "$id: substitute 1 [$_]\n";

    s/\.(zip)$//;

    $debug > 2  and  warn "$id: substitute 2 [$_]\n";

    s/-([1-9]|\d\d)$//;                 # Remove release -1

    $debug > 2  and  warn "$id: substitute 3 [$_]\n";

    my $ret = $1 if /-v?(\d+\..+|\d+)$/i;

    if ( not $ret  and  /^.+[-_]v?([\d.]+[_-]?rc.*)/i )
    {
	$debug > 2  and  warn "$id: exotic 2 [$_]\n";
	$ret = $1;
    }

    if ( ! $ret  and  /^([a-z_-]*[A-Za-z])([\d.]*\d)/i )
    {
	$debug > 2  and  warn "$id: exotic 3 [$_]\n";
	$ret = $2;         # foo4.16.0.70
    }

    unless ( $ret )
    {
	$debug > 2  and  warn "$id: else [$_]\n";
	# Exotic version like foo-R31b
	my @words = split '[-_][vV]?';
	$ret = $words[-1];
    }

    $debug  and  warn "$id: RET $ARG => [$ret]\n";

    $ret;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Read PACKAGE from file names like
#
#           /path/to/this-is-package-1.1.tar.gz     Universal style
#           /path/to/this-is-package_1.1.tar.gz     Debian style
#
#       If name contains underscores, they are converted into hyphens.
#
#   INPUT PARAMETERS
#
#       $string     Filename
#
#   RETURN VALUES
#
#       $           Package name
#
# ****************************************************************************

sub Package ($)
{
    my $id = "$LIB.Package";
    local ($ARG) = @ARG;

    s,.*/,,;                # Remove leading path

    $debug  and  warn "$id: INPUT $ARG\n";

    my $version = Version $ARG;

    if ( $version )
    {
	# Regexp quote "1.1" => "1\.1"
	$version =~ s,([?.+*]),[$1],g;
    }

    $debug  and  warn "$id: VER [$version] ARG [$ARG]";

    if (  $version  and  s/[_-]?$version.*// )
    {
	s/_/-/g;
    }
    else
    {
	$ARG = "";
    }

    $debug  and  warn "$id: RET [$ARG]";

    $ARG;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Search for original package file. It can be name like:
#
#           this-is-package-1.1.tar.gz       Universal style
#           this-is-package_1.1.tar.gz       Debian style
#           this-is-package_1.1.orig.tar.gz  Debian style#
#
#   INPUT PARAMETERS
#
#       $dir        Directory to search for
#
#   RETURN VALUES
#
#       $           Package file name
#
# ****************************************************************************

sub OriginalPackageFile ($)
{
    my $id = "$LIB.OriginalPackageFile";
    my ($dir) = @ARG;

    #todo:
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Subroutine for File::Find
#
#   INPUT PARAMETERS
#
#       $FILE_REGEXP            Global. If set, accept matching path
#       $FILE_REGEXP_PRUNE      Global. Prune matched path.
#
#   RETURN VALUES
#
#       Set global variables @FILE_ALL_LIST, @FILE_FILE_LIST, @FILE_DIR_LIST
#
# ****************************************************************************

sub FileScanWantedGeneral ()
{
    my $id   = "$LIB.FileScanWantedGeneral";
    my $path = $File::Find::fullname;

    $debug > 3  and  warn "$id: $path\n";

    if ( $FILE_REGEXP_PRUNE  and  $path =~ /$FILE_REGEXP_PRUNE/ )
    {
	$debug  and  warn "$id: PRUNE $path [$MATCH]\n";
	$File::Find::prune = 1;
	return;
    }

    if ( $FILE_REGEXP  and  $path !~ /$FILE_REGEXP/ )
    {
	$debug > 4  and  warn "$id: no match $FILE_REGEXP\n";
	return;
    }

    $debug > 2  and  warn "$id: PUSH $path\n";

    push @FILE_ALL_LIST,  $path;

    if ( -d $path )
    {
	push @FILE_DIR_LIST, $path;
    }
    else
    {
	push @FILE_FILE_LIST, $path;
    }
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Subroutine for File::Find
#
#   INPUT PARAMETERS
#
#       none
#
#   RETURN VALUES
#
#       @FILE_ALL_LIST is set to fist .m4 macro file found
#
# ****************************************************************************

sub FileScanWantedM4 ()
{
    my $id = "$LIB.FileScanWantedM4";

    my $path = $File::Find::name;

    if ( @FILE_ALL_LIST )
    {
	$File::Find::prune = 1;     # Already found .m4, skip search
	return
    }

    if ( $path =~ /\.m4$/ )
    {
	push @FILE_ALL_LIST, $path;
	$File::Find::prune = 1
    }
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Search all files under directory DIR.
#
#   INPUT PARAMETERS
#
#       $regexp     Files to match. Set to '' for all files.
#       @list       Directories to search
#
#   RETURN VALUES
#
#       @all        All files
#
# ****************************************************************************

sub FileScanMain ($ @)
{
    my $id = "$LIB.FileScanMain";
    $FILE_REGEXP = shift;

    if ( $debug )
    {
	print "$id: FILE_REGEXP: $FILE_REGEXP dirs: @ARG "
	    , "FILE_REGEXP_PRUNE: $FILE_REGEXP_PRUNE\n"
	    ;
    }

    not @ARG   and  die "$id: No directories to search";

    @FILE_ALL_LIST = @FILE_FILE_LIST = @FILE_DIR_LIST = ();

    find(
	    {
		wanted         => \&FileScanWantedGeneral
		, follow       => 1
		, follow_skip  => 1
	     }
	     , @ARG
	);

    $debug > 1 and  warn "$id: RETURN [@FILE_ALL_LIST]\n";

    @FILE_ALL_LIST;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Check if therea are any .m4 file under DIRECTORIES.
#
#   INPUT PARAMETERS
#
#       @list       Directories to search
#
#   RETURN VALUES
#
#       boolean     If found, contains first .m4 file found.
#
# ****************************************************************************

sub FileScanIsM4 (@)
{
    my $id = "$LIB.FileScanIsM4";

    not @ARG   and  die "$id: No directories to search";

    @FILE_ALL_LIST = ();
    find( \&FileScanWantedM4, @ARG);

    @FILE_ALL_LIST;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Read whole file into string
#
#   INPUT PARAMETERS
#
#       $file       File to open
#       $mode       [optional] flag. If set return lines instead of ONE string.
#
#   RETURN VALUES
#
#       $           File content in a scalar
#
# ****************************************************************************

sub FileRead ($;$)
{
    my $id = "$LIB.FileRead";
    my($file, $mode) = @ARG;

    $debug  and  print "$id: INPUT [$file]\n";

    local $ARG;

    open my $FILE, "<", $file  or do
    {
	warn "$id: Cannot open file [$file] $ERRNO";
	return;
    };

    my @lines;

    if ( $mode )
    {
	$debug  and  print "$id: read mode ARRAY\n";
	@lines = <$FILE>;
	$debug  and  printf "$id: input line count %d\n", scalar @lines;
    }
    else
    {
	$debug  and  print "$id: read mode STRING\n";

	local $INPUT_RECORD_SEPARATOR;
	undef $INPUT_RECORD_SEPARATOR;   # Fast slurp mode
	$ARG = <$FILE>;
    }

    close $FILE;

    $mode ? @lines : $ARG;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Read whole file into string
#
#   INPUT PARAMETERS
#
#       $file       File to open
#
#   RETURN VALUES
#
#       $           File content in a scalar
#
# ****************************************************************************

sub FileReadSlow ($)
{
    my $id = "$LIB.FileRead";
    my($file) = @ARG;

    open my $FILE, "<", "$file"
	or die "$id: Cannot open file [$file] $ERRNO";

    my $content = join '', <$FILE>;
    close $FILE;

    $content;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Replace FILE with @CONTENT
#
#   INPUT PARAMETERS
#
#       $file       File to write
#       @lines      lines to write
#
#   RETURN VALUES
#
#       none
#
# ****************************************************************************

sub FileWrite ($ @)
{
    my $id = "$LIB.FileWrite";
    my($file, @content) = @ARG;

    open my $FILE, ">", "$file"
	or die "$id: Cannot write to [$file]";

    $debug > 2  and  warn "$id: $file =>\n@content";

    binmode $FILE;
    print $FILE @content;
    close $FILE;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Search first matching REGEXP from ARRAY
#
#   INPUT PARAMETERS
#
#       $regexp     Search REGEXP
#       \@array     Array reference
#
#   RETURN VALUES
#
#       $           Modified file content
#
# ****************************************************************************

sub ListSearch ($$)
{
    my $id = "$PROGRAM_NAME.ListSearch";
    my($regexp, $aref) = @ARG;

    local $ARG;
    my    $ret;

    for ( @$aref )
    {
	if ( /$regexp/xo )
	{
	    $ret = $ARG;
	    last;
	}
    }

    $debug  and  print "$id: RET [$ret]\n";

    $ret;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Check if DESTDIR is found in any of the Makefiles or configure
#       scripts.
#
#   INPUT PARAMETERS
#
#       $dir        Directory inder which to search Makefiles.
#       $exit       [optional] If set, then exit(0) = DESTDIR was found
#                   otherwise exit(1). This is for external calls.
#
#   RETURN VALUES
#
#       $file       Name of the file which support DESTDIR
#
# ****************************************************************************

sub MakefileDestdirSupport ($; $)
{
    my $id = "$LIB.MakefileDestdirSupport";
    my($dir, $exit) = @ARG;

    $debug  and  warn "$id: dir [$dir] exit [$exit]\n";

    my @files = FileScanMain '(?i)Makefile$|configure(?:\.in)?$', $dir;

    my    $ret = '';
    local $ARG;

    for my $file ( @files )
    {
	$ARG = FileRead $file;

	$debug  and  warn "$id: Processing $file\n";

	#   DESTDIR =
	#   $(INSTALL_PROGRAM) foo $(DESTDIR)$(bindir)/$(binprefix)foo

	if ( /^[^#]* DESTDIR \s* = \s*$|^[^#]+ [$] [{(] DESTDIR/mx )
	{
	    $debug  and  warn "$id: Found $file\n";
	    $ret = $file;
	    last;
	}
    }

    my $code = $ret ? 0 : 1;

    $debug  and  warn "$id:  RET [$ret] exit [$code]\n";

    if ( $exit )
    {
	exit $code;
    }

    $ret;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Read archive's file listing.
#
#   INPUT PARAMETERS
#
#       $file   Binary file; tar.bz2
#
#   RETURN VALUES
#
#       $       File listing as one string
#
# ****************************************************************************

sub BinPkgListing ($)
{
    my ($file) = @ARG;

    #  drwxr-xr-x root/None         0 2003-06-11 13:54:38 etc/
    #  drwxr-xr-x root/None         0 2003-06-11 13:54:38 etc/postinstall/

    return unless -f $file;

    my $optz = "j";

    $optz = "z" if $file =~ /gz$/;

    local $ARG = qx(tar -${optz}tvf $file);

    s/^.*:\d\d\s+//mg;

    #   This may look hairy, but it's fairly simple. Read from right to left:
    #
    #   1. convert to array with split
    #   2. Leave out empty directory names with grep
    #   3. Add leading slash (/)
    #   4. sort
    #   5. join back to asingle line
    #
    #   => This is the return answer from the function

    join "\n", sort
	map
	{
	    $ARG = "/$ARG" unless m,^/,;
	    $ARG;
	} grep ! m{/$}, split '\n';
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Parse dependencies returned by cygcheck.exe
#
#       usr/bin/termidx.exe
#            h:\unix-root\u\bin\cygwin1.dll
#              G:\WINNT\system32\ADVAPI32.DLL
#                G:\WINNT\system32\NTDLL.DLL
#                G:\WINNT\system32\KERNEL32.DLL
#                G:\WINNT\system32\RPCRT4.DLL
#            h:\unix-root\u\bin\cygncurses7.dll
#
#   INPUT PARAMETERS
#
#       $string         output of cygcheck.exe
#
#   RETURN VALUES
#
#       ($program, @deplist)
#
#           Like fo the above example:
#
#           (termidx.exe,    "h:/unix-root/u/bin/cygwin1.dll"
#                          , "g:/winnt/system32/advapi32.dll"
#                          ... )
#
#
# ****************************************************************************

sub CygcheckParse ($)
{
    my $id = "$PROGRAM_NAME.CygcheckParse";
    local $ARG  = shift;

    $debug  and  warn "$id: input [$ARG]]\n";

    my $bin;
    my @list;

    s/^\s+//;

    if ( /\A(\S+)\s*^(.*)\Z/ms )
    {
	$bin = $1;
	$ARG = $2;

	$bin =~ s,^.+[\\/],,;         # Remove path

	while ( m,^\s*(.+[\\/](\S+)),gm )
	{
	    my ($path, $lib) = ($1, $2);

	    $path = lc $path;
	    $path =~ s,\\,/,g;

	    # h:/unix-root/u/dev/null - Cannot open

	    next if m,/dev/null, ;

	    push @list, $path;
	    $debug  and  warn "$id: Found $path\n";
	}
    }

    $debug  and  warn "$id: RET list [$bin] [@list]\n";

    $bin, @list;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Return only significant libraries from cygcheck.exe's listing.
#       The output must have been already parsed to individual files.
#       Convert files into entries suitable for setup.hint "requires:"
#
#       Like cygncurses7.dll => libncurses
#
#   INPUT PARAMETERS
#
#       @list           List of *.dll files
#
#   RETURN VALUES
#
#       @list           Filtered list.
#
# ****************************************************************************

sub CygcheckFilter (@)
{
    my $id = "$PROGRAM_NAME.CygcheckFilter";
    my(@list) = @ARG;

    local $ARG;
    my    (%hash);

    # G:\WINNT\system32\ADVAPI32.DLL
    #   G:\WINNT\system32\NTDLL.DLL
    #   G:\WINNT\system32\KERNEL32.DLL
    #   G:\WINNT\system32\RPCRT4.DLL

    my  $ignore  = 'WINNT|system32|WINDOWS';

    if ( $SYSTEMROOT )      # WinNT/2k
    {
	my $path = $SYSTEMROOT;
	$path =~ s,\\,/,g;
	$ignore .= "|$path";
    }

    $debug  and  warn "$id: ignore [$ignore]\n";

    # find .inst -name '*.exe' | xargs cygcheck | sed -e '/\.exe/d' -e 's,\\,/,g' | sort -bu | xargs -n1 cygpath -u | xargs cygcheck -f

    for ( @list )
    {
	if ( /$ignore/io )
	{
	    $debug  and  warn "$id: IGNORE $ARG\n";
	    next
	}

	#   h:\unix-root\u\usr\X11R6\bin\cygX11-6.dll
	#     h:\unix-root\u\bin\cygcygipc-2.dll
	#   h:\unix-root\u\usr\X11R6\bin\cygXaw-7.dll
	#     h:\unix-root\u\usr\X11R6\bin\cygXext-6.dll
	#     h:\unix-root\u\usr\X11R6\bin\cygXmu-6.dll
	#       h:\unix-root\u\usr\X11R6\bin\cygXt-6.dll
	#         h:\unix-root\u\usr\X11R6\bin\cygICE-6.dll
	#         h:\unix-root\u\usr\X11R6\bin\cygSM-6.dll
	#     h:\unix-root\u\usr\X11R6\bin\cygXpm-4.dll

	if ( /X11/i )
	{
	    $hash{'Xorg-base'} = 1;
	    next;
	}

	s/cygwin1\.dll/cygwin/;

	#  Normally the packages are delivered in libXXXX-1.1.tar.bz2
	#  but the compiled libraries include cyg* prefix.

	$debug  and  warn "$id: hash $ARG\n";

	$hash{$ARG} = 1;
    }

    my @ret = sort keys %hash;

    $debug  and  warn "$id: RET [@ret]\n";

    @ret;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       There is utility cygcheck.exe which can display system information or
#       PROGRAM or library dependencies. These dependencies must be listed
#       in package.README and setup.hint
#
#       This function runs Cygcheck for all binary files in DIR and
#       makes sure they are listed in FILE.
#
#   INPUT PARAMETERS
#
#       $exedir         Directory to search for .exe files to check
#
#   RETURN VALUES
#
#       $flag           If *.m4 files were found.
#       %hash           PROGRAM => [ dependency, ... ]
#
# ****************************************************************************

sub CygcheckDependencies ($)
{
    my $id = "$PROGRAM_NAME.CygcheckDependencies";
    my($exedir, $cygdir) = @ARG;

    $debug  and  warn "$id: INPUT exedir [$exedir] cygdir [$cygdir]\n";

    not -d $exedir      and  die "$id: No exedir [$exedir]";
    chdir $exedir       or   die "$id: cannot cd $exedir $ERRNO";

    #my @files = qx(find . -name \*.exe -o -name \*.dll);

    $FILE_REGEXP_PRUNE  = '';
    my $regexp          = '\.(exe|dll|m4)$|/bin/[^/]+$';
    my @files           = FileScanMain $regexp, $exedir;

    chomp @files;

    $debug  and  warn "$id: files in ", cwd(), " [@files]\n";

    #   See if there were any m4 files. Leave *.exe

    my $m4 = 1   if  grep /\.m4$/, @files;
    @files = grep ! /\.m4$/, @files   if $m4;

    local $ARG;
    my %hash;
    my $pwd = PathToCygwin cwd();

    $debug  and  warn "$id: PWD $pwd\n";

    for my $file (@files)
    {
	-d $file  and  next;   # Skip directories

	my $cygfile = PathToCygwin $file;
	my ($builddir, $rel) = ( $file =~ m,(^.*)/\.inst/(.*), );

	#   Some packages use pathc like: /usr/src/build/try/aewm++
	#   Must use \Q ... \E

	if ( $cygfile =~ m,^\Q$pwd\E/(.*), )
	{
	    $file = $1;     # Make relative
	}
	elsif ( $builddir
		and  -l $builddir
		and  $pwd =~ m,\.inst$,
	      )
	{
	    #   it's a symbolic link.
	    #   file /build/rdesktop/rdesktop-1.3.0/.inst/usr/bin/rdesktop.exe
	    #   pwd  /build/rdesktop/rdesktop/.inst

	    $file = $rel;
	}

	#   It's too bad that File::Find reports symbolically linked executable
	#   files without extension.
	#
	#   program -> real.exe
	#
	#   This is reported as "real" not "real.exe". The problem is that
	#   'cygcheck' needs that extension. Fix it here.

	if ( $file !~ /\.\S+$/  and  -f "$file.exe" )
	{
	    $file = "$file.exe";
	    $debug > 2  and  warn "$id: Fixed by adding .exe to $file\n";
	}

	my $cmd = qq(/usr/bin/cygcheck "$file");

	$debug  and  warn "$id: [SHELL CALL] $cmd\n";
	$ARG = join '', qx($cmd);

	if ( /Cannot open/i )
	{
	    warn "$id: [ERROR] $pwd cygcheck reports: $ARG\n";
	    next;
	}

	$debug   and  warn "$id: [$file] =>\n$ARG";

	my($bin, @list) = CygcheckParse $ARG;
	$hash{$bin} = \@list if $bin;
    }

    $debug  and  warn "$id: RET [", join(' ', %hash), "]\n";

    $m4, %hash;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Read central Cywin installation archive list if it exists.
#
#       In order to use central database, all downloaded
#       package-N.N-N.tar.bz2 files must be scanned through and the content
#       listings must be in one file.. Generating the list of contents of
#       each file will take LOT of time in the first time. If you're unsure
#       what this directory should be searched, start setup.exe and see
#       value 'Local Package Directory'. Under that directory resides
#       the installed and downloaded Cygwin packages.
#
#       See cygbuild manual how to generate this file.
#
#   INPUT PARAMETERS
#
#       $file           *.dll file to search
#
#   RETURN VALUES
#
#       Matching package name where *.dll file exists.
#
# ****************************************************************************

{
    my @staticArray;   # This variable work like a cache

sub FileSearchFromPackages ($)
{
    my $id      = "$PROGRAM_NAME.FileSearchFromPackages";
    my($string) = @ARG;

    my $dir = $CYGWIN_PACKAGE_LIST_DIR;

    if ( ! -d $dir )
    {
	#  If cache has not been generated, skip this.

	$debug   and  print "$id: [WARN] Cannot search $dir for matches\n";
	return;
    }

    #   If we have already been here, the @static Array already exists.
    #   No need to read disk any more.

    unless ( @staticArray )
    {
	opendir my $DIR, $dir   or  do{ warn "$id: $dir $ERRNO"; return };

	for my $file ( readdir $DIR )
	{
	    my $path = "$dir/$file";

	    $debug  and  print "$id: Reading $path\n";

	    ! -f $path  and  next;
	    push @staticArray, FileRead $path, -array;
	}
    }

    #  The content is tar listing, search from it.
    #  cygdrive/c/install-cygwin/CONTRIB/TTCP/ttcp-19980512-1.tar.bz2:drwxr-xr-x ssinyagin/None    0 2002-02-12 16:12:43 usr/lib/some.dll

    my $ret = ListSearch "$string\$", \@staticArray;

    if ( $ret  and  $ret =~ m,/([^/:\s]+):, )
    {
	#  The package name suffices, extract it
	#  gsl-1.4-2.tar.bz2 => gsl

	$ret = $1;
	$ret =~ s/-\d.+//;
    }

    $debug  and  print "$id: RET: [$ret]\n";

    $ret;
}}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Report rependencies of programs
#
#   INPUT PARAMETERS
#
#       %hash       program => [ dep, ... ]
#
#   RETURN VALUES
#
#       @list       List of dependencies
#
# ****************************************************************************

sub CygcheckDepsList (%)
{
    my $id = "$LIB.CygcheckDepsList";
    my (%hash) = @ARG;

    my %ret;

    while ( my($key, $ref) = each %hash )
    {
	my @list = CygcheckFilter @$ref;

	#  Use hash to filter out duplicates
	@ret{@list} = @list x (1)  if @list;
    }

    my @ret = sort keys %ret;

    $debug  and  warn "$id: RET @ret\n";

    @ret;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Check if more dependencies are needed
#
#   INPUT PARAMETERS
#
#       \@orig      Original dependencies
#       \@deps      Found dependencies (.exe)
#
#   RETURN VALUES
#
#       (\@new, \@all)      New dependencies, All dependencies
#
# ****************************************************************************

sub CygcheckDepsNeeded ($$)
{
    my $id = "$LIB.CygcheckDepsNeeded";
    my ($orig, $deps) = @ARG;

    $debug  and  warn "$id: INPUT orig [@$orig] deps [@$deps]\n";

    my    @need;

    unless ( grep /cygwin/i, @$deps )
    {
	warn "$id: [FIX] 'requires: cygwin' is missing\n";
	push @need, "cygwin";
    }

    #   Anything missing? Compare if the lists differ.

    my %hash;
    @hash{@$orig}++  if  @$orig;

    my %rename =
    (
	'cygipc-\d' => 'cygipc'
    );

    local $ARG;

    for (@$deps)
    {
	$debug  and  warn "$id: ORIG [$ARG]\n";

	s,^.+/,,;                           # Remove path component

	$ARG = lc  unless /xfree|Xorg/i;

	for ( my($pkg, $changed) = each %rename )
	{
	    $ARG =~ s/$pkg/$changed/;
	}

	my $search = $ARG;                  # Can't use $ARG in grep()
	my @found  = grep /$search/i, @$orig;

	$debug  and  warn "$id: test [$ARG] found [@found]\n";

	unless ( @found )
	{
	    #  Try harder to find correct library. What package provides
	    #  this *.dll?

	    my $package = FileSearchFromPackages $ARG;

	    $ARG = $package  if $package;

	    push @need, $ARG;
	    $hash{$ARG}++;
	}
    }

    $debug  and  warn "$id: ORIG [@$orig] NEED [@need]\n";

    \@need, [ sort keys %hash ];
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Check that dependencies have been listed in setup.hint
#
#   INPUT PARAMETERS
#
#       $file           Path to setup.ini
#       \@list          ( dep, ... )
#       $flag           if set, update changes. Otherwise report.
#
#   RETURN VALUES
#
#       none
#
# ****************************************************************************

sub CygcheckDepsCheckSetup ($$; $)
{
    my $id = "$LIB.CygcheckDepsCheckSetup";
    my ($file, $list, $update) = @ARG;

    my $regexp = 'requires:\s*(.*)';
    local $ARG = FileRead $file;

    unless ( /$regexp/oi )
    {
	warn "$id:  [WARN] Cannot find 'requires:' line from $file\n";
	return;
    }

    #   requires: cygwin libncurses

    my @deps = split ' +', $1;

    $debug   and warn "$id: DEPS [@deps]\n";
    ! @deps  and warn "$id: [NOTE] 'requires:' is empty in $file\n";

    my ($needRef, $allRef) = CygcheckDepsNeeded \@deps, $list;
    my @need = @$needRef    if $needRef;
    my @all  = @$allRef     if $allRef;

    if ( @need )
    {
	unless ( $update )
	{
	    print "$file needs more dependency lines for require: @need\n";
	    return;
	}

	#  Remove paths with map()

	my $depline = join ' ', sort map { s,^.+/,,; $ARG } @all;
	my $replace = "requires: $depline";

	unless ( s/$regexp/$replace/i )
	{
	    die "$id: Cannot replace $file with [$replace]";
	}

	FileWrite $file, $ARG;
	print "[UPDATED] $file => $replace\n";
    }
    else
    {
	print "[OK] $file contains dependencies [@all]\n";
    }
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Check that dependencies have been listed.
#
#       Runtime requirements:
#         cygwin-1.3.22 or newer
#         libncurses
#
#   INPUT PARAMETERS
#
#       $file           Path to package.README
#       \@list          ( dep, ... )
#       $flag           if set, update changes. Otherwise report.
#
#   RETURN VALUES
#
#       none
#
# ****************************************************************************

sub CygcheckDepsCheckReadme ($$; $)
{
    my $id = "$LIB.CygcheckDepsCheckReadme";
    my ($file, $list, $update) = @ARG;

    my $regexp = 'Runtime requirements:(.*?)^\s*$';
    local $ARG = FileRead $file;

    #  Search for line: Runtime requirements:

    unless ( /$regexp/ogsmi )
    {
	warn "$id: Cannot find line 'Runtime requirements:' from $file";
	return 1;
    }

    my $match = $1;
    my @deps;

    $debug  and  warn "$id: MATCH [$match]\n";

    while ( $match =~ /^\s*(\S.*)/gm )
    {
	push @deps, $1;
    }

    $debug  and  warn "$id: DEPS [@deps]\n";

    my ($needRef, $allRef) = CygcheckDepsNeeded \@deps, $list;
    my @need = @$needRef    if $needRef;
    my @all  = @$allRef     if $allRef;

    if ( @need )
    {
	unless ( $update )
	{
	    print "$file needs more dependency lines for require: @need\n";
	    return;
	}

	for my $line (@all)
	{
	    $line =~ s/^\s+//;
	    $line =~ s/\s+$//;
	    $line = "  $line\n";
	}

	my $replace = "Runtime requirements:\n"
	   . join '', sort map { s,\S+/,,; $ARG } @all;

	unless ( s/$regexp/$replace/smi )
	{
	    die "$id: Cannot replace $file with [$replace]";
	}

	FileWrite $file, $ARG;
	print "[UPDATED] $file => $replace\n";
    }
    else
    {
	print "[OK] $file contains dependencies [@all]\n";
    }
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Check that dependencies have been listed in setup.hint and
#       <package>.README
#
#   INPUT PARAMETERS
#
#       $instdir        Path to directory .inst
#       $dir            Path to directory CYGWIN-PATCHES
#
#   RETURN VALUES
#
#       none
#
# ****************************************************************************

sub CygcheckDepsCheckMain ($$)
{
    my $id = "$LIB.CygcheckDepsCheckMain";
    my ($instdir, $dir)   = @ARG;

    $debug  and  warn "$id: instdir [$instdir] dir [$dir]\n";

    my $setup   = "$dir/setup.hint";
    opendir my $DIR, $dir    or die "$id: open error [$dir] $ERRNO";

    #  Ignore files like ".#unrtf.README"

    my $readme = "$dir/" . (grep /readme$/i && !/[#~]|^\./, readdir $DIR)[0];
    closedir $DIR;

    unless ( -f $setup  and  -f $readme )
    {
	die "$id: No SETUP [$setup] or README [$readme]";
    }

    $debug  and  warn "$id: $setup $readme\n";

    my ($m4, %hash) = CygcheckDependencies $instdir;

    if ( %hash )
    {
	my @deps = CygcheckDepsList %hash;

	push @deps, "m4"  if $m4;

	CygcheckDepsCheckSetup  $setup,  \@deps, -update;
	CygcheckDepsCheckReadme $readme, \@deps, -update;
    }
    elsif ( $m4 )
    {
	CygcheckDepsCheckSetup  $setup,  [ "m4" ], -update;
	CygcheckDepsCheckReadme $readme, [ "m4" ], -update;
    }
    else
    {
	print "$id: Nothing to do, no *.exe or *.dll found in $instdir\n";
    }
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Update the file listing section.
#
#   INPUT PARAMETERS
#
#       $binpkg     Binary package location
#       $content    The README file content in one string.
#
#   RETURN VALUES
#
#       $           Modified file content
#
# ****************************************************************************

sub ReadMeFilesIncluded ($ $)
{
    my $binpkg = shift;
    local $ARG = shift;

    my $files = BinPkgListing $binpkg;

    return $ARG  unless $files;

    #  -------------------------------------------
    #
    #  Files included in the binary distribution
    #
    #  etc/postinstall/unison.sh
    #  usr/bin/unison.exe
    #  usr/doc/Cygwin/unison-2.9.45.README
    #  usr/doc/unison-2.9.45/COPYING
    #  u...
    #
    #  ---------

    s
    {
	(Files\s+ included\s+ in\s+ the\s+ binary \s+ [^\r\n]+)
	\s*
	(?:^ \s+ \S+ [\r\n]+)+
	.*?
	(-----)
    }
    {$1\n\n$files\n\n$2}smx;

    $ARG;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Update announcement mail message
#
#       To: cygwin-announce@cygwin.com
#       Subject: Updated: foo 1.7.1-1 -- description
#
#   INPUT PARAMETER HASH
#
#       $file           location to package.README
#       $pkg            Package name
#       $ver            Version N.N
#       $rel            Release N
#
#   RETURN VALUES
#
#       None. Processed file content is written back to $file
#
# ****************************************************************************

sub UpdateAnnouncement ($$$$)
{
    my $id          = "$LIB.UpdateAnnouncement";
    my($file, $pkg, $ver, $rel) = @ARG;

    $debug  and  warn "$id: file [$file] pkg [$pkg] ver [$ver] rel [$rel]\n";

    $file  or  die "$id: FILE argument is empty";

    my $orig = FileRead $file or die "$ERRNO";
    local $ARG = $orig;

    my $vid     = "$ver-$rel";                          # version id
    my $iso8601 = Date(-utc => "on");

    my $rest;

    if ( /(New \s+ package | Updated): .*? (?<rest> \s* --+ .*)/mxi )
    {
	$rest = $+{rest};
    }

    s
    < ^(?<header> Subject: \s*)
       New package:
    >
    <$+{header}Updated:>mxi;

    s
    < ^Subject: \s*
       (?<type> \S+): \s*
       (?<pkg>  \S+)  \s+
       (?<ver>  \S+)
       (?<rest>  .*)
    >
    <Subject: Updated: $+{pkg} $vid$rest>mxi;

    #  Delete this line

    s< ^Subject: \s* New \s+ Package: .* \r? \n ><>mxi;

    #  Update Copyright information.

    $ARG = UpdateYears($ARG);

    unless ( length $file == length $ARG )
    {
	FileWrite $file, $ARG;
    }
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Add new stanza based on input arguments:
#
#       ---- version <VER>-<REL> -----
#       - New upstream release <YYYY-MM-DD> <First Last>
#
#   INPUT PARAMETER HASH
#
#       str => $str     String
#       tag => value    Hash values: -pkg, -ver, -rel
#
#   RETURN VALUES
#
#       String
#
# ****************************************************************************

sub UpdateNewVersionStanza (%)
{
    my $id          = "$LIB.UpdatePackageTags";
    my %hash        = @ARG;

    local $ARG      = $hash{-str};
    my $pkg         = $hash{-pkg};
    my $ver         = $hash{-ver};
    my $rel         = $hash{-rel};
    my $name        = $hash{-name}  || $systemName;

    $debug  and  warn "$id: pkg [$pkg] ver [$ver] rel [$rel]\n";

    my $vid     = "$ver-$rel";                          # version id
    my $iso8601 = Date(-utc => "on");

    my $stanza =
"----- version $vid -----
- New upstream release $iso8601 Firstname Lastname

";

    if ( $name )
    {
	$stanza =~ s,(Firstname Lastname),$name,;
    }
    else
    {
	warn "$id: [WARN] Can't update 'name'. No Env. vars NAME or EMAIL";
    }

    unless ( /^-.*version.*$vid/m )
    {
	$debug   and  warn  "$id:\nUPDATE START${stanza}UPDATE END\n";
	s/(Port\s+Notes:.*?)^(---)/$1$stanza$2/sm;
    }

    $ARG;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Replace all <PKG> <REL> <VER> tags.
#
#   INPUT PARAMETER HASH
#
#       str => $str     String
#       tag => value    Hash values to replace.
#
#   ENVIRONMENT
#
#       NAME
#       EMAIL
#
#   RETURN VALUES
#
#       String
#
# ****************************************************************************

sub UpdatePackageTags (%)
{
    my $id          = "$LIB.UpdatePackageTags";
    my %hash        = @ARG;

    local $ARG      = $hash{-str};
    my $pkg         = $hash{-pkg};
    my $ver         = $hash{-ver};
    my $rel         = $hash{-rel};

    $debug  and  warn "$id: pkg [$pkg] ver [$ver] rel [$rel]\n";

    #     unpack <PKG>-VER-REL-src.tar.bz2

    my $fullpkg = "$pkg-$ver-$rel";

    s,\QPKG-VER-REL\E,fullpkg,g
	or  s,\Q<PKG>-VER-REL\E,$fullpkg,g
	or  s,\Q<PKG>-<VER>-<REL>\E,$fullpkg,g
	;

    s,(unpack\s*).*[\d.-]+\d,$1$pkg-$ver-$rel,;

    s<(This +will +create:)\s+(^ +\S+\s+){2}>
     <$1\n  $pkg-$ver-$rel.tar.bz2\n  $pkg-$ver-$rel-src.tar.bz2\n\n>smi;

    s,\Q<PKG>\E,$pkg,g;
    s,\Q<VER>\E,$ver,g;
    s,\Q<REL>\E,$rel,g;

    #  Remove this section:
    #
    #  ------------------------------------------
    #
    #  Files included in the binary distro:
    #
    #  etc/postinstall/bogofilter.sh
    #  ...

    my $placeholder = "  See Cygwin package archive";

    s{(Files included in.*binary.*dist\w+:).+?(^---------)}
     {$1\n$placeholder\n\n$2}ms;

    # 2008-02-12 Disabled. It is better not to include the listing,
    # because it can be seen from tar.gz file
    #
    # $ARG = ReadMeFilesIncluded $binpkg, $ARG;

    $ARG;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Update Copyright from environment values NAME and EMAIL.
#       'Cygwin port maintained by:', YYYY, YYYY-MM-DD, <Fistname Lastname>.
#
#   INPUT PARAMETER HASH
#
#       $str            String
#
#   ENVIRONMENT
#
#       NAME
#       EMAIL
#
#   RETURN VALUES
#
#       String
#
# ****************************************************************************

sub UpdateYears ($)
{
    my $id = "$PROGRAM_NAME.UpdateYears";
    local $ARG = shift;

    #   Dates and all that

    my $iso8601 = Date(-utc => "on");
    my $YYYY    = 1900 + (gmtime time)[5];

    s,[<]?YYYY-MM-DD[>]?,$iso8601,;
    s,[<]?YYYY[>]?,$YYYY,g;

    #   User idenification from environment

    my $name  = $systemName;
    my $email = $systemEmail;

    if ( $name  and  $email )
    {
	$email =~ s,[<>],,g;
	s,(Cygwin port maintained by:).*,$1 $name <$email>,;
    }
    else
    {
	warn "[WARN] Can't update 'maintained by'. No Env. vars NAME or EMAIL";
    }

    s,[<]?Firstname\s+Lastname[>]?,$name,g;

    # Update newer year.
    #   Cygwin port maintained by: Firstname Lastname <Your email here>
    #   Copyright (C) YYYY Firstname Lastname; Licensed under GPL v2 or later
    #
    #   yyyy      => yyyy-xxxx
    #   yyyy-yyyy => yyyy-xxxx

    s/(Copyright\s+\(C\)\s+)(?!$YYYY)(\d{4})(\s)/$1$2-$YYYY$3/;
    s/(Copyright\s+\(C\)\s+\d{4}-)(?!$YYYY)\d+(\s)/$1$YYYY$2/;

    $ARG;
}


# ****************************************************************************
#
#   DESCRIPTION
#
#       Update Copyright etc in file list.
#
#   INPUT PARAMETERS
#
#       $type           If "split", then list of files are retrieved
#                       by splitting the @list on space.
#       @list           list of file names.
#
#   RETURN VALUES
#
#       None. Files are replaces in place.
#
# ****************************************************************************

sub FileFix ($@)
{
    my $id = "$PROGRAM_NAME.FileFix";
    my $type = shift;
    my @list = @ARG;

    $debug  and
	warn "$id: INPUT A \@list: @list";


    if ($type =~ /split/i )
    {
	@list = map { split /\s+/ } @list;
    }

    $debug  and
	warn "$id: INPUT B \@list: @list";

    for my $file (@list)
    {
	$file =~ /\S/  or  next;                # Drop empty strings

	my $str = FileRead $file  or next;
	my $len = length $ARG;

	$str = UpdateYears $str;

	unless ( $len = length $str )           # Changes
	{
	    FileWrite $file, $str;
	}
    }
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Cygwin Net release includes file package.README, that is expected to
#       reflect the current build. This function modifies that file
#       and replaces all <PKG> <REL> and <VER> tags. In addition, it
#       will update other sections too. See called functions.
#
#   INPUT PARAMETERS
#
#       $file           location to package.README
#       $pkg            Package name
#       $ver            Version N.N
#       $rel            Release N
#
#   RETURN VALUES
#
#       None. Processed file content is written back to $file
#
# ****************************************************************************

sub ReadmeFix ($ $$$)
{
    my $id = "$PROGRAM_NAME.ReadmeFix";
    my($file, $pkg, $ver, $rel) = @ARG;

    $debug  and
	warn "$id: INPUT file [$file] pkg $pkg, ver $ver, rel $rel\n";

    ! -f $file  and  die "$id: No file [$file]";
    $pkg  or  die "$id: No argument: PACKAGE";
    $ver  or  die "$id: No argument: VERSION";
    $rel  or  die "$id: No argument: RELEASE";

    my $orig = FileRead $file or die "$ERRNO";

    my $str = UpdateYears $orig;

    $str = UpdatePackageTags
	-str => $str,
	-pkg => $pkg,
	-ver => $ver,
	-rel => $rel
	;

    $str = UpdateNewVersionStanza
	-str => $str,
	-pkg => $pkg,
	-ver => $ver,
	-rel => $rel
	;

    unless ( length $orig == length $str )
    {
	FileWrite $file, $str;
    }
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Diff two directories return exclude clauses for every statement:
#
#           Only in .: config.guess
#           Only in .: config.h
#           Only in .: config.h.in
#
#   INPUT PARAMETERS
#
#       $dir        Source directory which is compared to current directory
#
#   RETURN VALUES
#
#       $           --exclude=... --exclude=...
#
# ****************************************************************************

sub DiffToExclude ( $ )
{
    my $id   = "$PROGRAM_NAME.DiffToExclude";
    my($dir) = @ARG;

    not $dir     and  die "$id: Empty directory [$dir]";
    not -d $dir  and  die "$id: Invalid directory [$dir]";

    $debug  and  warn "$id: Running diff -r $dir .\n";

    my @list = qx(diff -r $dir .);
    my $str  = "";

    local $ARG;
    my    %seen;

    $debug  and  warn "$id: command results:\n@list\n";

    for ( @list )
    {
	next if /CYGWIN-PATCHES/;         #   Yes, include this

	if ( /^Only in ([^:]+): +(.+)/i )
	{
	    my $dirpart  = $1;
	    my $item     = $2;      # File or directory
	    my $join     = "$dirpart/$item";

	    $join =~ s,^\./,,;  # Don't use ./

	    #   Don't check object or library files
	    #   They are excluded anyway

	    next if $item =~ /\.(l?[ao]|dll)/;

	    $seen{$item}++;
	}
    }

    print join ' ', map {$ARG = "--exclude=$ARG"; $ARG } keys %seen;

    print $str;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Read files under $dir/CVS/* to find details of this CVS.
#
#   INPUT PARAMETERS
#
#       $dir        Directory where to chdir
#
#   RETURN VALUES
#
#       %           repository => address
#                   root       => path name
#
# ****************************************************************************

sub CVSinfo ( $ )
{
    my $id   = "$PROGRAM_NAME.CVSinfo";
    my($dir) = @ARG;

    $dir =~ s,$/,,;     # Delete trailing
    $dir .= "/CVS";

    unless ( $dir and -d $dir )
    {
	die "$id: Invalid directory [$dir]";
    }

    my %hash;
    my $file = "$dir/Root";
    local (*FILE, $ARG);

    open FILE, "<", $file  or die "$id: Cannot open $file $ERRNO";

    $ARG = join '', <FILE>;
    close FILE;

    s/\s+//g;

    $hash{root} = $ARG;

    $file = "$dir/Repository";

    open FILE, "<", $file  or die "$id: Cannot open $file $ERRNO";

    $ARG = join '', <FILE>;
    close FILE;

    s/\s+//g;

    $hash{repository} = $ARG;

    $debug > 1  and  PrintHash "$id: RET\n", %hash;

    %hash;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Read entry from  setup.ini. Each entry looks like this:
#
#       @ foo
#       sdesc: ""
#       ldesc: ""
#       version: 2003.0730-1
#       install: foo-2003.0730-1.tar.bz2 51131
#       requires: perl bash
#       Build-Depends: bash (>> 2.04), perl (>> 5.004), make
#
#   INPUT PARAMETERS
#
#       $content    Content of setup.ini as string
#
#   RETURN VALUES
#
#       $block      Return first entry (sdesc, ldesc ...)
#
# ****************************************************************************

sub CygwinSetupIniEntry ( $ )
{
    my $id = "$PROGRAM_NAME.CygwinSetupIniEntry";
    local ($ARG) = @ARG;

    my $ret;

    if ( /(@.*?)^\s*$/sm )
    {
	$ret = $1;
    }

    $ret;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Update setup.ini by writing a new entry to the end of file.
#
#   INPUT PARAMETERS
#
#       $file       location of setup.ini
#       $release    location of the tar.bz2 file
#
#   RETURN VALUES
#
#       $new        Added new entry to the end of setup.ini
#
# ****************************************************************************

sub CygwinSetupIniUpdate ( $ $ )
{
    my $id = "$PROGRAM_NAME.CygwinSetupIniUpdate";
    my($file, $release) = @ARG;


    $debug  and  warn "$id:  INPUT file $file release $release\n";

    local *FILE;

    open FILE, "<", $file    or  die "$id: Cannot open [$file] $ERRNO";
    my $content = join '', <FILE>;
    close FILE;

    not -r $release         and  die "$id: Cannot open [$release] $ERRNO";
    my $size = -s $release;
    not $size > 0           and  die "$id: Zero size [$release]";

    $release = basename $release;

    $content =~ /$release/  and  die "$id: $release already in $file";


    my $block = CygwinSetupIniEntry $content;
    not $block      and  die "$id: Cannot parse $file content [$content]";


    my $version = Version $release;

    unless ( $version )
    {
	die "$id: Cannot read version number from [$release]";
    }


    #   Only these lines need to be changed
    #   version: 2003.0919-1
    #   install: cygbuild-2003.0919-1.tar.bz2 112009

    $block =~ s/version:.*/version: $version/;
    $block =~ s/install:.*/install: $release $size/;

    my $new = $content . $block;

    print $new;
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Maintainer only section. These functions are never called. They are
#       substituted in place of main() to test various things.
#
#   INPUT PARAMETERS
#
#       none
#
#   RETURN VALUES
#
#       none
#
# ****************************************************************************

sub TestDriverCygwinSetupIniEntry ()
{
    my $str = <<'EOF';
@ foo1
sdesc: "1"
ldesc: "2"
version: 2003.0730-1
install: foo1-2003.0730-1.tar.bz2 51131
requires: perl bash
Build-Depends: bash (>> 2.04), perl (>> 5.004), make

@ foo2
sdesc: "2"
ldesc: "2"
version: 2003.0730-1
install: foo2-2003.0730-1.tar.bz2 51131
requires: perl bash
Build-Depends: bash (>> 2.04), perl (>> 5.004), make

EOF

    print CygwinSetupIniEntry $str;
}

sub TestDriverCygwinSetupIni ()
{
    my $root = "$HOME/project/sforge/cygbuild";
    my $file = "$root/etc/cygwin/setup.ini";
    my $tar  = "$root/.build/cygbuild-2003.0730.tar.gz";

    CygwinSetupIniUpdate $file, $tar;
}

sub TestDriverReadmeFix ()
{
    $debug = 3;

    ReadmeFix
      "CYGWIN-PATCHES/cdargs.README"
      , "cdargs"
      , "1.35"
      , "1"
      ;

    exit;
}

sub TestDriverUpdateAnnouncement ()
{
    $debug = 3;

    UpdateAnnouncement
      "CYGWIN-PATCHES/cygwin-announce.mail"
      , "cdargs"
      , "1.35"
      , "1"
      ;

    exit;
}

sub TestDriverCygcheckParse ()
{
    my $id = "$LIB.TestCygcheckParse";

    my $string = << 'EOF';

usr/bin/termidx.exe
     h:\unix-root\u\bin\cygwin1.dll
       G:\WINNT\system32\ADVAPI32.DLL
	 G:\WINNT\system32\NTDLL.DLL
	 G:\WINNT\system32\KERNEL32.DLL
	 G:\WINNT\system32\RPCRT4.DLL
     h:\unix-root\u\bin\cygncurses7.dll
EOF

    print "$id\n";

    $debug = 1;
    my($bin, @list) = CygcheckParse $string;

    printf "$bin => %s\n", join ' ', @list;

    @list = CygcheckFilter @list;

    printf "dependency list: %s\n", join ' ', @list;
}

sub TestDriverCygcheck ()
{
    my $id     = "$LIB.TestCygcheck";
    my $root   = "d:/data/src/build/joe/joe-2.9.8";
    my $file   = "$root/CYGWIN-PATCHES/setup.hint";
    my $readme = "$root/CYGWIN-PATCHES/joe.README";

    $debug = 1;
    my %hash = CygcheckDependencies "$root/.inst";
    my @deps = CygcheckDepsList %hash;

    CygcheckDepsCheckSetup  $file, \@deps;
    CygcheckDepsCheckReadme $readme, \@deps, 1;
}

sub TestDriverCygcheckMain ()
{
    my $id     = "$LIB.TestDriverCygcheckMain";
    my $root   = "/usr/src/build/build/joe/joe-2.9.8";

    $debug = 1;
    CygcheckDepsCheckMain "$root/.inst", "$root/CYGWIN-PATCHES";
}

sub TestDriverFileScanMain ()
{
    my $id     = "$LIB.TestDriverFileScanMain";
    my $root   = "/usr/src/build/build/joe/joe-3.1/.inst/usr/bin";

    $debug             = 7;
    $FILE_REGEXP_PRUNE = '';
    FileScanMain '\.(exe|dll|m4)$|/bin/[^/]+', "$root";
}

sub TestDriverFileSearchFromPackages ()
{
    $debug = 1;
    $CYGWIN_PACKAGE_LIST_DIR = "/var/lib/cygbug/package/list";

    #   gsl-1.4-2.tar.bz2:/usr/lib/libgslcblas.dll.a
    print FileSearchFromPackages "libgslcblas.dll.a";
}

sub TestDriverDebian ()
{

    my $rules = << 'EOF';

#!/usr/bin/make -f
#export DH_VERBOSE=1
# This is the debhelper compatibility version to use.
export DH_COMPAT=3

clean:
	dh_testdir
	dh_testroot
	dh_clean

	find . -name "*.pyc" -exec rm -f {} \;

install: build
	dh_testdir
	dh_testroot
	dh_clean -k
	dh_installdirs -i usr/bin
	dh_installdirs -i usr/lib/ask
	dh_installdirs -i usr/share/man/man1
	dh_installdirs -i usr/share/ask
	dh_installdirs -i usr/share/ask/samples
	dh_installdirs -i usr/share/ask/templates

	# Add here commands to install the package into debian/ask.
	install -m 755 ask.py asksetup.py askversion.py utils/asksenders.py $(CU
RDIR)/debian/ask/usr/bin

	install -m 644 askconfig.py   $(CURDIR)/debian/ask/usr/lib/ask
	install -m 644 asklock.py     $(CURDIR)/debian/ask/usr/lib/ask
	install -m 644 asklog.py      $(CURDIR)/debian/ask/usr/lib/ask
	install -m 644 askmail.py     $(CURDIR)/debian/ask/usr/lib/ask
	install -m 644 askmain.py     $(CURDIR)/debian/ask/usr/lib/ask
	install -m 644 askmessage.py  $(CURDIR)/debian/ask/usr/lib/ask
	install -m 644 askremote.py   $(CURDIR)/debian/ask/usr/lib/ask

	install -m 644 samples/*   $(CURDIR)/debian/ask/usr/share/ask/samples
	install -m 644 templates/* $(CURDIR)/debian/ask/usr/share/ask/templates

	## Manpages are installed using "install", as dh_installman gets
	## confused with the .py extension (despite the correct .TH line)

	gzip --best docs/*.1
	install -m 644 docs/*.1.gz $(CURDIR)/debian/ask/usr/share/man/man1

binary-indep: install
	dh_testdir -i
	dh_testroot -i
	dh_installdocs -i docs/*.html docs/*.css docs/*.pdf docs/*.txt
	#dh_installman -A docs/ask.py.1 docs/asksetup.py.1
	dh_installchangelogs ChangeLog -i
	dh_installdebconf
	dh_compress -i
	dh_fixperms -i
	dh_installdeb -i
	dh_gencontrol -i
	dh_md5sums -i
	dh_builddeb -i

binary: binary-indep
.PHONY: build clean binary-arch binary install configure
EOF

    my @arr = ();

    @arr = DebianRulesInstalldirs $rules;
    print "Dirs: @arr\n";

    @arr = DebianRulesInstall $rules;
    print "Install: ", join ("\n",  @arr), "\n";
}

# ****************************************************************************
#
#   DESCRIPTION
#
#       Main() from which program start if called directly from command
#       line. This fucntion efectively prints outly Help(). The call syntax
#       is:
#
#           $ perl program.pl help              (text help)
#           $ perl program.pl help --man
#           $ perl program.pl help --html
#
#   INPUT PARAMETERS
#
#       @list   First word must be command "help"
#
#   RETURN VALUES
#
#       none
#
# ****************************************************************************

sub Main (;@)
{
    # $debug = 2;

    if ( @ARG and $ARG[0] =~ /help/ )
    {
	shift @ARG;
	Help(@ARG);
    }
    else
    {
       warn "Perhaps you meant to call cygbuild? This is only a help page.";
    }
}

sub Test ()
{
    $debug = 10;
    my $a;
    # $a = "remake-3.80+dbg-0.61.tar.gz";
    # $a = "foo_V22.1";
    # $a = "foo-bar-1.1-rc1";
    $a = "foo4.16.0.70";
    print "[Version] ", Version $a, " [Package] ", Package $a, "\n";
}

# Test; die;

#   Interactive call from command line contains parameters
#   like in "cygbuild.pl help --man"

@ARGV  and  Main @ARGV;

#   This file is also a library. Return true value for
#   Perl commands `use' and `require'.

1;

# End of file
