#!/bin/bash
#
#   cygbuild.sh --- A generic Cygwin Net Release package builder script
#
#       Copyright (C) 2003-2007 Jari Aalto
#
#   Copyright
#
#       This program is free software; you can redistribute it and/or
#       modify it under the terms of the GNU General Public License as
#       published by the Free Software Foundation; either version 2 of
#       the License, or (at your option) any later version.
#
#       This program is distributed in the hope that it will be useful, but
#       WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#       General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with program; see the file COPYING. If not, write to the
#	Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
#	Boston, MA 02110-1301, USA.
#
#       Visit <http://www.gnu.org/copyleft/gpl.html>
#
#   WARNING
#
#       If this the name of the file is not "cygbuild" or
#       "cygbuild.sh", then it has been auto-generated and you are
#       looking at the result of packaging script. IN THAT CASE YOU
#       SHOULD NOT TRY TO USE THIS FILE FOR ANYTING ELSE THAN CALLING
#       COMMANDS LIKE "all" or "-h" TO BUILD THE CYGWIN BINARY PACKAGE
#
#   Code notes
#
#       o   Call program with option -h for quick help
#       o   Global variables ARE_LIKE_THIS and local variables are areLikeThis
#       o   GNU programs are required. grep(1), egrep(1), awk(1) etc.
#
#   MISCELLANEOUS SCRATCHBOARD
#
#     Packages without a patch file?
#
#        http://sources.redhat.com/ml/cygwin-apps/2003-01/msg00248.html
#
#     Preremove and others
#
#        Preremove is to do things like removing cached rebased .dll
#        files etc - things you can only do while the rest of your
#        package is installed. postremove is to do cleanup that you
#        cannot do while the rest of your package is installed.
#
#     Other notes
#
#       Daniel Reed <n@ml.org> writes 2003-10-14 in cygwin-apps-L
#       http://sources.redhat.com/ml/cygwin-apps/2002-07/msg00144.html
#
#       prefix=/usr/X11R6
#       includedir=${prefix}/include    # /usr/X11R6/include
#       sysconfdir=/etc
#       localstatedir=/var
#
#       exec_prefix=${prefix}
#       bindir=${exec_prefix}/bin       # /usr/X11R6/bin
#       libdir=${exec_prefix}/lib       # /usr/X11R6/lib
#
#       datadir=/usr/share
#       pkgdatadir=${datadir}/${PACKAGE_TARNAME}-${PACKAGE_VERSION}
#                                       # /usr/share/tcm-2.20
#       docdir=${datadir}/doc           # /usr/share/doc
#       pkgdocdir=${docdir}/${PACKAGE_TARNAME}-${PACKAGE_VERSION}
#                                       # /usr/share/doc/tcm-2.20
#       cygdocdir=${docdir}/Cygwin      # /usr/share/doc/Cygwin
#       mandir=${datadir}/man           # /usr/share/man
#       man1dir=${mandir}/man1          # /usr/share/man/man1
#
#
#       If you use:
#       --prefix=/usr/X11R6 \
#       --sysconfdir=/etc \
#       --libexecdir=/usr/lib \
#       --localstatedir=/var \
#       --datadir=/usr/share \
#       --mandir='${datadir}/man' \
#       --infodir='${datadir}/info'
#
#       or:
#       --prefix=/usr \
#       --exec-prefix=/usr/X11R6 \
#       --includedir=/usr/X11R6/include \
#       --sysconfdir=/etc \
#       --libexecdir=/usr/lib \
#       --localstatedir=/var \
#       --mandir='${datadir}/man' \
#       --infodir='${datadir}/info'
#
#       everything should end up in the proper place. The last few lines in
#       both are because mandir and infodir default to ${prefix}/man and
#       ${prefix}/info, libexec defaults to ${exec_prefix}/libexec,
#       sysconfdir defaults to ${prefix}/etc, and localstatedir defaults to
#       ${prefix}/var.
#       not sure if this is what existing X packages use, but this seems
#       to be the latest reference to paths from the archive.

CYGBUILD_HOMEPAGE_URL="http://freshmeat.net/projects/cygbuild"
CYGBUILD_VERSION="2007.0907.1219"
CYGBUILD_NAME="cygbuild"

#######################################################################
#
#       Initial shell check
#
#######################################################################

#   Check correct shell and detect user mistakes like this:
#
#       sh ./our-file.sh
#
#   The following will succeed under bash, but will give error under sh

    eval "[[ 1 ]]" 2> /dev/null

    #   Check result, do we need to exchange shell?

    if [ "$?" != "0" ] ; then

	prg="$0"

	# If we did not find ourselves, most probably we were run as
        # 'sh # COMMAND' in which case we are not to be found in the path.

	if [ -f "$prg" ]; then
	    [ -x /bin/bash ] && exec /bin/bash "$prg" ${1+"$@"}
	fi

        echo $CYGBUILD_ID >&2
        echo "$0 [FATAL] Called with wrong shell. This is a bash script" >&2
        exit 1
    fi

shopt -s extglob      # Use extra pattern matching options

LC_ALL=C              # So that sort etc. works as expected.
LANG=C

function CygbuildBootVariablesId()
{
    #######################################################################
    #
    #       Public ENVIRONMENT VARIABLES: User settings
    #
    #######################################################################

    #   These variables are used only when command [publish] is run.
    #   The ready bin and source packages are either:
    #
    #   1) passed to script (or bash function) $CYGBUILD_PUBLISH_BIN
    #   2) or copied into separate subdirectory pointed by
    #      $CYGBUILD_PUBLISH_DIR. Separate subdirectories are created for
    #      each published package before copying files.

    CYGBUILD_PUBLISH_BIN=${CYGBUILD_PUBLISH_BIN:-""}
    CYGBUILD_PUBLISH_DIR=${CYGBUILD_PUBLISH_DIR:-"/usr/src/cygwin-packages"}

    #######################################################################
    #
    #       Private: program startup and name
    #
    #######################################################################

    #  Be cautious with the PATH. Putting /bin etc. first make finding
    #  programs faster.

    PATH="/bin:/sbin:/usr/bin:/us/sbin:/usr/local/bin:$PATH"
    TEMPDIR=${TEMPDIR:-${TEMP:-${TMP:-/tmp}}}

    if [ "" ]; then  # Disabled, work for CVS Id strings only

        CYGBUILD_VERSION=${CYGBUILD_ID##*,v[ ]}
        CYGBUILD_VERSION=${CYGBUILD_VERSION%%[ ]*}

        #   This could be more easily done in sed or awk, but it is faster to use
        #   bash to convert YYYY/MM/DD into ISO8601 format YYYY-MM-DD

        CYGBUILD_DATE=${CYGBUILD_ID#*.[0-9][0-9][0-9][ ]}   # Delete leading
        CYGBUILD_DATE=${CYGBUILD_DATE%%[ ]*}                # And trailing
        CYGBUILD_DATE=${CYGBUILD_DATE//\//-}       # And substitute / with -
    fi

    CYGBUILD_PROGRAM="Cygbuild $CYGBUILD_DATE $CYGBUILD_VERSION"

    #  Function return values are stored to files, because bash cannot call
    #  function with parameters in running shell environment. The only way to
    #  call bash function and collect its value would:
    #
    #       local val=$(FunctionName "param")
    #
    #  But because this is a subshell call, any variables defined globally
    #  ina "func" would vanish after 'func' finishes. This is also slow.
    #
    #  To call a function, which sets global variables, it must be done like
    #  this. The return value is stored to file and the result is then read.
    #  The return value file must be made unique to each function with
    #  bash $FUNCNAME variable.
    #
    #       local retval=$RETVAL.$FUNCNAME
    #       FunctionName "param" > $retval
    #       local val=$(< $retval)

    CYGBUILD_RETVAL="$TEMPDIR/$CYGBUILD_NAME.tmp.${LOGNAME:-$USER}$$"
}

function CygbuildBootVariablesCache()
{
    #######################################################################
    #
    #       Private: CACHE VARIABLES; remember last function call values
    #
    #######################################################################

    # path to module cygbuild.pl
    declare -a CYGBUILD_STATIC_PERL_MODULE
    declare -a CYGBUILD_STATIC_ABSOLUTE_SCRIPT_PATH  # (bin path)

    declare -a CYGBUILD_STATIC_VER_ARRAY             # (pkg ver release)
    declare CYGBUILD_STATIC_VER_PACKAGE=""
    declare CYGBUILD_STATIC_VER_VERSION=""
    declare CYGBUILD_STATIC_VER_RELEASE=""
    declare CYGBUILD_STATIC_VER_STRING=""
}

function CygbuildBootVariablesGlobal ()
{
    #######################################################################
    #
    #       Private: Unpack sript variables
    #
    #######################################################################

    #   If this file is named like foo-2.1-1.sh then this is part of
    #   the source archive. These variables get set during Main()

    SCRIPT_FULLPATH=         # /path/to/foo-2.1-1.sh
    SCRIPT_FILENAME=         # foo-2.1-1.sh
    SCRIPT_PKGVER=           # foo-2.1
    SCRIPT_PACKAGE=          # foo
    SCRIPT_VERSION=          # 2.1
    SCRIPT_RELEASE=          # 1

    #######################################################################
    #
    #       Private: directories
    #
    #######################################################################

    #   From this directory the [files] command copies template files.
    #   Don't change. The location is in cygbuild's Makefile 'install'
    #   target as well.

    CYGBUILD_ETC_DIR=/etc/cygbuild
    CYGBUILD_CONFIG_PROGRAMS=$CYGBUILD_ETC_DIR/programs.conf
    CYGBUILD_TEMPLATE_DIR_USER=$CYGBUILD_ETC_DIR/template
    CYGBUILD_CONFIG_MAIN=$CYGBUILD_ETC_DIR/cygbuild.conf

    CYGBUILD_SHARE_DIR=/usr/share/cygbuild
    CYGBUILD_TEMPLATE_DIR_MAIN=$CYGBUILD_SHARE_DIR/template

    local tmp=$CYGBUILD_SHARE_DIR/lib/cygbuild.pl
    [ -f "$tmp" ] && CYGBUILD_STATIC_PERL_MODULE=$tmp

    CYGBUILD_CACHE_DIR=/var/cache/cygbuild
    CYGBUILD_CACHE_PAKAGES=$CYGBUILD_CACHE_DIR/packages

    #  Like: <file>.$CYGBUILD_SIGN_EXT
    CYGBUILD_GPG_SIGN_EXT=.sig

    #######################################################################
    #
    #       Private: install options and other variables
    #
    #######################################################################

    #  This variable holds bash match expressions for files to exclude
    #  from original sources while copying the user documentation to
    #  /usr/share/Cygwin/<package-version>
    #
    #  E.g. BCC_MAKEFILE, WCC_MAKEFILE, Makefile.am ... => drop
    #
    #  Note: This variable lists bash '==' tests to exlude files that contain
    #  BIG letters. See separate tar exclude variable for all other files.

    CYGBUILD_INSTALL_IGNORE="
    *Makefile* *makefile* *MAKEFILE* *CVS *RCS *MT
    *.bak *.BAK *.in
    *MANIFEST
    *VMS*
    *CHANGES-*
    *README.vms
    *README.hp*
    *README.*bsd*
    *INSTALL.unx
    *INSTALL.unix
    *RISC-*
    *.TST
    "

    #  This variable holds bash match expressions for files to exclude
    #  check of zero length files. The expression may contain patch
    #  componen match of the file. Files are find(1) collected under
    #  install directory.

    CYGBUILD_IGNORE_ZERO_LENGTH="*+(__init__.py)"

    #   This is egrep(1) match for files found in toplevel. Case sensitive.

    CYGBUILD_SHADOW_TOPLEVEL_IGNORE="\
[.](build|s?inst)\
|(CVS|RCS|MT|[.]svn|[.]bzr|[.]hg)$\
|[.]([oa]|exe|la|dll)$\
"

    #   Accept X11 manual pages: package.1x

    CYGBUILD_MAN_SECTION_ADDITIONAL="[x]"

    #  When determining if file is Python or Perl etc, ignore compiled
    #  or library files e.g. under directory:
    #
    #    /usr/bin/lib/python<ver>/site-packages/<package>/
    #
    #  This is bash extglob pattern.

    CYGBUILD_IGNORE_FILE_TYPE="\
*@(python*/site-packages*\
|*.pyc|*.pm|.tmpl|.tmp|.dll)"

    CYGBUILD_IGNORE_ETC_FILES="\
*@(preremove|postinstall|bash_completion.d)*"

    #######################################################################
    #
    #       Private: various option arguments to programs
    #
    #######################################################################

    #   Global options for making packages (source, binary, devel)
    #   .svn = See http://subversion.tigris.org/
    #   .bzr = bazaar-ng http://bazaar-ng.org/
    #   .hg  = Mercurical http://www.serpentine.com/mercurial
    #   MT   = See http://www.venge.net/monotone/
    #
    #   The lowercase variables are used only in this section.
    #   The uppercase variables are globals used in functions.

    cygbuild_opt_exclude_version_control="\
     --exclude=CVS \
     --exclude=MT \
     --exclude=RCS \
     --exclude=SCCS \
     --exclude=*,v \
     --exclude=.git \
     --exclude=.bzr \
     --exclude=.hg \
     --exclude=.svn \
     --exclude=.cvsignore \
     --exclude=.svnignore \
     --exclude=.hgignore \
     --exclude=.bzrignore \
    "

    #  This is template file, do not include in patch.

    cygbuild_opt_exclude_cygbuild="\
      --exclude=vc-cvs-checkout.sh\
    "

    #   RCS and CVS version control tags cause conflicts in patches.
    #   See ident(1)

    opt_ignore_version_control="\
     --ignore-matching-lines=[$]Author.*[$] \
     --ignore-matching-lines=[$]Date.*[$] \
     --ignore-matching-lines=[$]Header.*[$] \
     --ignore-matching-lines=[$]Id.*[$] \
     --ignore-matching-lines=[$]Locker.*[$] \
     --ignore-matching-lines=[$]Log.*[$] \
     --ignore-matching-lines=[$]Name.*[$] \
     --ignore-matching-lines=[$]RCSfile.*[$] \
     --ignore-matching-lines=[$]Revision.*[$] \
     --ignore-matching-lines=[$]Source.*[$] \
     --ignore-matching-lines=[$]State.*[$] \
    "

    # joe(1) editor leaves DEADJOE files on non-clean exit.

    cygbuild_opt_exclude_tmp_files="\
     --exclude=*.BAK \
     --exclude=*.bak \
     --exclude=*.cvsignore \
     --exclude=*.dvi \
     --exclude=*.log \
     --exclude=*.orig \
     --exclude=*.ps  \
     --exclude=*.eps  \
     --exclude=*.rej \
     --exclude=*.stackdump \
     --exclude=*.swp \
     --exclude=*.tmp \
     --exclude=*.TST \
     --exclude=*.tst \
     --exclude=*[~#] \
     --exclude=.[~#]* \
     --exclude=.emacs_[0-9]* \
     --exclude=.nfs* \
     --exclude=[~#]* \
     --exclude=a.out \
     --exclude=core \
     --exclude=DEADJOE \
    "

    #  GNU automake files
    cygbuild_opt_exclude_auto_files="\
     --exclude=*.in \
     --exclude=*.am \
    "
    cygbuild_opt_exclude_info_files="\
     --exclude=*.info \
     --exclude=*.info-[0-9] \
     --exclude=*.info-[0-9][0-9] \
    "

    cygbuild_opt_exclude_man_files="\
     --exclude=*.man \
     --exclude=*.[0-9] \
     --exclude=man \
    "

    cygbuild_opt_exclude_bin_files="\
     --exclude=*.exe \
     --exclude=*.bin \
     --exclude=*.gif \
     --exclude=*.ico \
     --exclude=*.ICO \
     --exclude=*.jpg \
     --exclude=*.png \
     --exclude=*.pdf \
     --exclude=*.pyc \
     --exclude=*.xpm \
    "

    # *.elc = Emacs lisp compiled files
    cygbuild_opt_exclude_object_files="\
     --exclude=*.o \
     --exclude=*.lo \
     --exclude=*.elc \
    "

    cygbuild_opt_exclude_library_files="\
     --exclude=*.a \
     --exclude=*.la \
     --exclude=*.sa \
     --exclude=*.dll \
     --exclude=*.dll.a \
    "

    cygbuild_opt_exclude_archive_files="\
     --exclude=*.[zZ] \
     --exclude=*.arj \
     --exclude=*.bz2 \
     --exclude=*.gz \
     --exclude=*.rar \
     --exclude=*.tar \
     --exclude=*.tbz \
     --exclude=*.tgz \
     --exclude=*.zip \
     --exclude=*.zoo \
    "

    cygbuild_opt_exclude_dir="\
     --exclude=.build \
     --exclude=.inst \
     --exclude=.sinst \
     --exclude=debian \
     --exclude=tmp \
    "

    #  1) When making snapshot copy of the original sources to elsewhere.
    #  2) when building Cygwin Net Release source and binary packages

    CYGBUILD_TAR_EXCLUDE="\
     $cygbuild_opt_exclude_dir \
     $cygbuild_opt_exclude_object_files \
     $cygbuild_opt_exclude_tmp_files \
     $cygbuild_opt_exclude_version_control \
    "

    #   What files to ignore while running CygbuildInstallPackageDocs
    #   Manual files are already handled by "make install". If not,
    #   then you better write custom install script or hack the original
    #   Makefile
    #
    #   *.yo => yodl files (aterm)

    CYGBUILD_TAR_INSTALL_EXCLUDE="\
     --exclude=*.xml \
     --exclude=*.xsl \
     --exclude=*.sgml \
     --exclude=*.yo \
     --exclude=*.pretbl \
     --exclude=Makefile* \
     --exclude=stamp-vti \
     --exclude=*-sh \
     --exclude=*RISC* \
     --exclude=*bsd* \
     --exclude=*.hp* \
     $cygbuild_opt_exclude_man_files \
     $cygbuild_opt_exclude_info_files \
     $cygbuild_opt_exclude_auto_files \
     $cygbuild_opt_exclude_library_files \
     $cygbuild_opt_exclude_object_files \
     $cygbuild_opt_exclude_tmp_files \
     $cygbuild_opt_exclude_version_control \
    "

    CYGBUILD_CVSDIFF_OPTIONS="\
     --unified \
     --recursive \
     --new-file \
     --ignore-all-space \
     --ignore-blank-lines \
     $opt_ignore_version_control \
     --exclude=config.* \
     --exclude=*.cache \
     $cygbuild_opt_exclude_archive_files \
     $cygbuild_opt_exclude_library_files \
     $cygbuild_opt_exclude_object_files \
     $cygbuild_opt_exclude_bin_files \
     $cygbuild_opt_exclude_dir \
     $cygbuild_opt_exclude_tmp_files \
     $cygbuild_opt_exclude_version_control \
     $cygbuild_opt_exclude_cygbuild\
    "

    CYGBUILD_DIFF_OPTIONS="\
     --unified \
     --recursive \
     --new-file \
     $opt_ignore_version_control \
     --exclude=.deps \
     --exclude=*.gmo \
     --exclude=*.Plo \
     --exclude=*.Tpo \
     --exclude=*.Po \
     --exclude=config.cache \
     --exclude=config.log \
     --exclude=*.cache \
     $cygbuild_opt_exclude_archive_files \
     $cygbuild_opt_exclude_library_files \
     $cygbuild_opt_exclude_object_files \
     $cygbuild_opt_exclude_bin_files \
     $cygbuild_opt_exclude_dir \
     $cygbuild_opt_exclude_tmp_files \
     $cygbuild_opt_exclude_version_control \
     $cygbuild_opt_exclude_cygbuild\
    "

    #  --forward  Ignore patches that seem to be reversed
    #  --strip=N  Strip the smallest prefix containing num leading slashes
    #             setting 0 gives the entire file name unmodified
    #  --fuzz=N   Set the maximum fuzz factor.(default is 2)

    CYGBUILD_PATCH_OPT="\
     --strip=0 \
     --forward \
     --fuzz=3 \
    "

    #  Files that can be regenerated (which can be deleted)
    CYGBUILD_FIND_OBJS="\
     -name *.o \
     -name *.a \
     -name *.la \
     -name *.exe \
     -name *.dll \
    "

    CYGBUILD_FIND_EXCLUDE="\
     -name .build \
     -name .inst \
     -name .sinst \
     -name debian \
     -name tmp \
     -name *[#~]* \
     -name *.bak \
     -name *.orig \
     -name *.rej \
    "

    #   A bash [[ ]] match pattern to check which files are executables
    #   and would need chmod 755

    CYGBUILD_MATCH_FILE_EXE="*.+(pl|py|sh|bash|ksh|zsh)"
}

function CygbuildBootFunctionExport()
{
    local id="$0.$FUNCNAME"

    #   Externally called custom scripts may want to call back to us
    #   and refer to these functions

    export -f CygbuildCmdPrepPatch
    export -f CygbuildMakeRunInstallFixPerl
    export -f CygbuildPostinstallWrite
    export -f CygbuildVersionInfo
    export -f CygbuildDetermineReadmeFile
    export -f CygbuildLibInstallEnvironment
    export -f CygbuildCmdPublishToDir
    export -f CygbuildPatchFindGeneratedFiles
}

#######################################################################
#
#       EXPORTED: This function is available to external scripts
#
#######################################################################

function CygbuildLibInstallEnvironment()
{
    local id="$0.$FUNCNAME"

    #   This function can be used in install.sh, so that it can set up
    #   all the environment variables at startup
    #
    #   Include it as a first call:
    #
    #       CygbuildLibEnvironmentInstall $* && InstallUsingMake && ..

    instdir=${1:-""}      # ROOT DIR passed to script
    instdir=${instdir%/}  # Delete trailing slash

    export instdir
    export exec_instdir=$instdir

    export bindir=$instdir/usr/bin
    export includedir=$instdir/usr/include
    export libdir=$instdir/usr/lib
    export infodir=$instdir/usr/share/info
    export datadir=$instdir/usr/share
    export mandir=$instdir/usr/share/man
    export localstatedir=/var
    export includedir=$instdir/include

    export docdir=$instdir/$CYGBUILD_DOCDIR_FULL

    export infobin="/usr/bin/install-info"

    export INSTALL=${CYGWIN_BUILD_INSTALL:-"/usr/bin/install"}
    export INSTALL_DATA=${CYGWIN_BUILD_F_MODES:-"-m 644"}
    export INSTALL_BIN=${CYGWIN_BUILD_X_MODES:-"-m 755"}
}

#######################################################################
#
#       Error functions
#
#######################################################################

function CygbuildVerb()
{
    if [ "$verbose" ] && [ "$1" ]; then
        echo -e "$*"
    fi
}

function CygbuildVerbWarn()
{
    if [ "$verbose" ] ; then
        echo -e "$@" >&2
    fi
}

function CygbuildWarn()
{
    echo -e "$@" >&2
}

function CygbuildExit()
{
    local code=${1:-1}
    shift

    if [ $# -gt 0 ]; then
        CygbuildWarn "$@"
    fi

    exit $code
}

function CygbuildDie()
{
    CygbuildExit 1 "$@"
}

function CygbuildExitNoDir()
{
    local dir="$1"
    shift

    if [[ ! -d "$dir" ]]; then
        CygbuildDie "$@"
    fi
}

function CygbuildExitNoFile()
{
    local file="$1"
    shift

    if [[ ! -f "$file" ]]; then
        CygbuildDie "$@"
    fi
}

#######################################################################
#
#       Utility functions
#
#######################################################################

function CygbuildAskYes()
{
    echo -n -e "$* (y/N) "
    local ans
    read ans

    [[ "$ans" == [yN]* ]]
}

function CygbuildPushd()
{
    pushd . > /dev/null
}

function CygbuildPopd()
{
    popd > /dev/null
}

function CygbuildRun()
{
    ${test+echo} "$@"
}

function CygbuildFileDeleteLine ()
{
    local regexp="$1"
    local file="$2"
    local tmp="$file.$$.tmp"

    if [ "$regexp" ] && [ -e "$file" ]; then
        $EGREP --invert-match --regexp="$regexp" $file > $tmp &&
        $MV $tmp $file
    fi
}

function CygbuildFileDaysOld ()
{
    local file="$1"

    if [ -f "$file" ]; then
        echo -n $file | $PERL -ane "print -M"
    else
        return 1
    fi
}

function CygbuildGrepCheck()
{
    local regexp="$1"
    shift

    $EGREP --ignore-case            \
           --files-with-matches     \
           --regexp="$regexp"       \
           "$@" /dev/null           \
           > /dev/null 2>&1
}

function CygbuildChmodExec()
{
    local bin

    for bin in "$@"
    do
        if [ -f "$bin" ] && [ ! -x "$bin" ]; then
            chmod +x $bin
        fi
    done
}

CygbuildCygcheckLibraryDepList ()
{
    local id="$0.$FUNCNAME"
    local file="$1"

    # $data file includes output of cygcheck:
    #
    # D:\cygwin\bin\cygwin1.dll
    #   C:\WINNT\system32\ADVAPI32.DLL
    #     C:\WINNT\system32\NTDLL.DLL
    #     C:\WINNT\system32\KERNEL32.DLL
    #     C:\WINNT\system32\RPCRT4.DLL
    # D:\cygwin\bin\cygfontconfig-1.dll
    #   D:\cygwin\bin\cygexpat-0.dll
    #   D:\cygwin\bin\cygfreetype-6.dll
    #     D:\cygwin\bin\cygz.dll

    $AWK -F\\ \
    '
        ! /cygwin.*dll/ {
            next;
        }

        /cygwin1.dll/ {
            if ( match($0, "^ +") > 0 )
            {
                #  How much initial indentation there is
                minus = RLENGTH;
            }
            next;
        }

        /dll/ {
            file  = $(NF);
            space = "";

            if ( match($0, "^ +") > 0 )
            {
                space = substr($0, RSTART, RLENGTH - minus);
            }

            print space file;
        }
    ' "$file"
}

CygbuildCygcheckLibraryDepSource ()
{
    local id="$0.$FUNCNAME"

    #  Sometimes programs have direct shell calls like
    #
    #  execvp("/bin/diff")

    if $FIND $builddir -name "*.c" -o -name "*.cc" |
       $EGREP "^[^/]*exec[a-z]* *\("
    then
        CygbuildWarn "-- [WARN] External shell call detected. More dependencies"
          "may be needed. (an example: binutils)"
    fi
}

function CygbuildCygcheckLibraryDepAdjustOld()  # NOT USED
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local file="$1"     # modifes file directly

    local setup="$DIR_CYGPATCH/setup.hint"
    local list lib

    # You *CAN*T tell all these deps from the indented level
    # See discussion
    # http://cygwin.com/ml/cygwin-apps/2007-08/msg00215.html
    #
    # D:\cygwin\bin\cygintl-8.dll
    #   D:\cygwin\bin\cygiconv-2.dll

    $SED 's/ \+/- /' "$file" > $retval  # convert leading spaces to "-"

    while read minus lib
    do
        if [ "$minus" = "-" ]; then
            list="$list $lib"
            CygbuildFileDeleteLine "$lib" "$file" || return 1
        fi
    done < $retval

    for lib in $list
    do
        if $EGREP --quiet "^ *requires:.*\<$lib" $setup ; then
            CygbuildWarn "-- [NOTE] setup.hint maybe unnecessary depends $lib"
        fi
    done
}

function CygbuildCygcheckLibraryDepAdjust()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local file="$1"  # modifes file directly

    local setup="$DIR_CYGPATCH/setup.hint"
    local list lib

    for lib in $(< $file)
    do

      #  libintl already requires iconv

      if [[ "$lib" == *iconv* ]] && $EGREP --quiet 'intl' $file
      then
          CygbuildFileDeleteLine "$lib" "$file" || return 1

          if $EGREP --quiet "^ *requires:.*\<$lib" $setup ; then
              CygbuildWarn "-- [NOTE] setup.hint maybe unnecessary depends $lib"
          fi
      fi
    done
}

function CygbuildCygcheckLibraryDepReadme()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local file="$1"
    local readme="$DIR_CYGPATCH/$PKG.README"
    local lib

    for lib in $(< $file)
    do
        if ! $EGREP --quiet " \<$lib" $readme
        then
            CygbuildWarn "-- [ERROR] $PKG.README does not mention $lib"
        fi
    done
}

CygbuildCygcheckLibraryDepSetup ()
{
    local id="$0.$FUNCNAME"
    local file="$1"
    local lib

    #  Check that all are listed

    for lib in $(< $file)
    do
        if ! $EGREP --quiet "^ *requires:.*\<$lib\>" $setup
        then
            CygbuildWarn "-- [ERROR] setup.hint lacks $lib"
        fi
    done
}

function CygbuildCygcheckLibraryDepGrepPgkNames()
{
    #   NOTE: informational messages are written to stderr
    #   because this function returns list of depends.

    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local file="$1"  # list of library names

    local cache=/var/cache/cygbug/package/list/file.lst

    if [ ! -f $cache ]; then
        CygbuildWarn "-- [NOTE] Cache not found $cache"
        return 1
    fi

    if [ ! "$file" ] || [ ! -e $file ]; then
        CygbuildDie "[FATAL] $id: empty 'file' argument"
    fi

    # Cache lines in format: <package path>:<tar listing>.
    # Here is example of the "path":
    # .../release/X11/xorg-x11-bin-dlls/xorg-x11-bin-dlls-6.8.99.901-1.tar.bz2

    #   Always depends on this

    echo "cygwin" > $retval.collect

    $TR '\n' ',' < $file > $retval
    local list=$(< $retval)

    local lib list
    $AWK -F: \
    '
        function setup(val, name, space, i, len) {
            len = split(liblist, arr, ",");

            #  Convert "A,  B,C, D" into
            #  re = "(A|B|C)$"

            for (i=1; i < len ; i++)
            {
                val   = arr[i];
                name  = val;
                space = "";

                if ( match (val, "^ +") > 0 )
                {
                    space = substr(val, 1, RLENGTH);
                }

                if ( match (val, "[^ ]+") > 0 )
                {
                    name = substr(val, RSTART, RLENGTH);
                }

                HASH[name] = space;

                if ( add )
                {
                    RE = RE "|" name;
                }
                else
                {
                    RE  = name;
                    add = 1;
                }
#print i " VAL [" val "] space [" space "] RE [" RE "]";
            }

            if ( length(RE) > 0 )
            {
                RE = "(" RE ")$";
            }
        }

        {
            if ( ! boot )
            {
                setup();
                boot = 1;
            }

            if ( match($0, RE) > 0 )
            {
                lib   = substr($0, RSTART, RLENGTH);
                space = HASH[lib];

                path=$1;
                gsub(".*/", "", path);
                gsub("-[0-9].*", "", path);

                DEPENDS[lib]   = path;
                DEP_SPACE[lib] = space;  # Save indentation information
            }
        }

        END {
            for (name in HASH)
            {
                dep = DEPENDS[name];

                if ( dep == "" )
                {
                    dep ="... cannot determine depends";
                }

                printf("%-25s %s\n", name, dep);
            }
        }

    ' liblist="$list" $cache > $retval.tmp

    if [ -s $retval.tmp ]; then
        $SED 's/^/   /' $retval.tmp >&2
        $AWK '! /cannot/ {print $2}' $retval.tmp >> $retval.collect
    fi

    [ -s $retval.collect ] && $CAT $retval.collect
}

function CygbuildCygcheckLibraryDepMain()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local file="$1"
    local data="$2"

    local setup="$DIR_CYGPATCH/setup.hint"

    #   Do it in three phases:
    #   1) use awk to get dll name, like 'cygz.dll'
    #   2) use fgrep to get all lines match�ng the dlls
    #   3) process the fgrep results to extract package name

    echo "-- Trying to resolve depends for $file"

    CygbuildCygcheckLibraryDepList   "$data" > $retval
    CygbuildCygcheckLibraryDepSource

    if CygbuildCygcheckLibraryDepGrepPgkNames $retval > $retval.pkglist
    then
        CygbuildCygcheckLibraryDepReadme $retval.pkglist
        CygbuildCygcheckLibraryDepAdjust $retval.pkglist

        echo "   DEPENDS SUMMARY:"
        $SED 's/^ \+//' $retval.pkglist | $SORT -u | $SED 's/^/   /'

        CygbuildCygcheckLibraryDepSetup $retval.pkglist
    fi
}

function CygbuildCygcheck()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local file path
    local bin="/usr/bin/cygpath"

    if [ -x "$bin" ]; then
        CygbuildWarn "[ERROR] $id: Not exists $path"
        return 1
    fi

    for file in "$@"
    do
        if /usr/bin/cygpath --windows "$file" > $retval
        then
            path=$(< $retval)
            /usr/bin/cygcheck $path | tee $retval

            CygbuildCygcheckLibraryDepMain "$path" "$retval"
        fi
    done
}

function CygbuildCheckRunDir()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    #  Do just a quick sweep, nothing extensive

    if [[ "$(pwd)" == *+(.sinst|.build|.inst|CYGWIN-PATCHES)* ]]
    then
        CygbuildWarn "-- [WARN] Current directory is not source ROOT"
    fi
}

function CygbuildVersionInfo()
{
    local id="$0.$FUNCNAME"
    local str="$1"

    #   Debian uses scheme: package_VERSION-REL.orig.tar.gz
    #
    #   1. Delete path and see if the last name matches:
    #
    #       /this/dir/package-NN.NN
    #       /this/dir/package-YYYYMMDD
    #
    #   2. If that does not work, then perhaps the package is being
    #   verified:
    #
    #       /usr/src/build/neon/foo-NN.NN/.build/tmp/verify
    #

    echo -n "$str" | $PERL -e \
    '
        $_  = <>;
        s,.+/,,;
        s,(-src)?(\.orig)?\.(tar\.(gz|bz2)|zip|t[gb]z),,;

        # Remove release number (if any)
        # e.g. xterm-299, where 229 is NOT a release to be removed

        s,([_-]\d.*)-[0-9]+$,$1,;

        @a = (/^(.+?)[-_](\d.*)/);

        if ( @a )
        {
            print qq(@a\n);
        }
        elsif ( @a = ( m,/([^/]+)-([\d.]+\d)-?(\d+)*, ) )
        {
            print qq(@a\n);
        }
    ' || exit 1
}

function CygbuildDefileInstallVariables()
{
    local id="$0.$FUNCNAME"

    local prefix=${1:-"usr"}
    local prefix_man=${2:-"share/man"}
    local prefix_info=${3:-"share/info"}
    local prefix_data=${4:-"share"}
    local prefix_sysconf=${5:-"/etc"}

    local prefix_lib=${6:-"lib"}
    local prefix_inc=${7:-"include"}
    local prefix_doc=${8:-"share/doc"}
    local prefix_state=${9:-"/var"}
    local prefix_libexec=${10:-"lib"}

    if [[ "$prefix" == /* ]]; then
        CygbuildDie "[ERROR] Can't use abosolute prefix value: $prefix" \
               "the install will always happen into subdirectory .sinst/"
    fi

    #   Do not add trailing slash. The exports are needed because variables
    #   are used in subshells

    export CYGBUILD_PREFIX=/$prefix                             # global-def
    export CYGBUILD_DOCDIR_PREFIX_RELATIVE=$prefix/share        # global-def
    export CYGBUILD_DOCDIR_RELATIVE=$prefix_doc                 # global-def
    export CYGBUILD_DOCDIR_FULL=$prefix/$prefix_doc             # global-def
    export CYGBUILD_DOCDIRCYG_FULL=$prefix/$prefix_doc/Cygwin   # global-def
    export CYGBUILD_MANDIR_RELATIVE=$prefix_man                 # global-def
    export CYGBUILD_MANDIR_FULL=$prefix/$prefix_man             # global-def
    export CYGBUILD_INFO_FULL=$prefix/$prefix_info              # global-def

    export CYGBUILD_SYSCONFDIR=$prefix_sysconf                  # global-def

    #   Not included:
    #    target=i686-pc-cygwin
    #    host=i686-pc-linux
    #    --host $host
    #    --target $target
    #    --srcdir $srcdir
    #    --includedir $prefix/include

    CYGBUILD_CONFIGURE_OPTIONS="\
 --prefix=$CYGBUILD_PREFIX \
 --exec-prefix=$CYGBUILD_PREFIX \
 --bindir=$CYGBUILD_PREFIX/bin \
 --sysconfdir=$prefix_sysconf \
 --libexecdir=$CYGBUILD_PREFIX/$prefix_libexec \
 --localstatedir=$prefix_state \
 --datadir=$CYGBUILD_PREFIX/$prefix_data \
 --mandir=$CYGBUILD_PREFIX/$prefix_man \
 --infodir=$CYGBUILD_PREFIX/$prefix_info \
 --libdir=$CYGBUILD_PREFIX/$prefix_lib \
 --includedir=$CYGBUILD_PREFIX/$prefix_inc \
"
}

function CygbuildDefileInstallVariablesUSRLOCAL()
{
    CygbuildDefileInstallVariables  \
    "usr/local"                     \
    "man"                           \
    "info"                          \
    "share"                         \
    "/usr/local/etc"
}

function CygbuildDefineVersionVariables()
{
    local id="$0.$FUNCNAME"

    local str="$1"
    local -a arr

    if [ "$CYGBUILD_STATIC_VER_STRING" = "$str" ]; then
        arr=( ${CYGBUILD_STATIC_VER_ARRAY[*]} )
    else

        local retval=$CYGBUILD_RETVAL.$FUNCNAME
        CygbuildVersionInfo "$str" > $retval

        arr=( $(< $retval) )

        dummy="${arr[*]}"  #  For debugging

        CYGBUILD_STATIC_VER_ARRAY=( ${arr[*]} )
    fi

    local count=${#arr[*]}

    if [[ $count -gt 1 ]]; then
        CYGBUILD_STATIC_VER_PACKAGE=${arr[0]}
        CYGBUILD_STATIC_VER_VERSION=${arr[1]}
        CYGBUILD_STATIC_VER_RELEASE=${arr[2]}
        CYGBUILD_STATIC_VER_STRING="$str"
    fi

    #  Return status: Do we have the VERSION?

    local digit2="[0-9][0-9]"
    local yyyy=$digit2$digit2
    local mm=$digit2
    local dd=$digit2

    [[ "$CYGBUILD_STATIC_VER_VERSION" == [0-9]* ]] ||
    [[ "$CYGBUILD_STATIC_VER_VERSION" == $yyyy$mm$dd*  ]]
}

function CygbuildStrRemoveExt()
{
    local id="$0.$FUNCNAME"

    # Remove compression extensions
    # foo-1.13-src.tar.gz => foo-1.13

    local str="$1"

    str=${str##*/}          # Remove path
    str=${str%.tar.bz2}
    str=${str%.tar.gz}
    str=${str%.tgz}
    str=${str%.tbz2}
    str=${str%-src}
    str=${str%.orig}

    echo $str
}

function CygbuildStrPackage()
{
    local id="$0.$FUNCNAME"

    # Like reading PACKAGE-1.13-1-src.tar.gz
    # foo-1.13-1-src.tar.gz => foo

    local str="$1"

    if CygbuildDefineVersionVariables $str ; then
        echo $CYGBUILD_STATIC_VER_PACKAGE
    else
        CygbuildDie "$id: [FATAL] CygbuildDefineVersionVariables($str) failed."
    fi
}

function CygbuildStrVersionRelease()
{
    local id="$0.$FUNCNAME"

    # Like reading foo-VERSION-RELEASE-src.tar.gz
    # foo-1.13-1-src.tar.gz => 1.13-1

    local str="$1"

    if CygbuildDefineVersionVariables $str ; then
        if [ "$CYGBUILD_STATIC_VER_RELEASE" ]; then
            echo $CYGBUILD_STATIC_VER_VERSION-$CYGBUILD_STATIC_VER_RELEASE
        fi
    fi
}

function CygbuildStrRelease()
{
    local id="$0.$FUNCNAME"

    # Like reading foo-1.13-RELEASE-src.tar.gz
    # foo-1.13-1-src.tar.gz => 1

    local str="$1"

    if CygbuildDefineVersionVariables $str ; then
        echo $CYGBUILD_STATIC_VER_RELEASE
    fi
}

function CygbuildStrVersion()
{
    local id="$0.$FUNCNAME"

    # Like reading foo-VERSION-1-src.tar.gz
    # foo-1.13-1-src.tar.gz => 1.13

    local str="$1"

    if CygbuildDefineVersionVariables $str ; then
        echo $CYGBUILD_STATIC_VER_VERSION
    fi
}

function CygbuildMatchRegexp()
{
    #   Argument 1: regexp
    #   Argument 2: string to match

    if [[ ${BASH_VERSINFO[0]} == 3 ]]; then
        [[ $2 =~ $1 ]]
    else
        echo "$2" | $EGREP -q "$1"
    fi
}

function CygbuildMatchBashPatternList()
{
    local str="$1"

    [ ! "$str" ] && return 1

    shift
    local ret=1    # Suppose no match by default
    local match

    #   In for loop, the patterns in $list
    #   would expand to file names without 'noglob'.

    set -o noglob

        for match in $*
        do
            if  [[ "$str" == $match ]]; then
                ret=0
                break
            fi
        done

    set +o noglob

    return $ret
}

function CygbuildIsGbsCompat()
{
    [ "$OPTION_GBS_COMPAT" ]
}

function CygbuildIsEmpty()
{
    CygbuildMatchRegexp '^[ \t]*$' "$1"
}

function CygbuildIsNumber()
{
    CygbuildMatchRegexp '^[0-9]+$' "$1"
}

function CygbuildIsNumberLike()
{
    CygbuildMatchRegexp '^[0-9]' "$1"
}

function CygbuildIsSrcdirOk()
{
    local exitmsg="$1"

    #  Verify that the source root is well formed package-N.N/

    if [ "$srcdir" ]; then
        if [[ $srcdir == *-*[0-9]* ]]; then
            :
        elif [[ $srcdir == *-*[0-9]*.orig ]]; then
            #   Accept Debian orignal packages
            :
        else
            [ "$exitmsg" ] && CygbuildDie "$exitmsg"
            return 1
        fi
    fi
}

function CygbuildIsBuilddirOk()
{
    # Check if builddir has been populated using shadow.

    if [ "$builddir" ] && [ -d "$builddir" ]; then

        #   some package only contain TOP level directories, so we must
        #   peek inside $builddir/*/* to see if it's symlink (made by
        #   shadow)

        local item

        for item in $builddir/* $builddir/*/*
        do
            [ ! -f "$item" ] && continue

            if [ -h $item ]; then       # First symbolic link means OK
                return 0
            fi
        done
    fi

    return 1
}

function CygbuildDate()
{
    date "+%Y%m%d%H%M"
}

function CygbuildPathBinFast()
{
    #   ARG 1: binary name
    #   ARG 2: possible additional search path like /usr/local/bin

    local bin="$1"
    local try="${2%/}"      # Delete trailing slash

    local dir

    #   If it's not in these directories, then just use
    #   plain "cmd" and let bash search whole PATH

    if [ -x /usr/bin/$bin ]; then
        echo /usr/bin/$bin
    elif [ -x /usr/sbin/$bin ]; then
        echo /usr/sbin/$bin
    elif [ -x /bin/$bin ]; then
        echo /bin/$bin
    elif [ -x /sbin/$bin ]; then
        echo /sbin/$bin
    elif [ "$try" ] && [ -x $try/$bin ]; then
        echo $try/$bin
    else
        echo $bin
    fi
}

function CygbuildPathResolveSymlink()
{
    #   Try to resolve symbolic link.
    #   THIS IS VERY SIMPLE, NOT RECURSIVE if additional
    #   support programs were not available

    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    local bin="$1"
    local path="."

    if [[ $bin == */* ]]; then
        path=${bin%/*}
        bin=${bin##*/}
    fi

    local abs="$path/$bin"
    local try

    if [[ ! -h $abs  &&  $abs == /*  ]]; then

        try="$abs"

    elif [[ ! -h $abs  &&  ($abs == ./* || $abs == ../*) ]]; then

        #   No need for external program, we can find out
        #   this by ourself

        local path=${bin%/*}
        local name=${bin##*/}

        try=$(cd $path; pwd)/$name

    elif [[ "" && -x /usr/bin/chase ]]; then

        #  DISABLED for now.

        /usr/bin/chase "$abs" > $retval

        [ -s $retval ] && try=$(< $retval)

    elif [ -x /usr/bin/readlink ]; then

        #  readlink is unreliable, because it doesn't return path, if the
        #  path is not a symlink. It returns empty.

        /usr/bin/readlink "$abs" > $retval

        if [ -s $retval ]; then
            try=$(< $retval)

            if [ "$try" ] && [[ ! "$try" == */* ]]; then
                try=$path/$try
            fi
        fi

    elif [[ "" && -x /usr/bin/namei ]]; then

        # DISABLED. The output of name cannot be easily parsed,
        # because it doesn't output single path, but a tree notation.
        #
        # d /
        # d usr
        # d src
        # d build
        # d build
        # d xloadimage
        # l xloadimage-4.1 -> xloadimage.4.1
        #   d xloadimage.4.1
        # d .inst
        # d usr
        # d share
        # d man
        # d man1
        # l xsetbg.1 -> xloadimage.1
        #   - xloadimage.1
        #

        /usr/bin/namei $abs \
            | tail -3 \
            | $EGREP --ignore-case ' l .* -> ' \
            > $retval

        if [ -s $retval ]; then
            local -a arr
            arr=( $(< $retval) )

            local count=${#arr[*]}

            if [ "$count" = "4" ]; then
                try=${arr[3]}
            fi
        fi
    fi

    if [ "$try" ]; then
        echo "$try"
    else
        return 1
    fi
}

function CygbuildWhich()
{
    type -p "$1" 2> /dev/null
}

function CygbuildPathAbsoluteSearch()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    local bin="$1"

    if [ ! "$bin" ]; then
        CygbuildWarn "$id: [ERROR] parameter 'bin' is empty"
        return 1
    fi

    if [[ "$bin" != */* ]]; then

        local tmp

        CygbuildWhich $bin > $retval &&
        tmp=$(< $retval)

        #   Perhaps the file was not executable
        [ "$tmp" ] && bin=$tmp
    fi

    local try

    CygbuildPathResolveSymlink "$bin" > $retval
    [ -s $retval ] && try=$(< $retval)

    if [ "$try" ]; then
        bin="$try"
    fi

    echo $bin
}

function CygbuildPathAbsolute()
{
    local id="$0.$FUNCNAME"
    local p="$1"

    if [ "$p" ] && [ -d "$p" ]; then
        p=$(cd $p; pwd)

    elif [[ "$p" == /*  &&  -f "$p" ]]; then
        # Nothing to do, it is absolute already
        true

    elif [[ "$p" == */* ]]; then

        #   Perhaps there is filename too? dir/dir/file.txt
        #   Remove last portion

        local file=${p##*/}
        local dir=${p%/*}

        if [ -d "$dir" ]; then
            dir=$(cd $dir; pwd)
            p=$dir/$file
        fi

    else
        if [ -f "$p" ]; then
            p=$(pwd)/$p
        fi
    fi

    if [ "$p" ]; then
        echo $p
    else
        return 1
    fi
}

function CygbuildCommandPath()
{
    local id="$0.$FUNCNAME"
    local cmd="$1"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    #  Find out where is the absolute location of CMD
    #  a) type: cygbuild.sh is /cygdrive/...
    #  b) type: ls is hashed (/bin/ls)

    if [[ "$cmd" == */* ]]; then
        CygbuildPathAbsolute $cmd > $retval &&
        cmd=$(< $cmd)
    else
        local saved="$IFS"
        local IFS=" "

            #   type is bash built-in command. It's better than which(1)
            #   because it finds also aliases and functions.
            #
            #   NOTE: not using option -p, because it's better to see
            #   error message.

            if type $cmd > $retval ; then
                set -- $(< $retval)
            fi

        IFS="$saved"

        local path=$3

        if [ "$path" = "hashed" ]; then
            path=$4
        fi

        path=${path%)}      # Remove possible parentheses
        path=${path#(}
        cmd=$path
    fi

    if [ "$cmd" ]; then
        echo $cmd
    else
        return 1
    fi
}

function CygbuildScriptPathAbsolute()
{
    local id="$0.$FUNCNAME"
    local bin="$1"

    if [ ! "$bin" ]; then
        CygbuildWarn "$id: [ERROR] parameter 'bin' is empty"
        return 1
    fi

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local -a cache=( ${CYGBUILD_STATIC_ABSOLUTE_SCRIPT_PATH[*]} )
    local ret

    if [[ "${cache[0]}" == $bin* ]]; then
        ret=${cache[1]}
    else
        CygbuildPathAbsoluteSearch "$bin" > $retval &&
        ret=$(< $retval)

        if [ ! "$ret" ]; then
            CYGBUILD_STATIC_ABSOLUTE_SCRIPT_PATH=($bin $ret)
        fi
    fi

    if [ "$ret" ]; then
        echo $ret
    else
        return 1
    fi
}

function CygbuildBuildScriptPath()
{
    local id="$0.$FUNCNAME"

    #   Note, that source packages includes script-VERSION-RELEASE.sh
    #   not just script.sh, so $0 cannot always be used directly.

    local name="$0"

    #   If there is path component, then perhaps script is called
    #   by ./script-NN.NN-1.sh, skip that case

    if [[ "$name" != */*  &&  -f "./$name" ]]; then
        echo $(pwd)/$name

    elif [[ "$name" = ./*  &&  -f "./$name" ]]; then
        name=${name#./}
        echo $(pwd)/$name

    elif [[ "$name" == */*  &&  -f "$name" ]]; then
        echo $name

    else
        name=${name##*/}

        local retval=$CYGBUILD_RETVAL.$FUNCNAME
        CygbuildScriptPathAbsolute $name > $retval
        local path=$(< $retval)

        echo $path
    fi
}

function CygbuildTemplatePath()
{
    local id="$0.$FUNCNAME"
    local ret

    #   Find out where template files are located

    local dir="$CYGBUILD_TEMPLATE_DIR_MAIN"

    if [ -d "$dir" ]; then
        ret=$dir
    else

        local retval=$CYGBUILD_RETVAL.$FUNCNAME
        CygbuildBuildScriptPath > $retval
        dir=$(< $retval)

        #   It is relative to the installation of the *.sh file, this may be an
        #   CVS checkout directory
        #
        #   dir/bin/cygbuild.sh
        #   dir/etc/template        # Here

        dir=${dir%/*}       # Remove filename: /path/to/FILE.SH => /path/to

        if [ -d "$dir/../etc/template" ]; then
            ret=$dir
        elif [ -d "$dir/etc/template" ]; then
            ret=$dir/etc/template
        fi
    fi

    if [ "$ret" ]; then
        echo $ret
    else
        return 1
    fi
}

function CygbuildTarOptionCompress()
{
    local id="$0.$FUNCNAME"

    #   Return correct packaging command based on the filename
    #   .tar.gz or .tgz     => "z" option
    #   .bz2                => "j" option

    case "$1" in
        *tar.gz|*tgz)   echo "z" ;;
        *bz2)           echo "j" ;;
        *)              return 1 ;;
    esac
}

function CygbuildTarDirectory()
{
    #   Return tar packages top level directory if any

    local id="$0.$FUNCNAME"
    local file="$1"

    if [ ! "$file" ]; then
        CygbuildWarn "$id: FILE parameter is empty"
        return 1
    fi

    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    local z
    CygbuildTarOptionCompress $file > $retval
    [ -s $retval ] && z=$(< $retval)

    $TAR -${z}tvf $file > $retval || return $?

    if [ ! -s $retval ]; then
        CygbuildWarn "$id: [ERROR] Can't read content of $file"
        return 1
    fi

    #   $(NF) will give last field from line:
    #   -rw-r--r-- root/root 23206 2004-02-10 02:31:56 foo-20000401-1/COPY
    #
    #   The gsub() calls will handle cases:
    #   a) ./package-nn.nn/
    #   b) package-nn.nn/
    #
    #   Different paths are gathered in HASH (associtive array) and
    #   there will be only one, if top level directory exists.
    #   Skip symbolic links.

    local dirfile=$CYGBUILD_RETVAL.$FUNCNAME.dir

    $AWK  '                             \
        /->/ { next }                   \
        {                               \
            path = $(NF);               \
            gsub("[.]/", "", path );    \
            gsub("/.*", "", path );     \
            hash[ path ] = 1;           \
        }                               \
        END {                           \
            for (i in hash)             \
            {                           \
                print i;                \
            }                           \
        }                               \
        '                               \
        $retval                         \
        > $dirfile

    local status=$?

    if [ "$status" != "0" ]; then
        return $status
    fi

    local lines=$(wc -l $dirfile | cut -d" " -f1)

    if [ "$lines" = "1" ]; then
        echo $(< $dirfile)
    fi
}

function CygbuildMakefileName()
{
    local id="$0.$FUNCNAME"
    local dir=${1:-$(pwd)}
    shift              # Rest of the parameters are other files to try

    local file path

    for file in GNUMakefile Makefile makefile "$@"
    do
        path="$dir/$file"

        if [ -f "$path" ]; then
            echo "$path"
            break
        elif [ -h "$path" ]; then
            CygbuildWarn "-- [ERROR] inconsistent links." \
                 "Perhaps sources moved. Run [reshadow]."
            $LS -la "$path"
            break
        fi
    done
}

function PackageUsesLibtoolMain()
{
    CygbuildGrepCheck \
        '^[^#]*\<libtool\>|--mode=(install|compile|link)'  \
        "$@"
}

function PackageUsesLibtoolCompile ()
{
    CygbuildGrepCheck '--mode=compile' "$@"
}

function MakefileUsesRedirect()
{
    #   Check if the current (top level) makefile use -C

    local id="$0.$FUNCNAME"
    local file="$1"

    if [ ! "$file" ] || [ ! -f "$file" ]; then
        return 1
    fi

    #   See if we can find:  $(MAKE) -C src

    CygbuildGrepCheck '^[^#]+make[) \t]+-C' $file
}

function CygbuildIsMakefileTarget()
{
    local id="$0.$FUNCNAME"
    local target="$1"

    if [ ! "$target" ]; then
        CygbuildDie
    fi

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildMakefileName > $retval
    local file=$(< $retval)

    if [ ! "$file" ]; then
        return 1
    fi

    CygbuildGrepCheck "^$target:" $file

}

function CygbuildIsMakefileCplusplus ()
{
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildMakefileName > $retval
    local file=$(< $retval)

    if [ ! "$file" ]; then
        return 1
    fi

    CygbuildGrepCheck "^[^#]+=[ \t]*g[+][+]" $file
}

function CygbuildMakefileRunTarget()
{
    local id="$0.$FUNCNAME"
    local target="$1"
    local dir="$2"
    local opt="$3"

    [ ! "$dir"    ] && dir=$builddir
    [ ! "$target" ] && target="all"

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildMakefileName $dir > $retval
    local makefile=$(< $retval)

    if [ ! "$makefile" ]; then
        if [ "$opt" != "nomsg" ]; then
            echo "--   No Makefile found, nothing to [$target] in $dir"
        fi
        return
    fi

    CygbuildPushd

        cd $dir  || exit 1

        if CygbuildIsMakefileTarget $target ; then
            $MAKE -f $makefile $target
        elif [ "$verbose" ]; then
            CygbuildWarn "--   [NOTE] No target [$target] in $makefile"
        fi

    CygbuildPopd
}

function CygbuildFileTypeByExtension()
{
    local file="$1"
    local ret

    case "$file" in
        *.sh) ret="shell"   ;;
        *.py) ret="python"  ;;
        *.pl) ret="perl"    ;;
        *) return 1         ;;
    esac

    echo $ret
}

function CygbuildFileTypeByFile()
{
    local file="$1"
    local ret
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local notes

    $FILE $file > $retval
    [ -s $retval ] && notes=$(< $retval)

    if [[ "$notes" == *perl*  ]]; then
        ret="perl"
    elif [[ "$notes" == *python*  ]]; then
        ret="python"
    elif [[ "$notes" == *shell*  ]]; then
        ret="shell"
    elif [[ "$notes" == *executable*  ]]; then
        ret="executable"
    elif [[ "$notes" == *ASCII* ]]; then
        #  Hm, file in disguise. Can we find bang-slash?

        $EGREP '^#!' $file > $retval
        [ -s $retval ] && notes=$(< $retval)

        if [[ "$notes" == *+(bash|/sh|/ksh|/csh|/tcsh) ]]; then
            ret="shell"
        elif [[ "$notes" == *perl* ]]; then
            ret="perl"
        elif [[ "$notes" == *python* ]]; then
            ret="perl"
        fi
    fi

    if [ "$ret" ]; then
        echo $ret
    else
        return 1
    fi
}

function CygbuildFileIgnore()
{
    [[ $1 == $CYGBUILD_IGNORE_FILE_TYPE ]]
}

function CygbuildFileTypeMain()
{
    local file="$1"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    #  We must not check binary files etc.

    CygbuildFileIgnore "$file" && return 10

    CygbuildFileTypeByExtension "$file" > $retval ||
    CygbuildFileTypeByFile      "$file" > $retval ||
    return 1

    echo $(< $retval)
}

function CygbuildIsCvsPackage()
{
    [ -f "$srcdir/CVS/Root" ] &&  [ -f "$srcdir/CVS/Repository" ]
}

function CygbuildIsSvnPackage()
{
    [ -f "$srcdir/.svn/entries" ] &&  [ -d "$srcdir/.svn/props" ]
}

function CygbuildIsMercurialPackage()
{
    [ -f "$srcdir/.hg/data" ] &&  [ -f "$srcdir/.hg/hgrc" ]
}

function CygbuildIsGitPackage()
{
    [ -f "$srcdir/.git/HEAD" ] &&  [ -f "$srcdir/.git/config" ]
}

function CygbuildIsBzrPackage()
{
    [ -f "$srcdir/.bzr/inventory" ] &&  [ -d "$srcdir/inventory-store" ]
}

function CygbuildVersionControlType()
{
    if CygbuildIsCvsPackage ; then
        echo "cvs"
    elif CygbuildIsSvnPackage ; then
        echo "svn"
    elif CygbuildIsGitPackage ; then
        echo "git"
    elif CygbuildIsMercurialPackage ; then
        echo "mercurial"
    elif CygbuildIsBzrPackage ; then
        echo "brz"
    else
        return 1
    fi
}

function CygbuildIsPerlPackage()
{
    [ -f "$srcdir/Makefile.PL" ]
}

function CygbuildIsPythonPackage()
{
    [ -f "$srcdir/setup.py" ]
}

function CygbuildIsAutomakePackage()
{
    [ -f "$srcdir/Makefile.in" ] || [ -f "$srcdir/makefile.in" ]
}

function CygbuildIsAutoconfPackage()
{
    [ -f "$srcdir/configure.in" ]
}

function CygbuildIsAutotoolPackage()
{
    CygbuildIsAutomakePackage && CygbuildIsAutoconfPackage
}

function CygbuildIsX11Package()
{
    local id="$0.$FUNCNAME"
    local status=1              # Failure by defualt

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildMakefileName $(pwd) Makefile.in > $retval
    local file=$(< $retval)

    if [ -f "$file" ]; then
        CygbuildGrepCheck "/X11/" $file
        status=$?
    fi

    return $status
}

function CygbuildIsX11appDefaults()
{
    local status=1              # Failure by defualt

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildMakefileName $(pwd) Makefile.in > $retval
    local file=$(< $retval)

    if [ -f "$file" ]; then
        CygbuildGrepCheck "/app-defaults" $file configure.in configure
        status=$?
    fi

    return $status
}

function CygbuildIsDestdirSupported()
{
    local id="$0.$FUNCNAME"

    CygbuildExitNoDir "$srcdir" "$id: [FATAL] variable '$srcdir'" \
              "not defined [$srcdir]."

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildPerlModuleLocation  > $retval
    local module=$(< $retval)

    if [ ! "$module" ]; then
        echo "$id: Perl module was not found"
        return 1                # Error is already displayed
    fi

    local out=$readme.tmp

    #   egrep could find  .... '^[^#]+[$][{(]DESTDIR'

    local debug=${OPTION_DEBUG:-0}

    $PERL -e "require qq($module);  SetDebug($debug); \
              MakefileDestdirSupport(qq($srcdir), qq(-exit));"
}
function CygbuildDependsList()
{
    #   Read the depends line

    local file=$DIR_CYGPATCH/setup.hint

    if [ ! -f "$file" ]; then
        return 1
    else
        sed -ne 's/requires:[ \t]*//p' $file
    fi
}

function CygbuildIsTemplateFilesInstalled()
{
    #   If proper setup has been done, this file exists

    local file=$DIR_CYGPATCH/setup.hint

    [ -f "$file" ]
}

function CygbuildSourceDownloadScript()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    if $LS *$SCRIPT_SOURCE_GET_BASE > $retval 2> /dev/null ; then
        local -a arr=( $(< $retval))

        local len=${#arr[*]}
        local file

        if [ "$len" = "1" ]; then
            file=${arr[0]}
        fi

        echo $file
    else
        return 1
    fi
}

function CygbuildGetOneDir()
{
    #   Return one Directory, if there is only one.

    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local from=${1:-"."}

    #   AWK get all entries that include "/" and then deleted trailing "/"

    $LS -F $from | $AWK  '/\/$/ && ! /tmp/ {        \
        sub("/$", "");                              \
        print;                                      \
        exit;                                       \
        }'                                          \
        > $retval

    local -a arr=$(< $retval)

    local count=${#arr[*]}

    if [ "$count" = "1" ]; then
        echo ${arr[0]}
    else
        return 1
    fi
}

function CygbuildMoveToTempDir()
{
    local id="$0.$FUNCNAME"

    #   Move all files execpt cygbuild*.sh from DIR to temporary directory,
    #   which is deleted beforehand.
    #
    #   Return TEMP DIR
    #
    #   This function is meant for archives that do not contain directory
    #   structure at all, but unpack in place. The idea is to move files
    #   to separate directory to get clean unpack.

    local dir="$1"
    local dest=${2:-"tempdir"}     # optional parameter, if no name given

    dir=$(cd $dir; pwd)

    if [ ! "$dir" ]; then
        CygbuildWarn "$id: [ERROR] DIR input parameter is empty"
        return 1
    fi

    local temp=$dir/$dest

    if [ -d "$temp" ]; then
        $RM -rf "$temp"
    fi

    $MKDIR $temp || return 1

    #   Move everything else, but the directory itself and
    #   the build script, that does not belong to the original
    #   package

    CygbuildPushd
        cd $dir &&
        $MV $(LC_ALL=C $LS | $EGREP -v "$dest|cygbuild.*sh" ) $dest
    CygbuildPopd

    echo $temp
}

function CygbuildFilesExecutable()
{
    local id="$0.$FUNCNAME"
    local dir=${1:-"."}
    local opt=${2:-""}

    local pwd=$(pwd)
    dir=${dir#$pwd/}        #   Shorten the path a bit

    #   Find all files that look like executables from DIR
    #   The extra options for FIND are sent in OPT.
    #   +111 finds all executables

#    set -o noglob

        $FIND -L $dir           \
        -type f                 \
        '('                     \
            -name "*.exe"       \
            -o -name "*.sh"     \
            -o -name "*.pl"     \
            -o -name "*.py"     \
            -o -perm +111       \
        ')'                     \
        -o  -path "*/bin/*"     \
        -o  -path "*/sbin/*"    \
        $opt

#    set +o noglob
}

function CygbuildFileConvertToUnix()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    if [ $# -eq 0 ]; then
        echo "$id [ERROR] Argument list \$* is empty"
        return 1
    fi

    $LS $* > $retval

    perl -e '
        for my $file (@ARGV)
        {
            ! -f $file  and next;
            open IN, $file  or  print("$file $!\n"), next;
            binmode IN;
            $_ = join qq(), <IN>;
            close IN;
            s/\cM//g;
            open OUT, "> $file" or print("$file $!\n"), next;
            binmode OUT;
            print OUT $_;
            close OUT;
        }
    ' $(< $retval) /dev/null
}

function CygbuildTreeSymlinkCopy()
{
    #   Make symbolic links from FROM => TO

    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local from="$1"
    local to="$2"

    CygbuildExitNoDir "$from" "$id: [ERROR] parameter failure 'from' $from"

    if [ ! "$to" ]; then
        CygbuildDie "$to" "$id: [ERROR] parameter 'to' is empty"
    fi

    if [ ! -d "$to" ]; then
        $MKDIR -p "$to" || exit 1
    fi

    #   cp -lr would do the same as 'lndir'. 'lndir' is widely
    #   regarded as best cross platform solution.

    local LNDIR

    CygbuildWhich lndir > $retval
    [ -s $retval ] && LNDIR=$(< $retval)

    if [ "$LNDIR" ]; then
        LNDIR="$LNDIR -silent"
    else

        local msg="$id: 'lndir' not found in PATH. Cannot shadow."
        msg="$msg It is included in xorg* packages."

        CygbuildDie "$msg"
    fi

    #   lndir(1) cannot be used directly, because we are copying UNDER
    #   the current directory (.build). It would cause recursive copying.
    #
    #   So, first copy top level manually, an then let lndir copy
    #   subdirectories.

    CygbuildPushd

        cd $from || return 1

        #   lndir(1) cannot link files that have the same name as executables,
        #   like:
        #
        #       lndir dir/ to/
        #
        #       dir/program
        #       dir/program.exe     =>  to/program.exe
        #
        #   The "program" without ".exe" is not copied. This may be due to
        #   Windows environment.
        #
        #   Remove all *.exe files before shadowing (they should be generated
        #   anyway.

        $FIND . -type f -name "*.exe" \
                 | $EGREP -v '[.](build|s?inst)' \
                 > $retval

        local file done

        for file in $(< $retval)
        do
            if [ "$verbose" ] && [ ! "$done" ]; then
                echo "--  Cleaning offending files before shadow"
                done="yes"
            fi
            $RM -f $verbose "$file"
        done

        local dest
        local current=$(pwd)

        for item in * .*
        do

            #   Ignore these

            if echo $item |
               $EGREP -q "$CYGBUILD_SHADOW_TOPLEVEL_IGNORE"
            then
                CygbuildVerb "--   Ignored $item"
                continue
            fi

            dest=$to/$item

            if [ -f "$item" ]; then

                if  [ ! -f "$dest" ]; then
                    $LN -s "$current/$item"  "$dest" || exit 1
                fi

            elif [ -d "$item" ]; then

                if [ ! -d "$dest" ]; then
                    $MKDIR -p "$dest"            || exit 1
                    $LNDIR "$current/$item" "$dest"
                fi

            else
                item=$(pwd)/$item
                echo ""
                ls -l $item
                CygbuildDie "$id: Don't know what to do with $item"
            fi

        done

    CygbuildPopd
}

function CygbuildFileReadOptionsFromFile()
{
    #   Ignore empty lines and comment lines. Read all others
    #   as one BIG line.

    $AWK \
    '
        {
            gsub("[ \t]+#.*","");
        }
        ! /^[ \t]*#/ && ! /^[ \t]*$/ {
            str = str " " $0;
        }
        END {
            print str;
        }
    ' ${1:-/dev/null}
}

function CygbuildFileReadOptionsMaybe()
{
    local file="$1"
    local msg="$2"

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local str

    if [ -f "$file" ]; then

        CygbuildFileReadOptionsFromFile "$file" > $retval
        str=$(< $retval)

        if [ ! "$msg" ]; then
            CygbuildWarn "--   Reading more options from $file: $str"
        else
            CygbuildWarn "$msg"
        fi
    fi

    echo $str
}

#######################################################################
#
#       Core functions: Define globals and do checks
#
#######################################################################


function CygbuildDefineGlobalPackageDatabase()
{
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local fromdir="$1"
    local todir=$CYGBUILD_CACHE_PAKAGES

    if [ ! "$fromdir" ] || [ ! -d "$fromdir" ] ; then
        CygbuildDie "\
In order to build search database for all files, all downloaded
package-N.N-N.tar.bz2 files must be examined. This will take LOT of
time in the first time. If you're unsure what this directory is, start
setup.exe and see value 'Local Package Directory'

[ERROR] Invalid DIRECTORY argument: [$fromdir]"
    fi

    [ -d "$todir" ] || $MKDIR -p $todir

    echo "-- Building package database to $todir"
    echo "--   Have a snack or something, this will take SOME time..."

    #   Every installed Cygwin package must be examined and the
    #   contents of tar files must be oped in order to
    #   generate the search database. Uncompressing every file is
    #   time consuming process
    #
    #   Every file is listed in separate entry, this makes it
    #   easy to add incremental updates.
    #
    #       todir/foo-1.1-2.lst
    #       todir/foo-1.1-3.lst     Perhaps user did upgrade

    local path name dest

    for path in $( $FIND $fromdir -type f -name "*.bz2" )
    do
        name=${path##*/}        # Delete directories.
        name=${name%.tar.bz2}   # foo-1.1-2.tar.bz2 => foo-1.1-2
        dest="$todir/$name.lst"

        #   This file may have already been unpacked. Skip as needed.

        if [ ! -s $dest ]; then
            CygbuildVerb "--   Processing $path"

            #   Add path name to the beginning of each line

            $TAR -jtvf $path                    \
               | $SED -e "s,^,$path:,"          \
               > $todir/$name.lst || exit $?
        fi

    done
}

function CygbuildDefineGlobalCommands()
{
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local file=$CYGBUILD_CONFIG_PROGRAMS

    if [ "$file" ] && [ -r $file ]; then
        CygbuildVerb "-- Reading configuration $file"
        if ! source $file ; then
            CygbuildDie "$id: [ERROR] Syntax error in $file"
        fi
        return 0
    fi

    AWK=awk                             # global-def
    BASH=/bin/bash                      # global-def
    BASHX="$BASH -x"                    # global-def
    CAT=cat                             # global-def
    CP=cp                               # global-def
    DIFF=diff                           # global-def
    EGREP="grep --binary-files=without-match --extended-regexp" # global-def
    FILE=file                           # global-def
    FIND=find                           # global-def
    GZIP=bzip                           # global-def
    GPG=gpg                             # global-def
    LN=ln                               # global-def
    LS=ls                               # global-def
    MAKE=make                           # global-def
    MKDIR=mkdir                         # global-def
    MV=mv                               # global-def
    PATCH=patch                         # global-def
    PERL=perl                           # global-def
    PYTHON=python                       # global-def
    RM=rm                               # global-def
    SED=sed                             # global-def
    SORT=sort                           # global-def
    TAR=tar                             # global-def
    TR=tr                               # global-def
    WGET=wget
#    WHICH=which
}

function CygbuildIsArchiveScript()
{
    [ "$SCRIPT_VERSION" ] && [ "$SCRIPT_RELEASE" ]
}

function CygbuildDefineGlobalScript()
{
    local id="$0.$FUNCNAME"

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildBuildScriptPath  > $retval
    local script=$(< $retval)
    SCRIPT_FULLPATH=$script                             # global-def

    #   /this/path/package-1.1-2.sh  => package-1.1

    local scriptname=${script##*/}
    SCRIPT_FILENAME=$scriptname                         # global-def
    scriptname=${scriptname%.sh}

    local release=${scriptname##*-}

    if CygbuildIsNumber "$release" ; then
        SCRIPT_RELEASE=$release                         # global-def

        scriptname=${scriptname%-$release}
        SCRIPT_PKGVER=$scriptname                       # global-def
        SCRIPT_PACKAGE=${scriptname%-*}                 # global-def
        SCRIPT_VERSION=${scriptname#$SCRIPT_PACKAGE-}   # global-def

        #  Make command "./<package>-N.N.sh all" generated result
        #  files to $TOPDIR

        OPTION_GBS_COMPAT="script-N-N"                  # global-def
    fi
}

function CygbuildDefineEnvClear()
{
    CygbuildVerb \
      "-- [INFO] Clearing env: compilation variables like CFLAGS etc."

    #  Do not use environment settings. Only those in Makefiles
    #  or if explicitly set through CYGBUILD_* variables in the build
    #  scripts.

    CXXFLAGS=
    CFLAGS=
    LDFLAGS=
    unset CXXFLAGS CFLAGS LDFLAGS
}

function CygbuildDefineGlobalCompile()
{
    #   Define global variables for compilation

    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    CygbuildMakefileName "." Makefile.am Makefile.in > $retval
    local makefile=$(< $retval)

    local libtool libtoolCompile

    if PackageUsesLibtoolMain $makefile configure ; then
        libtool="libtool"

        if PackageUsesLibtoolCompile $makefile ; then
            libtoolCompile="libtool"
        fi
    fi

    if [ "$libtool" ]; then
        CygbuildVerb "-- [INFO] Package seems to use libtool"
    fi

    if [ "$libtool" ] ; then
        #  Read about no-undefined at
        #  http://sourceware.org/autobook/autobook/autobook_88.html

        if [ "$CYGBUILD_LDFLAGS" ]; then
            CYGBUILD_LDFLAGS="-no-undefined $CYGBUILD_LDFLAGS"  # global-def
        else
            CYGBUILD_LDFLAGS="-no-undefined"                    # global-def
        fi

        if [ "$CYGBUILD_AM_LDFLAGS" ]; then
            # CYGBUILD_AM_LDFLAGS  global-def
            CYGBUILD_AM_LDFLAGS="-no-undefined $CYGBUILD_AM_LDFLAGS"
        else
            CYGBUILD_AM_LDFLAGS="-no-undefined"                 # global-def
        fi

    fi

    CYGBUILD_CC="gcc"                                           # global-def
    CYGBUILD_CXX="g++"                                          # global-def

    if [ -x /usr/bin/ccache ]; then

        if [ "$libtool" ]; then

            #   ccache can only be used, if Makefile is well contructed for
            #   libtool. That is, is uses --mode=compile for everything.
            #   But we cannot know for sure, so let user decide.

            if [ "$libtoolCompile" ] ; then
                CygbuildVerb "--   Makefile uses libtool and --mode=compile"

                if [[ ! "$CYGBUILD_CC" == *ccache* ]]; then
                    CygbuildVerb "--   you could try" \
                         "CYGBUILD_CC='ccache gcc'"
                fi
            fi
        else
            local msg
            msg="-- [INFO] Using ccache for CC environment variable"

            CYGBUILD_CC="ccache gcc"                        # global-def

            if CygbuildIsMakefileCplusplus ; then
                CYGBUILD_CC="ccache g++"
            fi
            CYGBUILD_CXX="ccache g++"                       # global-def

            CygbuildVerb $msg
        fi
    fi
}

function CygbuildDefineGlobalMain()
{
    #   GLOBAL VARIABLES THAT AFFECT THIS FUNCTION
    #
    #       OPTION_PREFIX_CYGINST       ./.inst  is default
    #       OPTION_PREFIX_CYGBUILD      ./.build is default
    #       OPTION_PREFIX_CYGSINST      ./.sinst is default
    #
    #   Define generic globals. However this has been split to two
    #   functions which define complete set of globas:
    #
    #   CygbuildDefineGlobalMain         This
    #   CygbuildDefineGlobalSrcOrig      And the sister function
    #
    #   The argDirective can have values:
    #
    #       noCheckRelease
    #       noCheckSrc

    # local sourcefile="$OPTION_FILE"

    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    local argTop="$1"
    local argSrc="$2"
    local argRelease="$3"
    local argPkg="$4"
    local argDirective="$5"

    CygbuildDefineGlobalCompile

    #   - If filename or explicit release was given
    #   - or examine source directory name package-NN.NN/ name

    local templatepkg=${argPkg:-$argSrc}

    if  [[ "$templatepkg" != *[0-9]*[0-9.]* ]] &&
        [[ "$templaterel" == *[0-9]*[0-9.]* ]]
    then
        templatepkg=$templaterel        #   Fix it. This is better
    fi

    if  [[ "$templatepkg" != *[0-9]*[0-9.]* ]] &&
        [[ "$argRelease"  == *[0-9]*[0-9.]* ]]
    then
        templatepkg=$argRelease         #   Fix it. This is better
    fi

    if [[ "$templatepkg" != *[0-9]*[0-9.]* ]]; then

        # Does not look like a correct version, complain
        CygbuildWarn "$id: [WARN] Can't derive VERSION from"        \
             "[$templatepkg]. It is expected that directory name"   \
             "uses format foo-VERSION, like foo-1.2.3. "            \
             "Or perhaps option -f may help."
    fi

    #   Pick any of these, in this order. Variable where
    #   we dig out the version information.

    dummy="A:$release B:$package C:$argSrc"       # For debugging only

    local templaterel=${release:-${package:-$argSrc}}

    CygbuildStrPackage $templatepkg > $retval || exit 1
    local pkgname=$(< $retval)

    CygbuildStrVersion  $templatepkg > $retval || exit 1
    local pkgver=$(< $retval)

    if ! CygbuildIsNumberLike "$pkgver" ; then
        CygbuildWarn "$id: [ERROR] Cannot determine VERSION from $templatepkg"
        CygbuildWarn "$id: [ERROR] Are you inside directory package-N.N/ ?"
        return 1
    fi

    local relver=$templaterel

    if [[ "$relver" == *[!0-9]* ]]; then
        CygbuildStrRelease $relver > $retval || exit 1
        relver=$(< $retval)
    fi

    if [[ "$argDirective" != *noCheckRelease* ]]; then
        if [[ "$relver" != [0-9]* ]] || [ ! $relver -gt 0  ]; then
            # Does not look like a correct version, complain
            CygbuildDie "$id: [ERROR] Can't derive RELEASE from $argSrc." \
                   "See option -r"
        fi
    elif [[ "$relver" != [0-9]* ]]; then
        relver=
    fi

    if [[ "$relver" != [0-9]* ]]; then
        CygbuildWarn "$id: [WARN] RELEASE '$relver' is not a number"
    fi

    CygbuildBuildScriptPath > $retval || exit 1

    BUILD_SCRIPT=$(< $retval)                                   # global-def

    PKG=$(echo $pkgname | tr 'A-Z' 'a-z')                       # global-def
    VER=$pkgver                                                 # global-def
    REL=$relver                                                 # global-def
    FULLPKG=$PKG-$VER-$REL                                      # global-def

    export prefix=$CYGBUILD_PREFIX

    # top=${top%/*}

    SCRIPT_SRC_PKG_BUILD=$FULLPKG.sh                            # global-def
    NAME_SRC_PKG=$FULLPKG-src.tar.bz2                           # global-def
    NAME_SRC_PATCH=$FULLPKG-cygwin.patch                        # global-def
    NAME_BIN_PKG=$FULLPKG.tar.bz2                               # global-def

    LIBPKG=$PKG                                                 # global-def

    if [[ "$PKG" != lib* ]]; then
        LIBPKG=lib$PKG
    fi

    NAME_LIB_PKG_MAIN=$LIBPKG.tar.bz2                           # global-def

    NAME_PKG_LIB_DEV=$LIBPKG-devel-$VER-$REL.tar.bz2            # global-def
    NAME_PKG_LIB_DOC=$LIBPKG-doc-$VER-$REL.tar.bz2              # global-def
    NAME_PKG_LIB_BIN=$LIBPKG-bin-$VER-$REL.tar.bz2              # global-def

    TOPDIR=$argTop                                              # global-def
    export srcdir=$argSrc

    if [[ ! "$argDirective" == *noCheckSrc* ]] && [ ! -d "$srcdir" ]
    then
        CygbuildDie "$id: SRCDIR doesn't exists $srcdir"
    fi

    #   objdir=${srcdir}/.build
    export objdir=$srcdir

    #   DO NOT CHANGE, .sinst and .inst and other are in fact hard coded
    #   elsewhere too to prevent accidental rm -rf

    if [ "$OPTION_PREFIX_CYGINST" ]; then
        export instdir=$OPTION_PREFIX_CYGINST
    else
        export instdir_relative=.inst
        export instdir=$srcdir/$instdir_relative
    fi

    if [ "$OPTION_PREFIX_CYGSINST" ]; then
        export srcinstdir=$OPTION_PREFIX_CYGSINST

    else
        export srcinstdir_relative=.sinst
        export srcinstdir=$srcdir/$srcinstdir_relative
    fi

    #   The .build/ directory is used for various purposes:
    #
    #   1) To compile sources               ./.build/build
    #   2) to make patch against original   ./.build/package-version-orig
    #   3) To make VCS snapshot builds      ./.build/vc

    if [ "$OPTION_PREFIX_CYGBUILD" ]; then
        export builddir_root=$OPTION_PREFIX_CYGBUILD

        builddir_relative_root=${builddir_root##*/}
        export builddir_relative=$builddir_relative_root/build

        export builddir=$OPTION_PREFIX_CYGBUILD/build
    else
        export builddir_relative_root=.build
        export builddir_relative=$builddir_relative_root/build

        export builddir_root=$srcdir/$builddir_relative_root
        export builddir=$srcdir/$builddir_relative
    fi

    export builddir_relative_vc_root=vc
    export builddir_vc_root=$builddir_root/$builddir_relative_vc_root

    PKGLOG=$TOPDIR/${FULLPKG}.log

    # .sinst

    local tmpinst=$srcinstdir

    FILE_SRC_PKG=$tmpinst/$NAME_SRC_PKG                         # global-def

    if CygbuildIsGbsCompat ; then
        echo "-- [NOTE] Using GBS compat mode for source and binary packages"
        FILE_SRC_PKG=$TOPDIR/$NAME_SRC_PKG
    fi

    FILE_SRC_PATCH=$tmpinst/$NAME_SRC_PATCH                     # global-def
    FILE_BIN_PKG=$tmpinst/$NAME_BIN_PKG                         # global-def

    if CygbuildIsGbsCompat ; then
        FILE_BIN_PKG=$TOPDIR/$NAME_BIN_PKG
    fi

    #   Will be defined at runtim

    PATH_PKG_LIB_LIBRARY=$tmpinst/$NAME_LIB_PKG_MAIN            # global-def
    PATH_PKG_LIB_DEV=                                           # global-def
    PATH_PKG_LIB_DOC=                                           # global-def
#    PATH_PKG_LIB_BIN=$tmpinst/$NAME_PKG_LIB_BIN                 # global-def


    #   Documentation and setup directories

    local tmpdocdir=$CYGBUILD_DOCDIR_RELATIVE   # _docdir is temp variable

    DIR_CYGPATCH_RELATIVE=CYGWIN-PATCHES                        # global-def
    DIR_CYGPATCH=$srcdir/$DIR_CYGPATCH_RELATIVE                 # global-def

    CYGPATCH_DONE_PATCHES_FILE=$DIR_CYGPATCH_RELATIVE/done-patch.tmp # global-def

    #   user executables

    PATH=$DIR_CYGPATCH:$PATH                                    # global-def
    CygbuildChmodExec $DIR_CYGPATCH/*.sh

    #   Other files

    SCRIPT_POSTINSTALL_CYGFILE=$DIR_CYGPATCH/postinstall.sh # global-def
    SCRIPT_POSTINSTALL_FILE=$instdir$CYGBUILD_SYSCONFDIR/postinstall # global-def

    #   More global-def

    PREREMOVE_MANIFEST_NAME=manifest.lst
    PREREMOVE_MANIFEST_FROM_NAME=manifest-from.lst

    PREREMOVE_MANIFEST_CYGFILE=\
$DIR_CYGPATCH/preremove-$PREREMOVE_MANIFEST_NAME

    PREREMOVE_MANIFEST_FROM_CYGFILE=\
$DIR_CYGPATCH/preremove-$PREREMOVE_MANIFEST_FROM_NAME

    SCRIPT_PREREMOVE_CYGFILE=$DIR_CYGPATCH/preremove.sh
    DIR_PREREMOVE_CYGWIN=$instdir$CYGBUILD_SYSCONFDIR/preremove

    DIR_DOC_CYGWIN=$instdir$prefix/$tmpdocdir/Cygwin
    DIR_DOC_GENERAL=$instdir$prefix/share/doc/$PKG-$VER         # global-def
    DIR_INFO=$instdir$prefix/share/info                         # global-def

    SCRIPT_PREPARE_CYGFILE=$DIR_CYGPATCH/prepare.sh            # global-def

    EXTRA_CONF_OPTIONS=$DIR_CYGPATCH/configure.options          # global-def
    EXTRA_CONF_ENV_OPTIONS=$DIR_CYGPATCH/configure.env.options  # global-def
    EXTRA_BUILD_ENV_OPTIONS=$DIR_CYGPATCH/build.env.options     # global-def
    EXTRA_BUILD_OPTIONS=$DIR_CYGPATCH/build.options             # global-def
    EXTRA_DIFF_OPTIONS_PATCH=$DIR_CYGPATCH/diff.options         # global-def
    EXTRA_TAR_OPTIONS_INSTALL=$DIR_CYGPATCH/install.tar.options # global-def
    EXTRA_ENV_OPTIONS_INSTALL=$DIR_CYGPATCH/install.env.options # global-def

    SCRIPT_DIFF_BEFORE_CYGFILE=$DIR_CYGPATCH/diff-before.sh    # global-def
    SCRIPT_DIFF_CYGFILE=$DIR_CYGPATCH/diff.sh                  # global-def

    SCRIPT_CONFIGURE_CYGFILE=$DIR_CYGPATCH/configure.sh        # global-def
    SCRIPT_BUILD_CYGFILE=$DIR_CYGPATCH/build.sh                # global-def

    SCRIPT_INSTALL_MAIN_CYGFILE=$DIR_CYGPATCH/install.sh        # global-def
    SCRIPT_INSTALL_MAKE_CYGFILE=$DIR_CYGPATCH/install-make.sh   # global-def
    SCRIPT_INSTALL_AFTER_CYGFILE=$DIR_CYGPATCH/install-after.sh # global-def

    SCRIPT_BIN_PACKAGE=$DIR_CYGPATCH/package-bin.sh             # global-def
    SCRIPT_SOURCE_PACKAGE=$DIR_CYGPATCH/package-source.sh       # global-def

    SCRIPT_SOURCE_GET_BASE=source-install.sh                    # global-def
    SCRIPT_SOURCE_GET_TEMPLATE=checkout.sh                      # global-def
    SCRIPT_SOURCE_GET=$srcinstdir/$SCRIPT_SOURCE_GET_BASE       # global-def

    INSTALL_SCRIPT=${CYGBUILD_INSTALL:-"/usr/bin/install"}      # global-def
    INSTALL_FILE_MODES=${INSTALL_DATA:-"-m 644"}                # global-def
    INSTALL_BIN_MODES=${NSTALL_BIN:-"-m 755"}
}

function CygbuildCygbuildDefineGlobalSrcOrigGuess()
{
    #   Define source package related globals. CygbuildDefineGlobalMain must
    #   have been called prior this function.

    local id="$0.$FUNCNAME"
    local name pkg
    local dummy="pwd $(pwd)"    # for debug

    if [[ "$PACKAGE_NAME_GUESS" == *tar.* ]]; then
        #  The Main function set this variable
        pkg=$PACKAGE_NAME_GUESS
        name=${pkg##*/}     # Delete path
    else
        local ext

        for ext in .tar.gz .tar.tgz .tar.bz2
        do

            #  Standard version uses hyphen  : package-NN.NN.tar.gz
            #  Debian version uses underscore: package_NN.NN.tar.gz

            local file try

            for file in $PKG-$VER$ext       \
                        $PKG-$VER-src$ext   \
                        ${PKG}_$VER$ext     \
                        ${PKG}_$VER.orig$ext
            do

                try=$TOPDIR/$file

                if [ -f "$try" ]; then
                    name=$file
                    pkg=$try
                    break 2

                elif [ -h $try ]; then
                    CygbuildWarn "--    [WARN] Dangling symlink found: $TOPDIR"
                    $LS -l $try
                fi

            done
        done
    fi

    SRC_ORIG_PKG_NAME="$name"           # global-def
    SRC_ORIG_PKG="$pkg"                 # global-def
}

function CygbuildDefineGlobalSrcOrig()
{
    #   Define Source package related globals.
    #   must have been called prior this function.

    local id="$0.$FUNCNAME"
    local sourcefile="$OPTION_FILE"

    local dummy="pwd $(pwd)"    # for debugging

    if [ ! "$PKG" ] || [ ! "$VER" ]; then
        CygbuildWarn "$id: [FATAL] variables PKG and VER not known." \
             "Are you inside package-NN.NN/ ?"
        return 1
    fi

    #   CygbuildBuildScriptPath

    if [ -f "$sourcefile" ]; then
        #  If user told where the source file is, then examine that
        local name=${sourcefile##*/}    # Remove path
        SRC_ORIG_PKG_NAME=$name         # global-def
        SRC_ORIG_PKG=$sourcefile        # global-def
    else
        #  No chance. Try guessing where that source file is
        if [ ! "$SRC_ORIG_PKG" ]; then
            CygbuildCygbuildDefineGlobalSrcOrigGuess
        fi
    fi

    CygbuildExitNoFile "$SRC_ORIG_PKG" \
        "$id: [FATAL] SRC_ORIG_PKG ../$PKG-$VER.tar.gz not found." \
        "Perhaps you have to make a symbolic link from original" \
        "to that file? See manual for details."
}

function CygbuildSrcDirCheck()
{
    #   We must know where the sources are, in orger to run conf, make or
    #   mkpatch etc.

    local id="$0.$FUNCNAME"
    local dir="$1"

    if [ ! "$dir" ]; then
        CygbuildDie "$id: [FATAL] dir is empty"
    fi

    dir=${dir##*/}
    local pkg=${dir%%-*}
    local ver=${dir##*-}

    if  ! CygbuildIsNumberLike "$ver" ; then
        CygbuildWarn "
$id: [ERROR] Cannot determine plain numeric VERSION (format: N.N)

The directory $dir
does not look like package-VERSION. Variables cannot be contructed.
You have options:

- chdir to package-NN.NN/ directory and use -f ../package-NN.NN.tar.gz.
  If package name does not have VERSION, and is something like
  foo-latest.tar.gz, make a symbolic link to foo-1.3.tar.gz and try -f again.

- Extract package, and chdir to package-NN.NN/ and try separate
  options: 'mkdirs' 'files' 'conf' 'make'

- If the package does not extract to package-NN.NN/ make a symbolic link
  and chdir into it. ln -s foo3.3alpha3 foo-3.3.1.3; cd  foo-3.3.1.3/

A VERSION must be present either in package name or in directory name

"
        exit 1
    fi
}

function CygbuildSrcDirLocation()
{
    local id="$0.$FUNCNAME"
    local dir="$1"

    #   Find src directory.
    #   - If scriptdir ends in SPECS, then top is $scriptdir/..
    #   - If scriptdir ends in $DIR_CYGPATCH_RELATIVE, then top is $scriptdir/../..
    #   - Otherwise, we assume that top = scriptdir

    local top=$dir
    local src=$dir

    if [ -f "$dir/configure" ] || [ -f "$dir/buildconf" ] ; then
        top=$(cd $dir/..; pwd)

    elif [[    "$top" == *-[0-9]*.*[0-9]
            || "$top" == *-[0-9][0-9][0-9][0-9]*[0-9]
         ]] ; then
        #   Looks like we are inside package-NN.NN/
        top=$(cd $dir/..; pwd)

    elif [[     $dir == */$DIR_CYGPATCH_RELATIVE
             || $dir == */SPECS
             || $dir == */debian
         ]] ; then
        src=$(cd $dir/..; pwd)
        top=$(cd $src/..; pwd)

    elif [[ $dir == *.orig ]]; then
        #   Debian uses *.orig directories
        src=$(cd $src; pwd)
        top=$(cd $dir/..; pwd)

    else
        top=$(cd $dir; pwd)
        src=$top
    fi

    echo $top $src
}

#######################################################################
#
#       Documentation functions
#
#######################################################################

function CygbuildHelpShort()
{
    local id="$0.$FUNCNAME"
    local exit="$1"

    local bin=$(CygbuildBuildScriptPath)
    bin=${bin##*/}      # Delete path

    echo "
Version $CYGBUILD_VERSION <$CYGBUILD_HOMEPAGE_URL>
Call syntax: $bin [option] CMD ...

  -d LEVEL              Debug mode with numeric LEVEL
  -f ORIG-SRC.tar.gz    Original author's source package location
  -h                    This short help
  --help                Long help (requires full cygbuild suite)
  -m                    Use (no more) space. mkpatch doesn't make a copy
                        of source dir and preserves all *.o files.
  -r RELEASE            Mandatory option for packaging related commands
  -t                    Run in test mode
  -v                    More verbose messages
  -V                    Print version information
  -x                    Do not strip executables

  GPG support options

  -s KEY                Sign files with KEY
  -p \"pass phrase\"      Pass phrase. If not given, it is asked from command
                        line.

DESCRIPTION

Cygbuild is a tool for making, building and maintaining source and binary
packages under Windows/Cygwin platform. Similar to Debian dh_make(1) or
other build tools.

TO USE CYGBUILD FOR MAKING Cygwin Net Releases

    The CMD can be one of the following. The full description can be
    read from the manual page. Commands are listed in order of
    execution:

        To prepare port : mkdirs files shadow
        To port         : conf build strip
        To install      : install
        To check install: check
        To package      : package source-package
        To sign         : package-sign
        To publish      : publish (copy files to publish area)

CYGBUILD CONTROLLED SOURCE PACKAGE

  Testing the source builds

    If you have downloaded a Cygwin source package, like
    package-N.N-RELEASE-src.tar.gz, it should contain at least these
    files:

        foo-N.N-RELEASE-src.tar.bz2
        foo-N.N-RELEASE.patch
        foo-N.N-RELEASE.sh

    Run included shell script:

        $ ./foo-N.N-RELEASE.sh -v all

    In essence, command 'all' is used for testing the integrity of
    source build - it does not produce any visible results. Command
    'all' will try to build binary packages and if everything goes ok,
    command 'finish' which removes the unpacked source directory.

  Testing the source builds - step by step

    To see the results of source compilation, the commands must to be run
    one by one are:

        $ ./foo-N.N-RELEASE.sh -v prep conf make install
        $ cd foo-N.N/
        $ find .inst/
        $ cd ..
        $ rm -rf foo-N.N/

NOTES

    The long --help option consults a separate manual. To read it, full
    cugbuild installation is needed.

    For more information about porting packages to Cygwin, read
    <http://cygwin.com/setup.html>.
"

    [ "$exit" ] && exit $exit
}

function CygbuildHelpLong()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local exit="$1"
    local bin

    CygbuildCommandPath cygbuild.pl > $retval &&
    bin=$(< $retval)

    if [ "$bin" ]; then
        $bin help
        [ "$exit" ] && exit $exit
    else
        CygbuildHelpShort $exit
        CygbuildWarn "[ERROR] Cannot find long help page." \
             "You need to install $CYGBUILD_HOMEPAGE_URL"
    fi
}

function CygbuildHelpSourcePackage()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local lib="$CYGBUILD_STATIC_PERL_MODULE"

    [ "$lib" ] && [ -f "$lib" ] && return 0

    local bin
    CygbuildCommandPath cygbuild.pl > $retval &&
    bin=$(< $retval)

    if [ ! "$bin" ]; then
        echo "-- [WARN] Can't make a source package. " \
             "Additional libraries and templates are needed" \
             "See $CYGBUILD_HOMEPAGE_URL"
        return 1
    fi
}

#######################################################################
#
#       Misc functions
#
#######################################################################

function CygbuildNoticeCygwinPatches()
{
    local id="$0.$FUNCNAME"

    cat << EOF
It appears that there is no directory
$DIR_CYGPATCH

The directory should at minimum include files 'package.README' and
'setup.hint'. Files must be in place before binary package can be made.

You can generate template files with command [files].
EOF
}

function CygbuildNoticeMaybe()
{
    local id="$0.$FUNCNAME"

    if [ ! -d "$DIR_CYGPATCH" ]; then
        CygbuildNoticeCygwinPatches
    fi
}

function CygbuildNoticeBuilddirMaybe()
{
    if ! CygbuildIsBuilddirOk ; then
        CygbuildWarn "-- [ERROR] Builddir not ready." \
            "Try running command '[re]shadow'."
        return 1
    fi
}

function CygbuildFileCleanNow()
{
    local id="$0.$FUNCNAME"
    local msg="$1"
    local files="$2"

    local file done

    for file in $files
    do
        if [ ! $done ] &&  [ "$msg" ] ; then
            CygbuildVerb "$msg"
            done=1
        fi

        if [ -f "$file" ]; then
            $RM $verbose -f "$file"
        fi
    done
}

function CygbuildFileCleanTemp()
{
    local id="$0.$FUNCNAME"

    if [ "$CYGBUILD_RETVAL" ]; then
        #  cygbuild.sh.tmp.3496.CygbuildTarDirectory.dir
        #  => cygbuild.sh.tmp.[0-9]*.*
        $RM -f ${CYGBUILD_RETVAL%.*}.[0-9]* 2> /dev/null
    fi
}

function CygbuildFileExists()
{
    local id="$0.$FUNCNAME"
    local file=$1

    shift
    local dest dir
    local status=1

    for dir in $*
    do
        from=$dir/$file
        [ ! -f "$from" ] && continue
        echo $from
        status=0
        break
    done

    return $status
}

function CygbuildCygDirCheck()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    # Make sure there is a README at /usr/share/doc/Cygwin/

    CygbuildExitNoDir "$DIR_DOC_CYGWIN"  "$id: [ERROR] no $DIR_DOC_CYGWIN" \
              "Did forget to run [files] before [install]?"

    local readme
    $LS $DIR_DOC_CYGWIN/*.README > $retval 2> /dev/null &&
    readme=$(< $retval)

    if [ ! "$readme" ]; then
        CygbuildDie "$id: [ERROR] no $DIR_DOC_CYGWIN/package.README; " \
               "Did forget to run [files]'?"
    fi

    $EGREP -n -e '[<](PKG|VER|REL)[>]' $readme /dev/null

    if [ "$?" = "0" ]; then
        CygbuildWarn \
            "-- [WARN] $DIR_DOC_CYGWIN/package.README contains tags." \
            "Edit or use [readmefix]; and run [install]"
    fi
}

function CygbuildDetermineReadmeFile()
{
    local id="$0.$FUNCNAME"
    local ret file

    for file in  $DIR_CYGPATCH/$PKG.README  \
                 $DIR_CYGPATCH/README       \
                 $DIR_CYGPATCH/*.README
    do
        #   install first found file
        if [ -f "$file" ]; then
            ret=$file
            break
        fi
    done

    if [ "$ret" ]; then
        echo $ret
    else
        return 1
    fi
}

function CygbuildDetermineDocDir()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local dir="${1%/}"      # delete trailing slash

    CygbuildExitNoDir \
        "$dir" "$id: [FATAL] Call parameter DIR does not exist [$dir]"

    local ret=""
    local try=""

    #   Examples: http:://wwww.fprot.org/ uses doc_ws
    #   There must be trailing slash, because DIR may be a symlink and
    #   the content is important.

    if $LS -F $dir/ |
       $EGREP --ignore-case "^doc.*/|docs?/$" > $retval
    then
        for try in $(< $retval)
        do
            try=$dir/$try           # Absolute path
            if [ -d "$try" ]; then
                ret=${try%/}        # Delete trailing slash
                break
            fi
        done
    fi

    echo $ret
}

#######################################################################
#
#       GPG functions
#
#######################################################################

function CygbuildGPGavailableCheck()
{
    if [ ! "$GPG" ] || [ ! -x "$GPG" ]; then
        return 1
    fi
}

function CygbuildNoticeGPG()
{
    if [ ! "$OPTION_SIGN" ]; then
         if CygbuildGPGavailableCheck ; then
            echo "-- [INFO] gpg available. You should use package signing (-s)"
        fi
    fi
}

function CygbuildSignCleanAllMaybe()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local sigext=$CYGBUILD_GPG_SIGN_EXT

    #   If signing option is not on, clean old sign files.

    if [ ! "$OPTION_SIGN" ]; then
        if $FIND $dir -name "*.$sigext" > $retval ; then
            CygbuildFileCleanNow                \
                "-- Removing old *.$sigext files"
                "$(< $retval)"
        fi
    fi
}

function CygbuildGPGverify()
{
    #   Verify list of signature files. The original files are same,
    #   but .sig extension removed.

    local id="$0.$FUNCNAME"
    local quiet="$1"
    shift

    local tmp=$CYGBUILD_RETVAL.$FUNCNAME
    local status=0
    local sigext=$CYGBUILD_GPG_SIGN_EXT
    local file

    for file in $*
    do
        [ ! -f "$file" ]  && continue
        [ ! "$quiet"   ]  && echo "-- Verifying using $file"

        file=${file%$sigext}

        [ ! -f "$file" ]  && echo "--   [WARN] No file found $file"

        #   gpg: WARNING: using insecure memory!
        #   gpg: please see http://www.gnupg.org/faq.html for more information

        $GPG --verify $file$sigext $file 2>&1 \
            | $EGREP -Ev 'insecure memory|faq.html'
            > $tmp

        status=$?

        if [ "$quiet" == real-quiet ]; then
            CygbuildGrepCheck "Good.*signature" $tmp
            status=$?
        elif [ "$quiet" ]; then
            $EGREP --ignore-case "(Good|bad).*signature" $tmp
        else
            $CAT $tmp
        fi

    done

    return $status
}

function CygbuildGPGsignFiles()
{
    local id="$0.$FUNCNAME"

    local signkey="$1"
    local passphrase="$2"
    shift
    shift

    [ ! "$signkey" ] && return
    [ $# -eq 0     ] && return

    CygbuildGPGavailableCheck || return $?

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    date '+%Y-%m-%d %H:%M' > $retval
    local time=$(< $retval)

    local STATUS=0
    local sigext=$CYGBUILD_GPG_SIGN_EXT
    local file sigfile name status

    for file in $*
    do
        echo "-- Signing with key [$signkey] file $file"

        sigfile=$file$sigext

        [ -f "$sigfile" ] && $RM -f "$sigfile" 2> /dev/null

        name=${file##*/}

        if [ "$passphrase" ]; then

            echo "$passphrase" |                            \
            $GPG                                            \
                --passphrase-fd 0                           \
                --detach-sign                               \
                --armor                                     \
                --local-user    "$signkey"                  \
                --output        $sigfile                    \
                --comment "GPG signature of $name ($time)"  \
                $file

                status=$?
        else

            $GPG                                            \
                --detach-sign                               \
                --armor                                     \
                --local-user    "$signkey"                  \
                --output        $sigfile                    \
                --comment "GPG signature of $name ($time)"  \
                $file

                status=$?
        fi

        if [ "$status" != "0" ]; then
            STATUS=$status
            CygbuildWarn "--   [ERROR] signing failed: ${file##*/}"
        fi

    done

    return $STATUS
}

function CygbuildGPGsignFileOne()
{
    local id="$0.$FUNCNAME"
    local signkey="$1"
    local passphrase="$2"
    local file="$3"

    if [ ! "$signkey" ]; then
        CygbuildDie "$id: [FATAL] No argument: signkey"
    fi

    if [ ! "$file" ]; then
        echo "$id: [FATAL] No argument: file"
    fi

    if [ ! -f "$file" ]; then
        echo "-- Nothing to sign, not found: $file"
    fi

    CygbuildGPGsignFiles "$signkey" "$passphrase" $file
}

function CygbuildGPGsignFileNow()
{
    local id="$0.$FUNCNAME"
    local file="$1"

    local signkey="$OPTION_SIGN"
    local passphrase="$OPTION_PASSPHRASE"

    if [ ! "$signkey" ]; then
        return
    fi

    CygbuildGPGsignFileOne "$signkey" "$passphrase" $file
}

function CygbuildGPGsignMain()
{
    local id="$0.$FUNCNAME"
    local retval=$FUNCNAME.$CYGBUILD_RETVAL
    local sigext=$CYGBUILD_GPG_SIGN_EXT

    local signkey="$1"
    local passphrase="$2"

    if [ ! "$signkey" ]; then
        CygbuildDie "$id: [FATAL] No sign argument: signkey"
    fi

    set -o noglob

        local files
        $FIND $srcinstdir                   \
            -type f                         \
            '(' -name "$PKG-$VER-$REL*"     \
                -a \! -name "*$sigext"      \
            ')'                             \
            > $retval

            [ -s $retval ] && files=$(< $retval)

    set +o noglob

    CygbuildGPGsignFiles "$signkey" "$passphrase" $files
}

function CygbuildGPGsignatureCheck()
{
    # Check if there are any *.sig files and check them

    local id="$0.$FUNCNAME"
    local list="$*"

    if [ ! "$list" ]; then
        return
    fi

    if ! CygbuildGPGavailableCheck ; then
        CygbuildVerb "-- No gpg in PATH. Signature checks skipped."
        return
    fi

    local STATUS=0
    local status=0
    local quiet="quiet"
    local file

    [ "$verbose" ] && quiet=""

    for file in $list
    do
        CygbuildGPGverify "$quiet" $file
        status=$?

        if [ "$status" != "0" ]; then
            STATUS=$status
        fi
    done

    return $STATUS
}

function CygbuildCmdGPGSignMain()
{
    local id="$0.$FUNCNAME"
    local signkey="$1"
    local passphrase="$2"

    if ! CygbuildGPGavailableCheck ; then
        echo "-- Signing..."
        return
    fi

    if [ ! "$signkey" ]; then
        echo "--   [ERROR] signkey not available. Signing cancelled."
        return
    fi

    if ! CygbuildGPGavailableCheck ; then
        echo "--   [INFO] gpg binary not found. Signing skipped."
        return
    fi

    local status=0
    local file

    for file in \
        $FILE_SRC_PKG \
        $FILE_BIN_PKG \
        $PATH_PKG_LIB_DEV \
        $PATH_PKG_LIB_DOC \
        $PATH_PKG_LIB_BIN
    do
        if [ -f "$file" ]; then
            CygbuildGPGsignFiles "$signkey" "$passphrase" "$file"

            if [ "$?" != "0" ]; then
                status=$?
            fi
        else
            CygbuildVerb "--   Skipped, not exist $file"
        fi
    done

    return $status;
}

function CygbuildCmdGPGVerifyMain()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local interactive="$1"
    local sigext=$CYGBUILD_GPG_SIGN_EXT

    #   Are we a "build script"  or "cygbuild.sh" ?
    #   That is, is this unpacked source package case or development
    #   of foo-N.NN/

    local list
    local dir=$(pwd)

    if [[ "$0" == *[0-9]* ]]; then
        ls $PKG*$sigext > $retval 2> /dev/null
        list="$(< $retval)"
    else
        dir=$srcinstdir
        $FIND $dir -name "$PKG*$sigext" > $retval
        list="$(< $retval)"
    fi

    if [ ! "$list" ]; then
        return
    fi

    echo "** Verifying signatures in $dir"

    local status=0

    if ! CygbuildGPGsignatureCheck $list ; then
        status=1
        echo -n "-- [WARN] signature check(s) failed. "

        if [ ! "$interactive" ]; then
            echo -e "\n"
        else
            if CygbuildAskYes "Still continue?" ; then
                status=0
            fi
        fi
    fi

    return $status
}

#######################################################################
#
#       Publish functions
#
#######################################################################

function CygbuildPerlModuleLocation()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    #   Find out if we can use cygbuild.pl module
    #   Return 1) Perl interpreter and 2) module path

    if [ ! "$PERL" ]; then
        CygbuildWarn "$id: [ERROR] perl is not in PATH."
        return 1
    fi

    local name="cygbuild.pl"
    local module="$CYGBUILD_STATIC_PERL_MODULE"

    if [ ! "$module" ]; then

        if CygbuildCommandPath $name > $retval; then
            module=$(< $retval)
            CYGBUILD_STATIC_PERL_MODULE="$module"
        fi
    fi

    if [ "$module" ]; then
        echo $module
    else
        CygbuildWarn "$id: [ERROR] file not found: [$name] [$module]" \
             "Have you installed $CYGBUILD_HOMEPAGE_URL ?"
        return 1
    fi
}

function CygbuildCmdAutotool()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    # Run this to re-autotool AFTER editing configure.{ac,in}/Makefile.am

    CygbuildPushd
        cd $srcdir &&
        /usr/bin/autoreconf --install --force --verbose
#        cd $TOPDIR &&
#        if [ -f "$PV/INSTALL" ] ; then \
#                unpack ${src_orig_pkg} ${PV}/INSTALL ; \
#        fi
    CygbuildPopd
}

function CygbuildReadmeReleaseMatchCheck()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    local file

    if CygbuildDetermineReadmeFile > $retval ; then
        file=$(< $retval)
    else
        CygbuildWarn "$id: [ERROR] Not found $DIR_CYGPATCH/$PKG.README"
        return 1
    fi

    # extract line: ----- version 3.5-2 -----
    # where 3.5-2 => "3.5 2"

    local -a arr=( $(
        $AWK ' /^-.*version / {
                                gsub("^-.*version[ \t]+","");
                                ver=$1;
                                i = split(ver, arr, /-/);
                                print arr[1] " " arr[2];
                                exit;
         }' $file
    ))

    local ver=${arr[0]}
    local rel=${arr[1]}

    if [ "$rel" != "$REL" ]; then
        CygbuildWarn "-- [WARN] release $REL mismatch: $ver-$rel in $file"
    fi
}

function CygbuildCmdReadmeFix()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    local readme
    CygbuildDetermineReadmeFile > $retval
    [ -s $retval ] && readme=$(< $retval)

    echo "-- Fixing $readme"

    if [ ! "$readme" ]; then
        CygbuildWarn "$id: [ERROR] Not found $DIR_CYGPATCH/$PKG.README"
        return 1
    fi

    if [ ! -r $readme ]; then
        CygbuildWarn "$id: [ERROR] not readable $readme"
        return 1
    fi

    CygbuildExitNoFile "$FILE_BIN_PKG" "$id: [ERROR] Cannot read files from" \
               " $FILE_BIN_PKG. Run 'package' first."

    CygbuildExitNoDir "$srcdir" "$id: [FATAL] variable '$srcdir' not" \
              "defined [$srcdir]."

    CygbuildPerlModuleLocation  > $retval || exit 1
    local module=$(< $retval)

    if [ ! "$module" ]; then
        echo "$id: [FATAL] Perl module was not found"
        return 1                # Error is already displayed
    fi

    # CygbuildDefineGlobalSrcOrig || return 1

    #   1. Load library MODULE
    #   2. Call function Readmefix() with parameters. It will handle the
    #      text manipulation details.

    echo "--   Calling $module::ReadmeFix()"

    local out=$readme.tmp

    $CP "$readme" "$readme.bak"  || return $?

    local debug=${OPTION_DEBUG:-0}

    $PERL -e "require qq($module);  SetDebug($debug);              \
      ReadmeFix(qq($readme), qq($FULLPKG), qq($FILE_BIN_PKG));"    \
      > $out

    local status=$?

    if [ "$status" != "0" ]; then
        CygbuildWarn "--   [ERROR] Perl call ReadmeFix() failed."
        return $status          # Something went wrong
    fi

    if [[ ! -s $out ]]; then # Zero length?
        CygbuildWarn "--   [ERROR] ReadmeFix() output file is empty $out"
        return 1
    fi

    $MV "$out" "$readme"   &&
    $RM -f "$readme.bak"
}

function CygbuildCmdPublishSetupFix()
{
    local id="$0.$FUNCNAME"
    local dest=$CYGBUILD_PUBLISH_DIR
    dest=$dest/$PKG

    if [ ! "$dest" ] || [ ! -d "$dest" ]; then
        return
    fi

    #  Rename setup files

    local to dir file suffix base

    for dir in $dest/devel $dest/doc $dest/bin
    do
        if [ -d "$dir" ]; then

            suffix=${dir##*/}
            base=setup-$suffix.hint
            file=$dir/$base
            to=$dir/setup.hint

            if [ -f "$file" ]; then
                $MV "$file" "$to"
            fi

            if [ ! -f "$to" ]; then
                CygbuildWarn "--    [WARN] Cannot rename $file => $to"
                CygbuildWarn "--    [WARN] Did you write" \
                    "$DIR_CYGPATCH_RELATIVE/$base ?"
            fi
        fi
    done
}

function CygbuildCmdPublishSignature()
{
    local id="$0.$FUNCNAME"
    local file="$1"
    local dest="$2"

    if [ ! -d "$dest" ]; then
        return
    fi

    local sigext="$CYGBUILD_GPG_SIGN_EXT"
    local sigfile="${file##$pwd/}$sigext"
    local sigfiledest="$dest/$file$sigext"
    local name=${file##*/}

    #   Remove destination signature file, it is always becomes invalid
    #   in publish phase. The new one will be copied there.

    [ -f "$sigfiledest" ] && $RM -f "$sigfiledest"

    if [ -f "$sigfile" ] && CygbuildGPGavailableCheck ; then

        local opt="-n"
        [ "$verbose" ] && opt=

        echo $opt "--   Checking sigfile $sigfile... "

        local mode=real-quiet
        [ "$verbose" ] && mode=quiet

        CygbuildGPGverify "$mode" $sigfile

        if [ "$?" = "0" ]; then
            echo "ok."
            $CP $verbose "$sigfile" "$dest"
        else
            echo "failed! Signature not published."
        fi

    fi
}

function CygbuildCmdPublishToDir()
{
    local id="$0.$FUNCNAME"
    local dest="$1"

    dest=${dest%/}  # Delete possible trailing slash

    CygbuildExitNoDir \
        $dest "$id: [ERROR] No dir $dest. Define CYGBUILD_PUBLISH_DIR"

    dest="$dest/$PKG"

    echo "-- Publishing to $dest"

    if [ ! -d "$dest" ]; then
        $MKDIR $verbose -p "$dest" || return 1
    fi

    #  For library packages, the hierarchy is
    #  base/
    #  base/devel/
    #  base/doc/

    local pwd=$(pwd)
    local file

    for file in $srcinstdir/$PKG-$VER-*tar.bz2          \
                $srcinstdir/$PKG-devel-$VER-*tar.bz2    \
                $srcinstdir/$PKG-doc-$VER-*tar.bz2      \
                $srcinstdir/$PKG-bin-$VER-*tar.bz2      \
                $DIR_CYGPATCH/setup.hint                \
                $DIR_CYGPATCH/setup-devel.hint          \
                $DIR_CYGPATCH/setup-doc.hint            \
                $DIR_CYGPATCH/setup-bin.hint

    do

        [ ! -f "$file" ] && continue

        local to=$dest

        case $file in
            *-devel*)  to=$dest/devel ;;
            *-doc*)    to=$dest/doc   ;;
            *-bin*)    to=$dest/bin   ;;
        esac

        if [ ! -d "$to" ]; then
             $MKDIR $verbose -p "$to" || return 1
        fi

        echo "--   ${file##*/}"

        $CP $verbose "$file" "$to" || return 1
        CygbuildCmdPublishSignature "$file" "$to"

    done

    CygbuildCmdPublishSetupFix
}

function CygbuildCmdPublishExternal()
{
    local id="$0.$FUNCNAME"
    local prg="$1"
    local signer="$2"
    local pass="$3"

    echo "--   Publishing with external: $prg $TOPDIR $signer ${pass+<pass>}"

    CygbuildChmodExec "$prg"
    $prg "$TOPDIR" "$VER" "$REL" "$signer" "$pass"
}

function CygbuildCmdPublishMain()
{
    local id="$0.$FUNCNAME"
    local bin="$CYGBUILD_PUBLISH_BIN"
    local signer="$OPTION_SIGN"
    local pass="$OPTION_PASSPHRASE"

    if [ "$bin" ]; then
        CygbuildCmdPublishExternal "$bin" "$signer" "$pass"
    else
        CygbuildCmdPublishToDir "$CYGBUILD_PUBLISH_DIR"
    fi
}

#######################################################################
#
#       Package functions
#
#######################################################################

function CygbuildConfigureOptionsExtra()
{
    #   Return extra configure options based on package

    local id="$0.$FUNCNAME"
    local opt=""

    if CygbuildIsX11appDefaults ; then
        #  Override /usr/lib for X11 applications
        opt="--libdir=/etc/X11 --with-app-defaults=/etc/X11/app-defaults"
    fi

    echo $opt
}

function CygbuildCmdPkgExternal()
{
    local id="$0.$FUNCNAME"
    local prg=$SCRIPT_BIN_PACKAGE
    local status=0

    CygbuildPushd
        cd $instdir

        echo "** Making package [binary] with external:"
             "$prg $PKG $VER $REL"

        CygbuildChmodExec $prg
        $prg $PKG $VER $REL $TOPDIR

        status=$?

        if [ "$status" = "0"  ]; then
            CygbuildWarn "$id: [ERROR] Failed create binary package."
        fi
    CygbuildPopd

    return $status
}

function CygbuildCmdPkgDevelStandard()
{
    local id="$0.$FUNCNAME"
    local status=0
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local taropt="$CYGBUILD_TAR_EXCLUDE $verbose -jcf"

    CygbuildPushd

        DIR_DOC_GENERAL=$CYGBUILD_DOCDIR_FULL

        echo "** Making packages [devel] from $instdir"

        cd $instdir || exit 1

        local files

        $FIND usr -name "*.dll" -o -name "*.la" \
            > $retval.lib


        #  Exclude library config like xxx-config

        $FIND usr \
             '(' \
                -path "*/bin/*" \
                -path "*/var/*" \
                -o x-path "*/etc/*" \
                -o -path "*/sbin/*" \
            ')' \
            -a ! -name "*.dll" -a ! -name "*-config" \
            > $retval.bin

        local manregexp
        touch $retval.man.bin $retval.man.others

        $FIND usr/share/man > $retval.man.all 2> /dev/null

        if [ -s $retval.bin ]; then

            # Include manual pages too

            manregexp=$( $AWK '
            {
                gsub(".*/", "");
                sub("[.](pl|py|exe|sh)$", "");
                re = re "|" $0;
            }
            END {
                print substr(re, 2);
            }
            ' $retval.bin)

            [ "$manregexp" ] &&
            $FIND usr/share/man             \
                -regextype posix-egrep      \
                -regex ".*($manregexp).*"   \
                >> $retval.man.bin

            if [ -s $retval.man.bin ]; then
                $EGREP --invert-match --file=$retval.man.bin \
                    $retval.man.all > $retval.man.others
            else
                $CP $retval.man.all $retval.man.others
            fi
        fi

        if [ ! -s $retval.lib ]; then
            CygbuildWarn "--    [devel-lib] [WARN] No *.dll files"
        else
            echo -n "--    [devel-lib] "

            # Find out version number
            # usr/bin/cygfontconfig-1.dll => 1

            $EGREP "$PKG.*dll" $retval.lib |
                $EGREP --only-matching -e "-[0-9]" |
                cut -d"-" -f2 \
                > $retval.ver

            local ver
            [ -s $retval.ver ] && ver=$(< $retval.ver)

            local pkg="$LIBPKG$ver.tar.bz2"
            NAME_LIB_PKG_MAIN=$pkg                              # global-def
            PATH_PKG_LIB_DEV="$srcinstdir/$pkg"                 # global-def
            local tar=$PATH_PKG_LIB_DEV

            echo "$tar"

            $TAR $taropt $tar \
            $(< $retval.lib) $(< $retval.bin) $(< $retval.man.bin) ||
            {
                status=$?
                CygbuildPopd
                return $status ;
            }
        fi

        $FIND usr/include usr/lib \( -name "*.h" -o -name "*.a" \) \
            > $retval.dev

        if [ ! -s $retval.dev ]; then
            CygbuildWarn "--    [devel-dev] [WARN] No *.h or*.a files" \
                "for $pkglib"
        else
            echo -n "--    [devel-dev] "

            local pkg="$LIBPKG-devel.tar.bz2"
            NAME_LIB_PKG_MAIN=$pkg                              # global-def
            PATH_PKG_LIB_LIBRARY="$srcinstdir/$pkg"             # global-def
            local tar=$PATH_PKG_LIB_LIBRARY

            echo "$tar"

            $TAR $taropt $tar $(< $retval.dev) ||
            {
                status=$?
                CygbuildPopd
                return $status
            }
        fi


        $FIND usr/share/doc  > $retval.doc

        if [ ! -s $retval.doc ]; then
            CygbuildWarn "--    [devel-doc] [WARN] No doc files for $pkgdoc"
        else

            echo -n "--    [devel-doc] "

            local pkg="$LIBPKG-doc.tar.bz2"
            NAME_PKG_LIB_DOC=$pkg                               # global-def
            PATH_PKG_LIB_DOC="$srcinstdir/$pkg"                 # global-def
            local tar=$PATH_PKG_LIB_DOC

            echo "$tar"

            $TAR $taropt $tar $(< $retval.doc) ||
            {
                status=$?
                CygbuildPopd
                return $status
            }
        fi

    CygbuildPopd

    local file

    for file in $pkgdev $pkglib $pkgbin $pkgdoc
    do
        if [ -f "$file" ]; then
            CygbuildGPGsignFileNow $file
        fi
    done
}

function CygbuildCmdPkgDevelMain()
{
    local id="$0.$FUNCNAME"

    CygbuildCygDirCheck  || return $?

    if [ -f "$SCRIPT_BIN_PACKAGE" ]; then
        CygbuildCmdPkgExternal
    else
        CygbuildCmdPkgDevelStandard
    fi
}

function CygbuildCmdPkgBinaryStandard()
{
    local id="$0.$FUNCNAME"
    local status=0
    local taropt="$CYGBUILD_TAR_EXCLUDE $verbose -jcf"
    local sigext=$CYGBUILD_GPG_SIGN_EXT
    local pkg=$FILE_BIN_PKG

    echo "** Making package [binary] $pkg"

    CygbuildExitNoDir "$srcinstdir" "$id: [ERROR] no $srcinstdir" \
              "Did you forget to run [mkdirs]?"

    CygbuildFileCleanNow "" $pkg $pkg$sigext

    CygbuildPushd
        cd $instdir || exit 1
        $TAR $taropt $pkg *    # must be "*", not "." => would cause ./path/..
        status=$?
    CygbuildPopd

    if [ "$status" = "0" ]; then
        CygbuildGPGsignFileNow $pkg
    fi

    return $status
}

function CygbuildCmdPkgBinaryMain()
{
    local id="$0.$FUNCNAME"

    CygbuildCygDirCheck  || return $?

    if [ -f "$SCRIPT_BIN_PACKAGE" ]; then
        CygbuildCmdPkgExternal
    else
        CygbuildCmdPkgBinaryStandard
    fi
}

CygbuildPackageSourceDirClean()
{
    local id="$0.$FUNCNAME"
    local status=0

    # Clean previous sourcepacakge install and start from fresh.
    # Make sure it looks like .sinst

    if [[ $srcinstdir == *.sinst* ]]; then
        CygbuildPushd
            cd "$srcinstdir" && $RM -f $PKG*-src*
            status=$?
        CygbuildPopd
    fi
}

function CygbuildCmdMkpatchMain()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local signkey="$1"
    local passphrase="$2"

    if ! CygbuildDefineGlobalSrcOrig; then
        return 1
    fi

    CygbuildIsSrcdirOk \
        "[FATAL] Not recognized; expect package-N[.N]+: $srcdir"

    local status=0
    local sigext=$CYGBUILD_GPG_SIGN_EXT
    local origdir=$builddir_root
    local origpkgdir=$origdir/$PKG-$VER-orig
    local out=$FILE_SRC_PATCH

    local diffopt="$CYGBUILD_DIFF_OPTIONS"
    local diffscript=$SCRIPT_DIFF_CYGFILE
    local prescript=$SCRIPT_DIFF_BEFORE_CYGFILE

    local debug
    [[ "$OPTION_DEBUG" > 0 ]] && debug="debug"

    echo "** Making [patch] $out"

    CygbuildNoticeBuilddirMaybe || return 1

    #   The starting directory structure is:
    #
    #       ROOT/foo.1.12.tar.gz
    #
    #       ROOT/foo-1.12/
    #                   |
    #                   +-.build/         BUILDDIR_ROOT
    #                   +-.sinst/
    #                   +-.inst/
    #
    #   1) Extract ROOT/foo.1.12.tar.gz in $builddir_root
    #   2) rename extracted dir ROOT/foo-1.12/.build/.build/foo-1.12/
    #      to ROOT/foo-1.12/.build/.build/foo-1.12-orig/
    #   3) copy (exclude .*) with tar ROOT/foo-1.12 => ROOT/foo-1.12/.build
    #
    #   4) diff -r ROOT/foo-1.12/.build/foo-1.12-orig/
    #              ROOT/foo-1.12/.build/foo-1.12/
    #
    #   NOTE: 'copydir' must be exactly the same name as the 'srcdir'
    #   Otherwise applying the patch will fail.

    local copydir=$builddir_root/${srcdir##*/}

    local file=$SRC_ORIG_PKG

    CygbuildExitNoFile "$file" "$id: [ERROR] Original archive not found $file"

    CygbuildFileReadOptionsMaybe "$EXTRA_DIFF_OPTIONS_PATCH" > $retval
    local extraDiffOpt=$(< $retval)

    if [[ "$extraDiffOpt" == *cygbuild-ignore-all-defaults* ]]; then
        diffopt=""
    fi

    if [ ! "$origpkgdir" ]; then
        #  This may never happen, but check anyway that variable
        #  is not empty.
        CygbuildWarn "$id: [ERROR] variable 'origpkgdir' is empty."
        return 1
    fi

    local cleandir

    (

        # ................................. Extract original package ...

        cd $origdir || exit 1

        CygbuildVerb "--   Extracting original $file"

        #   What is the central directory in tar file?

        CygbuildTarDirectory $file > $retval || return $?
        dir=$(< $retval)

        #   Where will we unpack the original archive?

        cd="."

        if [[ ! "$dir"  ]] || [[ "$dir" = "." ]]; then
            #  Hm, sometimes archive does not include subdirectories

            CygbuildVerbWarn \
                "--    [WARN] Original archive does not unpack to a" \
                "separate directory package-N.N. Fixing this. "

            dir="abcxyz"
            cd=$dir

            [ -d "$dir" ] && $RM -rf "$dir"
            $MKDIR "$dir" || return $?

        else
            if [ -d "$dir" ]; then
                $RM -rf "$dir" || exit 1
            fi
        fi

        if [ -d "$origpkgdir" ]; then
            $RM -rf "$origpkgdir" || exit 1
        fi

        CygbuildTarOptionCompress $file > $retval
        [ -s $retval ] && z=$(< $retval)

        opt="-${z}xf"
        dummy="PWD is $(pwd)"                  # Used for debugging

        $TAR -C "$cd" $opt "$file"     ||
        {
            status=$?
            echo "$id: [ERROR] $TAR $opt $file"
            return $status
        }

        #   Rename by moving:  foo-1.12-orig
        $MV "$dir" "$origpkgdir" || return $?

        cd $srcdir || exit 1

        cursrcdir=$srcdir

        # .......................................... Make duplicate? ...

        if [ "$OPTION_SPACE" ]; then

            #   User has instructed to use more space, so do not destroy
            #   current compilation results, because recompilation might
            #   be very slow with big packages.
            #
            #   Copy the current sources elsewhere and then "clean".
            #   This preserves current sources + compilation.

            cursrcdir=$copydir
            cleandir=$copydir

            echo -n "--   Wait, taking a snapshot (may take a while).. "

            if [ -d "$cursrcdir" ]; then
                $RM -rf "$cursrcdir" || exit 1
            fi

            $MKDIR -p "$cursrcdir" || exit 1

            dummy="PWD is $(pwd)"           # Used for debugging

            $TAR $CYGBUILD_TAR_EXCLUDE \
                --create --file=- . \
                | ( cd "$cursrcdir" && $TAR --extract --file=- ) \
                || exit 1

            echo " Done."
            echo "--   Wait, undoing local patches (if any; in snapshot dir)"

            ( cd $cursrcdir && CygbuildPatchApplyMaybe unpatch )
        fi

        cd $cursrcdir || exit 1

        CygbuildCmdCleanMain     $cursrcdir nomsg
        CygbuildCmdDistcleanMain $cursrcdir nomsg

        difforig=${origpkgdir##$(pwd)/}      # Make relative paths
        diffsrc=${cursrcdir##$(pwd)/}

        if [ -f "$prescript" ]; then
            #   If there is custom script, run it.
            echo "--   [NOTE] Running external prediff:" \
                 "$prescript $difforig $diffsrc"
            CygbuildChmodExec $prescript
            ${debug:+$BASHX} $prescript "$difforig" "$diffsrc"
        fi

        if [[ "$extraDiffOpt" != *cygbuild-ignore-autocheck* ]]; then
            CygbuildPatchFindGeneratedFiles "$origpkgdir" "$cursrcdir" \
                "$extraDiffOpt" > $retval || return $?

            exclude="$(< $retval)"
        fi

        topdir=${cursrcdir%/*}               # one directory up

        cd $topdir || exit 1

        difforig=${origpkgdir##$(pwd)/}      # Make relative paths
        diffsrc=${cursrcdir##$(pwd)/}

        if  [ ! "$difforig" ] || [ ! -d "$difforig" ]; then
            CygbuildWarn "$id: No orig dir? Snapshot failed: $$difforig"
            return 1
        fi

        # ............................ Preparation done, take a diff ...

        if [ -f "$diffscript" ]; then
            #   If there is custom script, run it.
            echo "--   [NOTE] Running external diff: $diffscript" \
                 "$difforig $diffsrc $out"
            CygbuildChmodExec $difforig
            ${debug:+$BASHX} $diffscript "$difforig" "$diffsrc" "$out"
        else

            local dummy="pwd: $(pwd)"    # For debugging
            local dummy="out: $out"      # For debugging

            TZ=UTC0 \
                $DIFF $diffopt $exclude $extraDiffOpt \
                "$difforig" "$diffsrc" \
                > $out

            status=$?

            #   GNU diff(1) return codes are strange.
            #   Number 1 is OK and value > 1 indicates an error

            if [ "$status" != "1" ]; then

                CygbuildWarn "$id: [ERROR] Making patch failed," \
                     "check $origpkgdir and $out"        \
                     "Do you need to run [reshadow]?"

                $EGREP -in 'files.*differ' $out

                return $status

            else

                #  Fix Debian original source directories in Patch
                #
                #  --- foo-0.93.3-orig/CYGWIN-PATCHES/catdoc.README
                #  +++ foo-0.93.3.orig/CYGWIN-PATCHES/catdoc.README
                #
                #  =>
                #  --- foo-0.93.3-orig/CYGWIN-PATCHES/catdoc.README
                #  +++ foo-0.93.3/CYGWIN-PATCHES/catdoc.README

                if CygbuildGrepCheck '^\+\+\+ .*\.orig/' $out ; then
                    CygbuildVerb "--   Fixing patch (Debian .orig)"

                    sed 's,^\(+++ .*\).orig\(.*\),\1\2,' $out > $out.tmp &&
                    $MV "$out.tmp" "$out"
                fi

                CygbuildVerb "--   Removing $origpkgdir"

                if [ ! "$debug" ]; then
                    $RM -rf "$origpkgdir" "$cleandir"
                fi

                #   Signature is no longer valid, remove it.
                sigfile=$out$sigext
                [ -f "$sigfile" ] && $RM -f "$sigfile"

                CygbuildGPGsignFiles "$signkey" "$passphrase" "$out"

            fi
        fi
    )
}

function CygbuildCmdPkgSourceStandard()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local dummy="srcinstdir $srcinstdir"
    local sigext=$CYGBUILD_GPG_SIGN_EXT
    local signkey="$OPTION_SIGN"
    local passphrase="$OPTION_PASSPHRASE"

    CygbuildExitNoDir "$srcinstdir" \
        "$id: [FATAL] No directory $srcinstdir. Try running [mkdirs]"

    if ! CygbuildDefineGlobalSrcOrig ; then
        CygbuildDie "$id: [FATAL] Source archive location unknown. See -f"
    fi

    dummy="$id BUILD_SCRIPT=$BUILD_SCRIPT"      #  For debug only

    CygbuildExitNoFile "$BUILD_SCRIPT" \
        "$id: [ERROR] Can't locate build script [$BUILD_SCRIPT]"

    local orig="$SRC_ORIG_PKG"
    local makepatch="yes"

    if [ ! -f "$orig" ]; then
        CygbuildWarn "$id: [WARN] Cannot diff. Don't know where original "   \
             "source package is. Do you need -f or make a symbolic " \
             "link to PKG-VER.tar.gz?"
        makepatch=
    fi

    CygbuildPackageSourceDirClean

    if [ "$makepatch" ]; then

        CygbuildCmdMkpatchMain      \
            "$OPTION_SIGN"          \
            "$OPTION_PASSPHRASE"    || return $?

        CygbuildPatchCheck          || return $?
    fi

    # .......................................... make source package ...

    local name="$SCRIPT_SRC_PKG_BUILD"    # script-VERSION-RELEASE.sh
    local taropt="$verbose -jcf"

    echo "** Making package [source] $FILE_SRC_PKG"

    local script=$srcinstdir/$name

    $CP -f "$orig" "$srcinstdir/$SRC_ORIG_PKG_NAME"  || return $?
    $CP "$BUILD_SCRIPT" "$script"                    || return $?

    [ "$$signkey" ] && CygbuildGPGsignFiles "$signkey" "$passphrase" "$script"

    CygbuildFileCleanNow "" $FILE_SRC_PKG $FILE_SRC_PKG$sigext

    local status=0

    CygbuildPushd

        cd "$srcinstdir" || exit $?

        #   Sometimes the directory contains previous releases, like
        #   *-1.tar.bz2, *-2.tar.bz2  when the current release source
        #   is -3.

        local pkg=$PKG-$VER-$REL

        ls *$PKG-$VER*-* 2> /dev/null | $EGREP -v "$pkg" > $retval

        if [ -s $retval ]; then
            CygbuildWarn "--   [NOTE] Deleting old releases from $srcinstdir"
            $RM $verbose $(< $retval) || exit $?
        fi

        #   Do not include binary package. Neither *src packages.

        local pkg=$FILE_SRC_PKG

        $TAR $taropt $FILE_SRC_PKG \
             $(ls $PKG*  | $EGREP -v "$pkg(-src)?\.tar")

        status=$?

    CygbuildPopd

    if [ "$status" = "0" ]; then
        CygbuildGPGsignFileNow $FILE_SRC_PKG
    fi

    return $status
}

function CygbuildCmdPkgSourceExternal ()
{
    local id="$0.$FUNCNAME"
    local prg=$scriptPackagesSource
    local status=0

    CygbuildPushd
        cd $instdir || exit 1

        echo "** [NOTE] Making package [source] with external:" \
             "$prg $PKG $VER $REL"

        CygbuildChmodExec $prg

        $prg $PKG $VER $REL $TOPDIR ||
        {
            status=$?
            CygbuildWarn "$id: [ERROR] Failed create source package."
        }

    CygbuildPopd

    return $status
}

#######################################################################
#
#       Making packages from CVS
#
#######################################################################

function CygbuildCmdPkgSourceCvsdiff()
{
    local id="$0.$FUNCNAME"
    local out="$FILE_SRC_PATCH"
    local orig=$builddir_vc_root
    local prg=$SCRIPT_SOURCE_GET

    if [ ! -f "$prg" ]; then
        CygbuildWarn "$id: [ERROR] Can't find $prg"
        return 1
    fi

    echo "** Making [cvs patch] getting sources"

    #   If already there is a checkout, use it
    #   Otherwise download a fresh copy from pserver where we
    #   compare

    local try=$(cd $orig/*/ && pwd)

    if [ "$try" ] && [ -d "$try/CVS" ]; then
    (
        #   There is only one directory, so go there
        cd "$try" || return $?

        #  Overcome "end of file from server" problem
        cvs update ||
        { sleep 5; cvs update; } ||
        { sleep 5; cvs update; } ||
        { echo "-- [ERROR] Permanent problem. Try later." >&2; return 1; }
    )
    else
        try=\
        $(
            $MKDIR -p "$orig"       || return $?
            cd "$orig"              || return $?

            # clean previous sources
            $RM -rf *

            $prg --quiet            &&
            cd ./*/                 &&
            pwd
        )
    fi

    [ "$?" != "0" ] &&
        CygbuildDie "$try" "$id: [FATAL] Couldn't download sources to make diff"

    #   Files that were generated after checkout must be filtered out
    #   Examine how the current directory is different from the
    #   original chekout (Perl function does this)

    echo "-- Making [cvs patch] Examining files to exclude."

    local debug=${OPTION_DEBUG:-0}
    local status exclude

    $PERL -e "require qq($module); SetDebug($debug);
        DiffToExclude(qq($try));" > $retval
    status=$?

    [ -s $retval ] && exclude=$(< $retval)

    if [ "$status" != "0" ]; then
        CygbuildWarn "$id: [ERROR] Hm, either full 'cygbuild' suite is not" \
             "installed or cygbuild.pl perl module is not in PATH." \
             "See $CYGBUILD_HOMEPAGE_URL"
        return $status
    fi

    #   Good. Now we have all the details to make the patch
    #   It is not guaranteed that this is perfectly okay.
    #   => Every user added directory except CYGWIN-PATHCES are
    #   => filtered out.

    echo "-- Making [cvs patch] $out"

    #   Make the patch relative to the current directory.
    #
    #       diff -r there/cvs-dir/ package-N.N/

    local compare=$(basename $(pwd))

    local status=0

    CygbuildPushd
        cd ..
        xTZ=UTC0 $DIFF $CYGBUILD_CVSDIFF_OPTIONS \
            $exclude $try $compare \
            > $out

        status=$?

        #   GNU diff(1) changed return codes.
        #   Return code 1 is OK and value > 1 is an error
        #
        #   0 = no differences
        #   1 = differences
        #   2 = some sort of recoverable error occurred
        #       => that means that there were biary files. Look for
        #       message "Files X and Y differ"

        if [ "$status" = "1" ]; then
            status=0
        else
            CygbuildWarn "$id: [ERROR] Making a patch failed, check $out"
            $EGREP -n --ignore-case 'files.*differ' $out
            status=$(( $status + 10 ))
        fi

    CygbuildPopd

    return $status
}

function CygbuildCmdPkgSourceCvsMain()
{
    local id="$0.$FUNCNAME"
    local dummy

    #  We need the help of Perl library

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildPerlModuleLocation  > $retval || exit 1
    local module=$(< $retval)

    [ ! "$module" ] && return 1

    if [ ! -f "$BUILD_SCRIPT" ]; then
        CygbuildWarn "$id: [FATAL] Cannot find BUILD_SCRIPT, please debug."
        return 1
    fi

    CygbuildPackageSourceDirClean

    if [ -f "$SCRIPT_SOURCE_GET" ]; then
        $RM $SCRIPT_SOURCE_GET
    fi

    local dir=dummy=$(pwd)                # For debugging
    local debug=${OPTION_DEBUG:-0}
    local template=$DIR_CYGPATCH/vc-cvs-$SCRIPT_SOURCE_GET_TEMPLATE

    [ ! -f "$template" ] &&
        CygbuildDie "-- [FATAL] Can't fund template $template"

    $PERL -e "require qq($module);  SetDebug($debug); \
      PackageCVSmain( -dir => qq($srcdir), -script => qq($template) );" \
    > $SCRIPT_SOURCE_GET

    local status
    status=$?

    if [ "$status" != "0" ]; then
        return $status
    fi

    if  [ ! -f "$SCRIPT_SOURCE_GET" ] || [ ! -s "$SCRIPT_SOURCE_GET" ]
    then
        echo "$id: [ERROR] during file generation $SCRIPT_SOURCE_GET"
        return 1
    fi

    echo "--    Wrote $SCRIPT_SOURCE_GET"

    CygbuildCmdPkgSourceCvsdiff  || return $?

    # .......................................... make source package ...

    local tarOpt="$verbose -jcf"

    #   There is no source.tar.gz to go with this, but we include
    #   a shell script that gets the source from CVS. Rename the
    #   Checkout script with 'mv'.
    #
    #       source-install.sh => <PKG>-N.N-REL-source-install.sh

    local install=$PKG-$VER-$REL.sh               # foo-VERSION-RELEASE.sh
    local script=${SCRIPT_SOURCE_GET##*/}
    script=$PKG-$VER-$REL-$script

    $MV "$SCRIPT_SOURCE_GET" "$srcinstdir/$script"  || return $?
    $CP "$BUILD_SCRIPT" "$srcinstdir/$install"      || return $?

    echo "** Making package [source] $FILE_SRC_PKG"

    local status=0

    CygbuildPushd
        cd $srcinstdir || exit 1
        $TAR $CYGBUILD_TAR_EXCLUDE $tarOpt $FILE_SRC_PKG *
        status=$?
    CygbuildPopd

    return $status
}

function CygbuildCmdPkgSourceMain()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local dummy="pwd $(pwd)"                # For debugger

    local type
    CygbuildVersionControlType > $retval
    [ -s $retval ] && type=$(< $retval)

    [ "$type" ] &&
        CygbuildVerb "-- [INFO] Source is version controled with $type"

    if [ -f "$SCRIPT_SOURCE_PACKAGE" ]; then
        CygbuildCmdPkgSourceExternal

    elif [ "$OPTION_VC_PACKAGE" ] && [ "$type" = "cvs" ] ; then
        echo "-- Erm, packaging sources from Version Control dir is" \
             "still highly experimental."
        CygbuildCmdPkgSourceCvsMain
    else
        CygbuildCmdPkgSourceStandard
    fi
}

function CygbuildCmdDownloadUpstream ()
{
    local id="$0.$FUNCNAME"
    local name="mywebget.pl"
    local bin=$(which $name)

    if [ ! "$bin" ]; then
        CygbuildWarn "-- [ERROR] $name is not installed. See manual."
        return 1
    fi

    name="upstream.perl-webget"
    local conf="$DIR_CYGPATCH/$name"

    if [ ! -f "$conf" ]; then
        CygbuildWarn "-- [ERROR] $conf not found."
        return 1
    fi

    echo "-- [upstream] Checking for new versions..."

    local confpath=$(cd $DIR_CYGPATCH; pwd)
    local conffile=$confpath/$name
    local status=0

    CygbuildPushd
        cd $TOPDIR || exit 1
        $PERL $bin ${OPTION_DEBUG+--debug=3} --verbose \
                   --config $conffile --Tag $PKG --new
        status=$?
    CygbuildPopd

    return $status
}

#######################################################################
#
#       Makefile functions
#
#######################################################################

function CygbuildPostinstallWrite()
{
    local id="$0.$FUNCNAME"
    local str="$1"
    local file=$SCRIPT_POSTINSTALL_CYGFILE

    if ! CygbuildIsTemplateFilesInstalled ; then
        CygbuildWarn "$id: [ERROR] No $DIR_CYGPATCH_RELATIVE/ " \
             "Please run command [files] first"
        return 1
    fi

    if [ ! "$str" ]; then
        echo "$id: [FATAL] input ARG string is empty"
        return 1

    elif [ -f "$file" ]; then
        CygbuildWarn "$id: [WARN] Already exists, won't write to $file"

    else
        echo "$str" > $file || return 1
        CygbuildChmodExec $file
    fi
}

function CygbuildPreRemoveWrite()
{
    local id="$0.$FUNCNAME"
    local str="$1"
    local file="$SCRIPT_PREREMOVE_CYGFILE"

    if ! CygbuildIsTemplateFilesInstalled ; then
        CygbuildWarn "$id: ERROR No $DIR_CYGPATCH_RELATIVE/ " \
             "Please run command [files] first"
        return 1
    fi

    if [ ! "$str" ]; then
        echo "$id: [FATAL] command string is empty"
        return 1

    elif [ -f "$file" ]; then
        CygbuildWarn "$id: [WARN] cannot write " \
             "to $file => $str"

    else
        echo "$str" > "$file" || return 1
    fi
}

function CygbuildMakefileCheck()
{
    local id="$0.$FUNCNAME"

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildMakefileName > $retval || exit 1
    local file=$(< $retval)

    if [ "$file" ]; then

        $EGREP -ne '^[^#]+-lc\>' $file /dev/null > $retval

        if [ -s $retval ]; then
            CygbuildWarn "--  [WARN] Linux -lc found. Make it read -lcygwin"
            $CAT $retval

            #   With autoconf files, editing Makefile does no good.
            #   because next round of [conf] will wipe it. The changes
            #   must be done elsewhere

            if [ -f "$file.in" ]; then
                echo "--  [NOTE] Change *.in files to link against -lcygwin"
            fi
        fi
    fi
}

function CygbuildDebianRules2Makefile()
{
    local id="$0.$FUNCNAME"
    local file="$1"

    if [ ! "$file" ]; then
        CygbuildWarn "$id: [ERROR] argument FILE is missing"
        return 1
    fi

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildPerlModuleLocation  > $retval
    local module=$(< $retval)

    if [ ! "$module" ]; then
        return 1
    fi

    CygbuildExitNoDir "$srcdir" "$id: [FATAL] 'srcdir' [$srcdir] does not exist."

    local out=$srcdir/Makefile

    echo -e "--   Debian: writing $out\n" \
            "--   Debian: Makefile was based on debian/rules. Please check!"

    local debug=${OPTION_DEBUG:-0}

    $PERL -e "require qq($module);  SetDebug($debug); \
      DebianRulesMain(qq($file), -makefile);"         \
      > $out

    if [ ! -s "$out" ]; then
        #  Some error happened if there was no output from perl
        CygbuildWarn "$id: [ERROR] failed to write $out"
        $RM -f "$out"
        return 1
    fi
}

function CygbuildDebianRules2MakefileMaybe()
{
    local id="$0.$FUNCNAME"
    local file="$srcdir/debian/rules"
    local status=0

    if [ -f "$file" ]; then
        echo "--   Debian: examining 'debian/rules'"
        CygbuildDebianRules2Makefile $file || return $?

        CygbuildPushd
            cd $srcdir || exit 1
            $MAKE prefix=$instdir install
            status=$?
        CygbuildPopd

    else
        status=1
    fi

    return $status
}

function CygbuildPerlPodModule()
{
    #  =head2 Mon Dec  1 16:22:48 2003: C<Module> L<libwww-perl|libwww-perl>
    #  =head2 Fri Jan 30 19:39:27 2004: C<Module> L<Locale::gettext|Locale::gettext>

    #   Return "libwww-perl"

    local id="$0.$FUNCNAME"
    local file="$1"

    if [ "$file" ]; then
        $AWK -F"<" '
        {
            module=$3;
            gsub("[|].*", "", module);
            print module;
            exit
        }' $file /dev/null
    fi
}

function CygbuildMakeRunInstallFixPerl()
{
    local id="$0.$FUNCNAME"

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildPerlModuleLocation  > $retval
    local module=$(< $retval)

    if [ ! "$module" ]; then
        return 1
    fi

    #  There is one problem. make install wants to append to file:
    #  /usr/lib/perl5/5.8.0/cygwin-multi-64int/perllocal.pod
    #
    #  installed as:
    #  .inst/usr/lib/perl5/5.8.0/cygwin-multi-64int/perllocal.pod
    #
    #  and upon unpack it would replace the existing file. Tackle that.

    if ! $FIND $instdir -name perllocal.pod > $retval ; then
        return
    fi

    local file
    local ext=".postinstall_append"

    for file in $(< $retval)
    do
        CygbuildPerlPodModule $file > $retval
        local modulename=$(< $retval)

        if [ ! "$modulename" ]; then
            CygbuildWarn "--    [WARN] Couldn't find Perl module name $file"
            return 1
        fi

        $MV $verbose "$file" "$file$ext" || return $?

        local dir=${file%/*}
        local name=${file##*/}
        local realdir=${dir#*.inst}    # relative .inst/usr => absolute /usr

        local from="$realdir/$name$ext"
        local to="$realdir/$name"

        echo "--    Perl install fix: $realdir/$name$ext"

        local commands="
$commands
#  Append new utility to Perl installation
from=$from
to=$to
if [ -f \$from ] &&  [ -f \$to ]; then
    if ! $EGREP -q $modulename \$to ; then
        $CAT \$from >> \$to && $RM -f \$from
    else
        $RM -f \$from
    fi
fi
"

        CygbuildPostinstallWrite "$commands" || return $?

    done
}

function CygbuildMakefilePrefixCheck()
{
    local id="$0.$FUNCNAME"

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildMakefileName > $retval
    local makefile=$(< $retval)

    if [ ! "$makefile" ] ; then
        return 0
    fi

    CygbuildIsDestdirSupported
    local destdir=$?

    if [ "$destdir" != "0" ]; then

        #   In some very weird cases, File::Find.pm dies with
        #   symbolic links, so we might end here saying "no destdir".
        #   Double check the situation with grep. Do we see line like:
        #
        #    $(INSTALL) -d $(DESTDIR)$(exec_prefix)/bin

        local list

        [ -f src/Makefile    ] && list="$list src/Makefile"
        [ -f source/Makefile ] && list="$list source/Makefile"

        local opt

        [ ! "$verbose" ] && opt="-q"

        if $EGREP $opt \
           "^[ \t]*DESTDIR|^[^ \t]+=.*DESTDIR|^[^#].*[$][({]DESTDIR" \
           $makefile $list
        then
            destdir=0
        fi
    fi

    #   There is no DESTDIR support, so try to see if Makefile uses
    #   'prefix' then

    if [ "$destdir" != "0" ]; then

        local re='^[ \t]*(prefix)[ \t]*='

        $EGREP "$re" $makefile # >  /dev/null  2>&1
        status=$?

        if [ ! "$OPTION_PREFIX"  ] && [ "$status" = "0" ]; then
            #  There was statement "prefix="
            echo "--   Makefile may not use DESTDIR, adjusting \$prefix."
            OPTION_PREFIX="automatic"       # global-def
        else

            if MakefileUsesRedirect $makefile ; then
                echo "--     Hm, Makefile seems to use redirect option -C"
                return 0
            fi

            local file="$DIR_CYGPATCH/install.sh"
            local msg

            if [ ! -f $file ]; then
                msg=". You may need to write custom install.sh"
            fi

            CygbuildWarn \
                "--   [WARN] Makefile may not use variables 'DESTDIR'" \
                "or 'prefix'$msg"

        fi
    fi
}

function CygbuildMakefileRunClean()
{
    #   Before making a patch, a "make distclean" should be run

    local id="$0.$FUNCNAME"
    local dir=$builddir

    echo "-- Running 'make clean' in $dir"

    local status=0

    CygbuildPushd
        cd $dir || exit 1
        $MAKE clean
        status=$?
    CygbuildPopd

    return $status
}

function CygbuildPythonCompileFiles()
{
    local id="$0.$FUNCNAME"

    #   prgcwd = os.path.split(sys.argv[0])[0]
    #
    #   http://www.python.org/doc/current/lib/module-os.html
    #   http://www.python.org/doc/current/lib/module-os.path.html
    #
    #   NOTE: Python needs indentation to start to the LEFT.
    #
    #   sys.platform  will return: win32, cygwin, darwin, linux
    #   and os.name will indicate 'posix' as needed.

    $PYTHON -c '
import os, sys, py_compile
verbose = sys.argv[1]

for arg in  sys.argv[2:]:
        file  = os.path.basename(arg)
        dir   = os.path.dirname(arg)
        if os.path.exists(dir):
            os.chdir(dir)
            if verbose:
                print "--   [Python] compiling %s" % (file)
            py_compile.compile(file)
    ' "${verbose+1}" "$@"
}

function CygbuildPythonCompileDir()
{
    local id="$0.$FUNCNAME"
    local dir="$1"

    #   See "Compiling Python Code" by Fredrik Lundh
    #   http://effbot.org/zone/python-compile.htm

    $PYTHON -c '
import os, sys, compileall
dir = sys.argv[1]
compileall.compile_dir(dir, force=1)
    ' "$dir"
}

function CygbuildMakefileRunInstallPythonFix()
{
    local id="$0.CygbuildMakefileRunInstallPythonFix"

    #   Fix /usr/share/bin to /usr/bin
    #   Fix /usr/share/lib to /usr/lib

    local root="$instdir$CYGBUILD_PREFIX"
    local dir dest

    if [ -d $root/bin/lib/python* ]; then
        #  .inst/usr/bin/lib/python2.4/site-packages/foo/...

        mv $verbose "$root/bin/lib" "$root/" ||
           CygbuildDie "Error in $id"

        $RMDIR "$root/bin"
    fi

    for dir in $root/share/bin \
               $root/share/lib
    do
        dest=$dir/../..

        if [ -d "$dir" ]; then
            $MV $verbose "$dir/" "$dest/" ||
               CygbuildDie "Error in $id"
        fi
    done

    #   For some reason compiled python objects from
    #   setup.py include FULL PATH where the modules were compiled.
    #   => this is not good, because they are later installed to the
    #   /usr/share/lib/python2.4/site-packages/
    #
    #   You can see the effect by running "strings *.pyc"
    #   => recompile all

    local list rmlist

    rmlist=$(find $instdir -type f -name "*.pyc")

    if [ "$rmlist" ]; then
        list=$(echo "$rmlist" | $SED 's/\.pyc/.py/g' )
        rm $rmlist
        echo "--   Recompiling python files [may take a while...]"
        CygbuildPythonCompileFiles $list
    fi
}

function CygbuildRunPythonSetupCmd()
{
    CygbuildRunShell $PYTHON setup.py "$@"
}

function CygbuildMakefileRunInstallPythonMain()
{
    local root="$instdir$CYGBUILD_PREFIX"

    local pfx=${1:-$root}
    local docpfx=${2:-$root/share/doc}
    local rest=$3

    #   See "2 Standard Build and Install" and section 3, 4
    #   http://python.active-venture.com/inst/standard-install.html

    #   IT is not possible to define "home" AND prefix variables.
    #   This does not work: --home=$instdir
    #
    #   There is bug in Python: It always install under --prefix,
    #   no matter where --exec-prefix is set to.

    CygbuildRunPythonSetupCmd       \
         install                    \
         --prefix=$pfx/share        \
         --exec-prefix=$pfx/bin     \
         $rest
}

function CygbuildMakefileRunPythonInDir ()
{
    local dir="$1"
    shift

    [ ! "$dir" ] && CygbuildDie "$id: Missing ARG"

    CygbuildPushd
        cd $dir || exit 1
        CygbuildRunPythonSetupCmd "$@"
    CygbuildPopd
}

CygbuildMakefileRunPythonClean ()
{
    CygbuildMakefileRunPythonInDir "$builddir" clean
}

function CygbuildMakefileRunInstallCygwinOptions()
{
    local id="$0.$FUNCNAME"
    local pfx=${1:-$CYGBUILD_PREFIX}
    local docpfx=${2:-$CYGBUILD_DOCDIR_FULL}
    local rest=$3

    local makeEnv=$EXTRA_ENV_OPTIONS_INSTALL
    local test=${test:+"-n"}

    if [ $test ]; then
        echo "--   [INFO] make(1) called with -n (test mode, no real install)"
    fi

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildMakefileName > $retval
    local makefile=$(< $retval)

    if [ "$CYGBUILD_MAKEFLAGS" ]; then
        echo "--     Extra make flags: $CYGBUILD_MAKEFLAGS"
    fi

    #   inside subshell the [source] command does not pollute
    #   current namespace.

    (
        if [ -f "$makeEnv" ]; then
            echo "--     Reading external env: $makeEnv" \
                 " $makeEnv $instdir $CYGBUILD_PREFIX $exec_prefix"
            source $makeEnv || exit $?
        fi

        local docdir=$instdir/$CYGBUILD_DOCDIR_FULL

        #   Run install with Cygwin options

        $MAKE -f $makefile $test        \
             DESTDIR=$instdir           \
             DOCDIR=$docdir             \
             prefix=$pfx                \
             exec_prefix=$pfx           \
             man_prefix=$docpfx         \
             info_prefix=$docpfx        \
             bin_prefix=                \
             $rest                      \
             $CYGBUILD_MAKEFLAGS        \
             install
    )
}

function CygbuildMakefileRunInstallFixInfo()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    #   If there are info files, the 'dir' must be remoed, otherwise
    #   it would overwrite the central DIR when unpackad.
    #
    #       .inst/usr/share/info/package.info
    #       .inst/usr/share/info/dir

    if ! $FIND $instdir -name dir > $retval; then
        return
    fi

    local file

    for file in $(< $retval)
    do
        local name=$DIR_CYGPATCH/postinstall.sh

        if [ ! -f "$name" ]; then
            echo "--   [WARN] removing $file, so you need $name"
        fi

        $RM $file
    done
}

function CygbuildMakefileRunInstallFixMain()
{
    local id="$0.$FUNCNAME"
    CygbuildMakefileRunInstallFixInfo
}

function CygbuildMakefileRunInstall()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local makeScript=$SCRIPT_INSTALL_MAKE_CYGFILE
    local status=0

    CygbuildMakefileName > $retval
    local makefile=$(< $retval)

    #   install under .inst/

    echo "--   Running 'make install' (or equiv.) in $builddir"

    if [ -f "$makeScript" ]; then

        echo "--     Running external make: $makeScript" \
             "$instdir $CYGBUILD_PREFIX $exec_prefix"

        echo "$id: NOT YET IMPLEMENTED"

        #todo: unfinished idea.
        exit 1

        CygbuildPushd
            cd $builddir || exit 1
            $makeScript "$instdir" "$CYGBUILD_PREFIX" "$exec_prefix"
            status=$?
        CygbuildPopd

        return $status

    elif CygbuildIsPythonPackage ; then

        echo "--   ... Looks like Python package [install]"

        CygbuildPushd
            cd $builddir || exit 1
            CygbuildMakefileRunInstallPythonMain &&
            CygbuildMakefileRunInstallPythonFix
            status=$?
        CygbuildPopd

        return $status

    elif CygbuildIsPerlPackage ; then

        #  - Perl already created a Makefile from Makefile.PL, so ...
        #  - Perl makefiles use DESTDIR, but the configure phase already
        #    set the PREFIX, so DESTDIR would cause bad karma at this point

        echo "--   ... Looks like Perl package"

        CygbuildPushd
            cd $builddir || exit 1
            CygbuildMakefileRunInstallCygwinOptions &&
            CygbuildMakeRunInstallFixPerl           &&
            CygbuildInstallCygwinPartPostinstall
            status=$?
        CygbuildPopd

        return $status

    elif [ -f "$makefile" ]; then

        #   DESTDIR is standard GNU ./configure macro,
        #   which points to root of install.
        #   prefix and exec_prefix are relative to it.
        #
        #   Debian package uses @bin_prefix@ to install
        #   programs under another name. Do not set it

        local pfx=$CYGBUILD_PREFIX

        if CygbuildIsAutotoolPackage ; then
            CygbuildVerb "--   ...Looks like standard autotool package"
        else
            CygbuildMakefilePrefixCheck
        fi

        if [ "$OPTION_PREFIX" ]; then

            #  Debian packages do not use DESTDIR, so the only
            #  possibility to guide the installation process is to set
            #  prefix for Makefile

            pfx=$instdir/$CYGBUILD_PREFIX
        fi

        CygbuildConfigureOptionsExtra > $retval
        local extra=$(< $retval)

        #  GNU autoconf uses 'prefix'

        local docprefix=/$CYGBUILD_DOCDIR_PREFIX_RELATIVE

        CygbuildPushd
            cd $builddir || exit 1
            CygbuildMakefileRunInstallCygwinOptions "$pfx" "$docprefix"
            status=$?
        CygbuildPopd

        return $status

    else

        CygbuildWarn "--     [WARN] There is no Makefile." \
             "Did you forget to run [configure]?"

        CygbuildDebianRules2MakefileMaybe

    fi
}

#######################################################################
#
#       Build functions
#
#######################################################################

function CygbuildCmdMkdirs()
{
    local id="$0.$FUNCNAME"
    local verbose="$1"

    echo "-- Making Cygwin directories under $srcdir"
    local status=0
    local dir

    CygbuildPushd

        cd $srcdir || exit 1

        for dir in $builddir $instdir $srcinstdir $DIR_CYGPATCH
        do
            if [ -d "$dir" ]; then
                CygbuildVerb "--   Skipped; already exists $dir"
                continue
            fi

            if ! CygbuildRun $MKDIR $verbose -p "$dir" ; then
                status=$?
                break
            fi
        done

    CygbuildPopd

    return $status
}

function CygbuildExtractTar()
{
    local id="$0.$FUNCNAME"
    local file=$SRC_ORIG_PKG
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    #   Check that CygbuildDefineGlobalSrcOrig
    #   defined variables correctly

    if ! CygbuildDefineGlobalSrcOrig ; then
        echo "$id: [ERROR] Original source kit location not known, see -f."
        return 1
    fi

    local file=$SRC_ORIG_PKG

    if [ ! -f "$file" ]; then
        CygbuildWarn "$id: [FATAL] $file not found. Check" \
             "function CygbuildDefineGlobalMain()"
        return 1
    fi

    CygbuildStrPackage $file > $retval
    local package=$(< $retval)

    CygbuildStrVersion $file > $retval
    local ver=$(< $retval)

    if [ ! "$package" ] || [ ! "$ver" ]; then
        CygbuildWarn "$id: [FATAL] $file does not look like package-N.N.tar.* "
        return 1
    fi

    local expectdir=$package-$ver
    local z
    CygbuildTarOptionCompress $file > $retval
    [ -s $retval ] && z=$(< $retval)

    #   Look inside archive to see what directry it contains.
    #   WE need this in case original source does not have
    #   structure at all or has weird directory.

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildTarDirectory $file > $retval || return $?
    local dir=$(< $retval)

    local opt="$verbose --no-same-owner -${z}xf "
    echo "-- Extracting $file"

    if [ "$dir" != "$expectdir" ]; then
        echo "--    [WARN] archive does not contain $expectdir/"
    fi

    if [[ "$dir" != *[a-zA-Z]* ]]; then

        echo "--    Hm,  archive does not have good subdirectory, so" \
             "creating dir $expectdir and unpacking there"
        $MKDIR "$expectdir" || return $?

        local status=0

        $TAR -C "$expectdir" $opt "$file"  ||
        {
            status=$?
            CygbuildPopd
            return $status
        }

    else

        if [ -d "$dir" ] ; then
            CygbuildDie \
                "--   [ERROR] Cannot unpack, existing directory found: $dir"
        fi

        $TAR $opt $file || return $?

        if [ "$dir" != "$expectdir" ]; then

            #   Sometimes package name only varies in case, which is not good
            #       LibVNCServer-0.6  <=> libvncserver-0.6
            #   Windows cannot rename such directory because it would be the
            #   same.

            echo $dir | $TR 'A-Z' 'a-z' > $retval
            local name1=$(< $retval)

            echo $$expectdir | $TR 'A-Z' 'a-z' > $retval
            local name2=$(< $retval)

            if [ "$name2" = "$name1" ]; then
                echo "--     Interesting, unpack dir $dir => $name2 - Skipped"
            else
                echo "--     Renaming unpack dir: mv $dir $expectdir"
                $MV "$dir" "$expectdir" || return $?
            fi

        fi
    fi
}

function CygbuildExtractWithScript()
{
    local id="$0.$FUNCNAME"
    local prg="$1"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    if [ ! "$srcdir" ]; then
        echo "$id: [FATAL] 'srcdir' not defined"
        return 1
    fi

    echo "--    [NOTE] Getting external sources with $file"

    #   Now run the script and if it succeeds, we are ready to proceed to
    #   patching

    CygbuildChmodExec $prg

    ./$prg  && \
    {
        if [ ! -d "$srcdir" ]; then
            #  The sript did not unpack to package-N.N, fix it

            CygbuildGetOneDir > $retval
            dir=$(< $retval)

            #   Good, there no more than ONE directory, which
            #   was just made by that script.

            to=$(basename $srcdir)

            if [ "$dir" ]; then
                echo "--    [!!] Download done. Symlinking $dir => $to" \
                     "in $(pwd)"
                $LN -s "$dir" "$to" || CygbuildDie "-- [FATAL] symlink failed"
                $MKDIR -p "$srcdir" || CygbuildDie "-- [FATAL] mkdir failed"
            fi
        fi
    }
}

function CygbuildExtractMain()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    if CygbuildSourceDownloadScript > $retval ; then
        local file=$(< $retval)
        CygbuildExtractWithScript $file
    else
        CygbuildExtractTar
    fi
}

#######################################################################
#
#       Patch functions
#
#######################################################################

function CygbuildPatchCheck()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local file

    file="$CYGPATCH_DONE_PATCHES_FILE"

    if [ -f "$file" ]; then
        echo "--   [INFO] Applied local patches"
        cat $file | sed "s,^,$DIR_CYGPATCH_RELATIVE/,"
    fi

    file="$FILE_SRC_PATCH"

    if [ -f "$file" ]; then

        if [ "$verbose" ]; then
            echo "--   [INFO] Patch contains files"
            $AWK '/^\+\+\+ / { print "     " $2}' $file
        fi

        #  Seldom anyone makes changes in C-code or headers
        #  files. Let user audit these changes.
        #
        # --- src/lex.yy.c   2000-04-01 18:33:34.000000000 +0000
        # +++ new/lex.yy.c   2004-01-29 18:04:18.000000000 +0000

        local notes
        $EGREP -ie '^(\+\+\+).*\.([ch]|cc|cpp)\>' $file > $retval
        [ -s $retval ] && notes=$(< $retval)

        if [ "$notes" ]; then
            CygbuildWarn "--   [WARN] Patch check. Please verify $file"
            echo "--   [NOTE] I'm just cautious. Perhaps files below"
            echo "--   [NOTE] are auto-generated or modified by you."
            CygbuildWarn "$notes"
            return 0
        fi

        notes=""

        $EGREP -n "No newline at end of file" $file > $retval
        [ -s $retval ] && notes=$(< $retval)

        if [ "$notes" ]; then
            CygbuildWarn "--   [WARN] Patch check. Please verify $file"
            CygbuildWarn "$notes"
            return 0
        fi

        if [[ ! -s $file ]]; then
            CygbuildWarn "--   [ERROR] Patch file is empty $file"
            return 1
        fi
    else
        CygbuildWarn "--   [ERROR] Patch file is missing $file"
        return 1
    fi
}

function CygbuildPatchPrefixStripCountFromContent()
{
    local id="$0.$FUNCNAME"
    local file=$1
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    #   Read the first line in patch that is in format:
    #       +++ path/to/foo-0.11.7.3.1/subdir/code.c
    #
    #   => up till 'foo'

    if ! $AWK ' /^\+\+\+ / {ok = 1; print $2; exit}
                END { if (!ok) exit(1) }
              ' $file > $retval; then
        CygbuildWarn "-- [WARN] Unrecognized patch format $file"
        return 1
    fi

    local part count
    local tmp=0
    local saved="$IFS"
    local path=$(< $retval)
    local prefix1

    if [ -f "$path" ]; then
        echo 0      # No strip needed
        return
    fi

    if [[ "$path" == b/* ]]; then
        #  Mercurical and Git outputs 'patch -p1' format:
        #   --- a/Makefile.in       Sun Aug 05 20:45:37 2007 +0300
        #   +++ b/Makefile.in       Sun Aug 05 23:55:17 2007 +0300
        prefix1="$path"
    fi

    #   If PART name match the package name, then that is
    #   the strip count. Typical in: diff -ru ../orig/foo-1.1 foo-1.1

    local IFS="/"
        set -- $path

        if [ $# -gt 1 ]; then
            for part in $*
            do
                tmp=$((tmp + 1))

                if [[ $part == $PKG-*[0-9]* ]]; then
                    count=$tmp
                    break;
                fi
            done
        fi

    IFS="$saved"

    #  If no PKG was found, then perhaps this is patch generated from VCS

    if [ ! "$count" ] && [ "$prefix1" ] && [ ! -f "$prefix1" ]; then
        count=1
    fi

    if [ "$count" ]; then
        echo $count
    fi
}

function CygbuildPatchPrefixStripCountFromFilename()
{
    local id="$0.$FUNCNAME"
    local str=$1

    #   Read the filename contains hint how much to strip, use it.
    #       CYGWIN/-PATCHES/foo-1.2.3.strip+3.patch

    [[ $str != *strip+*  ]] && return 1

    str=${str##*strip+}
    str=${str%%[!0-9]*}

    echo $str
}

function CygbuildPatchPrefixStripCountMain ()
{
    local id="$0.$FUNCNAME"
    local file=$1

    CygbuildPatchPrefixStripCountFromFilename "$file"   ||
    CygbuildPatchPrefixStripCountFromContent  "$file"
}

function CygbuildPatchApplyRun()
{
    local id="$0.$FUNCNAME"
    local patch=$1
    shift
    local addopt="$*"

    local dummy=$(pwd)                      # For debug
    local patchopt="$CYGBUILD_PATCH_OPT $addopt"

    if [ ! "$verbose" ]; then
        patchopt="$patchopt --quiet"
    fi

    if [ -f "$patch" ]; then
        echo "-- cd $dummy && patch $patchopt < $patch"
        CygbuildVerb "--   [NOTE] If patch fails, you may need rm -rf $srcdir"
        ${test:+echo} $PATCH $patchopt < $patch
    else
        CygbuildWarn "$id: [ERROR] No Cygwin patch file " \
             "FILE_SRC_PATCH '$FILE_SRC_PATCH'"
        return 1
    fi
}

function CygbuildPatchApplyMaybe()
{
    local id="$0.$FUNCNAME"
    local dir=$DIR_CYGPATCH
    local statfile=$CYGPATCH_DONE_PATCHES_FILE
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    local cmd=${1:-"patch"}  # unpatch?

    local file done name opt

    for file in $dir/*.patch
    do
        [ ! -f "$file" ] && continue

        name=${file##*/}
        done=

        if [ -f "$statfile" ]; then
            $EGREP -qe "$name" $statfile && done=1

            if [ "$cmd" = "patch" ] && [ "$done" ]; then
                echo "-- [INFO] Skip, patch already applied: $file"
                continue
            fi
        fi

        CygbuildPatchPrefixStripCountMain "$file" > $retval

        if [ -s $retval ]; then
            local count=$(< $retval)
            opt="--strip=$count"
        fi

        [ "$cmd" = "unpatch" ] && opt="$opt --reverse"

        CygbuildPatchApplyRun "$file" "$opt" ||
        CygbuildDie "-- [FATAL] Exiting."

        if [ "$cmd" = "unpatch" ]; then

            #   Remove name from patch list
            if [ -f "$statfile" ]; then
                $EGREP -ve "$name" "$statfile" > $retval
                $MV "$retval" "$statfile"
            fi

            if [ ! -s $statfile ]; then
                $RM -f "$statfile"  # Remove empty file
            fi

        else
            echo $name >> $statfile
        fi
    done
}

function CygbuildPatchFindGeneratedFiles()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local retval2=$retval.2

    local origdir="$1"
    local dir="$2"
    local optextra="$3"

    CygbuildExitNoDir "$origdir" "$id: [ERROR] parameter failure 'origdir' $origdir"
    CygbuildExitNoDir "$dir" "$id: [ERROR] parameter failure 'dir' $dir"

    #   Many packages do not 'clean' the files correctly and there may
    #   be left files that were generated by ./configure. Compare
    #   the original file listing against current file listing to
    #   see if some files were not cleaned. These should be ignored while
    #   making a patch
    #
    #   The typical case is a LEX generated files.
    #
    #       lexpgn.l => lexpgn.c

    local exclude

    exclude="$exclude $cygbuild_opt_exclude_tmp_files"
    exclude="$exclude $cygbuild_opt_exclude_bin_files"
    exclude="$exclude $cygbuild_opt_exclude_dir"
    exclude="$exclude $cygbuild_opt_exclude_library_files"
    exclude="$exclude $optextra"

    #  At this point, assume that any .h or .c file is generated
    #  if it is not in the original package.

    $DIFF $exclude --brief -r $origdir $dir > $retval
    local status=$?    # For debug, the diff(1) status code

    if [ "$status" = "2" ]; then
        return 1
    fi

    local ret file

    $AWK '/Only in.*\.[ch]/ {print $4}' $retval > $retval2

    for file in $(< $retval2)
    do
        CygbuildWarn "--   [NOTE] Excluding from patch a Makefile generated" \
             "file $file"
        ret="$ret --exclude=$file"
    done

    #   All file.ext files are generated if they have corresponding
    #   file.ext.in counterpart
    #
    #   Only in /usr/src/build/catdoc/package-N.N/doc: package.1

    local dummy="Forget *.in automake generated files"
    local name try

     $AWK \
        '
            /Only in.*/ {
                path=$3;
                file=$4;
                gsub(":", "", path);
                print path "/" file;
            }
        ' $retval > $retval2

    for file in  $(< $retval2)
    do

        [ -d "$file" ]          && continue     # Skip made directories
        [[ $file = $origdir* ]] && continue

        name=${file##*$dir/}
        try=$origdir/$name.in

        if [ -f "$try" ]; then
            CygbuildWarn \
                "--   [NOTE] Excluding from patch a Makefile generated" \
                 "file $name"

            ret="$ret --exclude=${name##*/} --exclude=${name##*/}.in"
        fi

    done

    #   All executables are excluded too. Some Linux packages
    #   include pure binary "file", so exclude also "file.exe"
    #   under Cygwin.

    local dummy="Forget executables"

    if $LS *.exe > $retval 2> /dev/null ; then
        for file in $(< $retval)
        do
            name=${file%.exe}
            ret="$ret --exclude=$file --exclude=$name"
        done
    fi

    #   Anyway, exclude the package binary name; just in case it
    #   WAS included in original package (bad, possibly a mistake)

    ret="$ret --exclude=$PKG"

    echo $ret
}

#######################################################################
#
#       Other
#
#######################################################################

CygbuildCmdGetSource ()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local pkg="$1"

    if [ ! "$pkg" ]; then
        CygbuildDie "[FATAL] command needs PACKAGE name"
    elif [[ "$pkg" == -* ]]; then
        CygbuildDie "[FATAL] suspicious package name: $pkg"
    fi

    local url=${CYGBUILD_SRCPKG_URL:-\
"http://mirror.switch.ch/ftp/mirror/cygwin"}

    url=${url%/}        # Remove trailing slash

    local file="setup.ini"
    local cachedir=$CYGBUILD_CACHE_DIR
    local cache="$cachedir/$file"

    [ ! -d "$cachedir" ] && $MKDIR -p $verbose "$cachedir"

    if [ "$pkg" ]; then
        echo "-- Using cache $cache (remove to get updated one)"
    else
        echo "[ERROR] Missing source PACKAGE name" >&2
        return 1
    fi

    if [ ! "$WGET" ] || [ ! -f "$WGET" ]; then
        CygbuildDie "-- [FATAL] wget not in PATH"
    fi

    local days
    CygbuildFileDaysOld "$cache" > $retval &&
    days=$(< $retval)

    if [ -f "$cache" ] && [ ! -s "$cache" ]; then
        #  If file exists, but is empty, remove it
        rm -f "$cache"
    elif [[ "$days" > "30" ]]; then
        CygbuildVerb "-- [NOTE] Refreshing $days days old cache file."
        rm -f "$cache"
    fi

    if [ ! -f "$cache" ]; then
        echo -n "-- Wait, downloading Cygwin package information..."
        $WGET -q -O $cache "$url/$file" || return $?
        echo "done."
    fi

    # @ xfig
    # sdesc: "Xfig (main package)"
    # ldesc: "Xfig is a menu-driven tool that allows the user to draw and
    # manipulate objects interactively in an X window.  The resulting
    # pictures can be saved, printed on postscript printers or converted to
    # a variety of other formats (e.g. to allow inclusion in LaTeX
    # documents)."
    # category: X11
    # requires: cygwin xorg-x11-bin zlib jpeg libpng Xaw3d transfig xfig-lib ghostscript-x11 tar
    # version: 3.2.4-6
    # install: release/X11/xfig/xfig-3.2.4-6.tar.bz2 3574763 1c4a8e1ee58b7dfcdad3f8bb408dcd88
    # source: release/X11/xfig/xfig-3.2.4-6-src.tar.bz2 5192668 fc6917de1ade3bceaaa889ee1356bf5c
    # [prev]
    # version: 3.2.4-5
    # install: release/X11/xfig/xfig-3.2.4-5.tar.bz2 3583633 2bbd3da200a524fb9289bfc18cee507b
    # source: release/X11/xfig/xfig-3.2.4-5-src.tar.bz2 5191809 b59f9f7f69899d101c87813479a077c0

    echo "-- Wait, searching package $pkg"

    local path=$(awk \
    '
        $0 ~ re {
            found = 1;
        }
        found > 0 && /^source:/ {
            print $2;
            exit
        }

    ' re="^[@] +$pkg *\$" $cache)

    if [ ! "$path" ]; then
        CygbuildDie "-- [ERROR] No package found: $pkg"
    fi

    local dir=${path%/*}
    local archive=${path##*/}
    local name=${archive%.tar*}
    local name=${name%-src*}
    local name=${name%.orig*}

    if [ ! -f "$archive" ]; then
        $WGET --no-directories --no-host-directories --timestamping \
            "$url/$dir/setup.hint" "$url/$path"
    fi

    echo "-- Wait, extracting source and preparing *.patch file"

    if [ -f "$archive" ] && [ ! -f $name*.sh ] ; then

        local z
        CygbuildTarOptionCompress "$archive" > $retval
        [ -s $retval ] && z=$(< $retval)

        $TAR -${z}xf $verbose "$archive"
    else
        echo "-- Good, archive already extracted: $archive"
    fi

    #  explode the patch to manageable pieces

    local patch=$(ls *.patch 2> /dev/null | grep -Ev '-rest' )

    local fdiff
    CygbuildWhich filterdiff > $retval &&
    fdiff=$(< $retval)

    if [ ! "$fdiff" ]; then
        CygbuildWarn "-- [WARN] Skipped patch explode. filterdiff not in PATH"

    elif [ "$patch" ]; then
        local cygdir="${DIR_CYGPATCH_RELATIVE:-CYGWIN-PATCHES}"

        [ ! -d "$cygdir" ] &&
        $fdiff -i "*CYGWIN*" $patch | patch -p1 --forward

        local file=${patch%.patch}-rest.patch

        [ ! -f "$file" ] &&
        $fdiff -x "*CYGWIN*" $patch > $file

        echo "-- Content of $file"
        $EGREP '^--- ' $file | $SED 's/^--- /   /'

        echo "-- Done. Examine *.sh and $cygdir/ and $file"

    else
        CygbuildWarn "-- [WARN] Didn't see a *.patch file"
    fi
}

function CygbuildCmdPrepIsUnpacked()
{
    local id="$0.$FUNCNAME"
    local msg="$1"

    if [ -d "$srcdir" ]; then
        [ "$msg" ] && echo "$msg"
    else
        return 1
    fi
}

function CygbuildCmdPrepPatch()
{
    local id="$0.$FUNCNAME"
    local status=0

    if [ ! -f $DIR_CYGPATCH/$PKG.README ]; then
        CygbuildPushd
            cd $TOPDIR              &&
            $RM -f *.o 2> /dev/null && # Otherwise does not start compiling
            CygbuildPatchApplyRun ${FILE_SRC_PATCH##*/}
            status=$?
        CygbuildPopd
    fi

    return $status
}

function CygbuildCmdShadowDelete()
{
    local id="$0.$FUNCNAME"
    echo "-- Emptying shadow directory $builddir"

    if [[ ! -d "$srcdir" ]]; then
        CygbuildVerb "--   Nothing to do. No directory found: $srcdir"
    else
        if [[ $builddir == *$builddir_relative ]]; then
            $RM -rf $builddir/*
        else
            CygbuildDie "-- [FATAL] Something is wrong, this doesn't look" \
                   "like builddir [$builddir]. Aborted."
        fi
    fi
}

function CygbuildCmdShadowMain()
{
    local id="$0.$FUNCNAME"

    echo "** Shadow command"

    if CygbuildIsBuilddirOk ; then
        echo "--   Already shadowed. Perhaps you had in mind 'rmshadow'" \
             "or 'reshadow'"
    else
        #    When shadowing, use clean base

        CygbuildPushd
            cd "$srcdir" || exit $?
            echo "--   Running: make clean distclean (ignore errors; if any)"

            if CygbuildIsPythonPackage ; then
                CygbuildRunPythonSetupCmd clean
            else
                make clean distclean
            fi

        CygbuildPopd

        echo "--   Wait, shadowing source files to $builddir"
        CygbuildTreeSymlinkCopy "$srcdir" "$builddir"
        echo "-- Shadow finished."
    fi
}

function CygbuildCmdPrepClean()
{
    local id="$0.$FUNCNAME"

    if [ ! "$TOPDIR" ]; then
        CygbuildDie "$id: TOPDIR not set"
    fi

    #   some archives contain precompiled files like *.o. this
    #   is a mistake which is fixed by removing files.

    CygbuildPushd
        cd $TOPDIR                  || exit 1
        CygbuildCmdCleanMain        "$srcdir"
        CygbuildCmdDistcleanMain    "$srcdir"
        CygbuildCleanConfig         "$srcdir"
    CygbuildPopd
}

function CygbuildCmdPrepMain()
{
    local id="$0.$FUNCNAME"
    local script=$SCRIPT_PREPARE_CYGFILE

    if [ ! "$FILE_SRC_PKG" ]; then
        if ! CygbuildDefineGlobalSrcOrig ; then
            return 1
        fi
    fi

    if [ ! "$REL" ]; then               # Patching fails without this
        CygbuildWarn "$id: [ERROR] RELEASE number is not known."
        return 1
    fi

    local msg="--   [prep] Skipping Cygwin patch; source already unpacked"

    if ! CygbuildCmdPrepIsUnpacked "$msg" ; then
        CygbuildExtractMain         || return $?
    fi

    CygbuildCmdPrepPatch        || return $?

    CygbuildPushd
      echo "--   [NOTE] applying included patches to sources (if any)"
      cd "$srcdir"            || return $?
      CygbuildPatchApplyMaybe || return $?
    CygbuildPopd

    CygbuildCmdMkdirs || return $?

    if [ -f "$script" ]; then
        echo "--   [NOTE] External prepare script: $script $TOPDIR"
        CygbuildChmodExec $script
        ${debug:+$BASHX} $script "$TOPDIR" || return $?
    else
        CygbuildCmdPrepClean || return $?
    fi
}

function CygbuildShellEnvironenment()
{
    local list

    [ "$CYGBUILD_CC" ] &&
    list="$list CC='${CYGBUILD_CC}'"

    [ "$CYGBUILD_CXX" ] &&
    list="$list CXX='${CYGBUILD_CXX}'"

    [ "$CYGBUILD_LDFLAGS" ] &&
    list="$list LDFLAGS='${CYGBUILD_LDFLAGS}'"

    [ "$CYGBUILD_CFLAGS" ] &&
    list="$list CFLAGS='${CYGBUILD_CFLAGS}'"

    if CygbuildIsEmpty "$list" ; then
        return 1
    fi

    echo $list
}

function CygbuildRunShell()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    local env
    CygbuildShellEnvironenment > $retval
    [ -s $retval ] && env=$(< $retval)

    CygbuildVerb "--   Running $(eval $env) $@"

    local status

    CygbuildPushd
        cd "$builddir"      || exit $?
        eval ${test:+echo} $env "$@"
        status=$?
    CygbuildPopd

    return $status
}

function CygbuildCmdDependMain()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local retval2=$CYGBUILD_RETVAL.$FUNCNAME.tmp
    local cygcheck=/usr/bin/cygcheck
    local cygpath=/usr/bin/cygpath

    echo "-- Reading cygcheck dependencies"

    local list
    $FIND $instdir -name "*.exe" -o -name "*.dll" > $retval
    [ -s $retval ] && list=$(< $retval)

    if [ ! "$list" ]; then
        echo "--   [NOTE] No *.exe *.dll files found in $instdir"
        return
    fi

    > $retval       # Clear file

    local file

    for file in $list
    do
        $cygcheck "$file" >> $retval
    done

    $CAT $retval

    local found

    for file in $(< $retval)
    do
        #  Do not check Windows files
        if [[ $file == *WIN*      ]] || \
           [[ $file == *system32* ]] || \
           [[ $file == *exe*      ]] || \
           [[ $file == *cygwin1*  ]]
        then
            continue
        fi

        echo "--   Depend check $file"

        found=1
        $cygcheck -f $file

    done

    if [ ! "$found" ]; then
        echo "--   No other dependencies than 'cygwin'"
    fi
}

function CygbuildConfDepend()
{
    local id="$0.$FUNCNAME"

    #  if there is target 'depend' in Makefile, run it.

    echo "--   Running 'make depend'. Ignore possible error message."

    $MAKE depend

    return  # return ok status
}

function CygbuildConfOptionAdjustment()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    local conf="$srcdir/configure"
    local cygconf="$DIR_CYGPATCH_RELATIVE/configure.sh"
    local options="$CYGBUILD_CONFIGURE_OPTIONS"

    if [ ! -f "$conf" ]; then
        return 0
    fi

    local str opt ret

    for str in $options
    do
        opt=${str%%=*}      # --prefix=/usr  => --prefix

        if CygbuildGrepCheck "^[^#]*$opt" $conf ; then
            [ "$verbose" ] &&
            CygbuildWarn "--   [INFO] configure supports $opt"

            ret="$ret $str"
        else
            [ "$verbose" ] &&
            CygbuildWarn "--   [NOTE] configure did not support $opt"
        fi
    done

    if [ "$ret" ]; then
        echo $ret
    else
        CygbuildWarn "--   [WARN] ./configure did not support standard" \
            "options. You may need to write custom $cygconf"
        return 1
    fi
}

function CygbuildConfCC()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    local conf=$srcdir/configure
    local envfile=$EXTRA_CONF_ENV_OPTIONS
    local userOptFile=$EXTRA_CONF_OPTIONS

    local status=0

    if [ ! -f "$conf" ]; then

        CygbuildVerbWarn "--   [WARN] Hm, there is no $conf"

        CygbuildMakefileName "." > $retval
        local make=$(< $retval)

        if [ "$make" ]; then
            CygbuildVerbWarn \
                "--   [WARN] Found only $make Nothing to configure."
        fi

    else

        local opt
        CygbuildConfOptionAdjustment > $retval
        [ -s $retval ] && opt=$(< $retval)

        echo "--   Running ./configure with Cygwin specific options" \
             "${test:+(TEST mode)}"

        if [ -f "$envfile" ]; then
            echo "--     Reading external env: $envfile" \
                 "$envfile $instdir $CYGBUILD_PREFIX $exec_prefix"
            source $envfile || return $?
        fi

        CygbuildFileReadOptionsMaybe "$userOptFile" > $retval
        local userOptExtra=$(< $retval)

        CygbuildConfigureOptionsExtra > $retval
        local extra=$(< $retval)

        opt="$opt $extra $userOptExtra"

        #   Libtool gets confused if option --libdir=/usr/lib
        #   is passed during configure. We must check if this package
        #   use libtool and remove that option.

        local makelibtool=$make

        if [ ! "$make" ]; then
            CygbuildMakefileName "." Makefile.am Makefile.in > $retval
            makelibtool=$(< $retval)
        fi

        if [ "$makelibtool" ] &&
           PackageUsesLibtoolMain $makelibtool configure
        then
            echo "--   Hm, package uses libtool; options --libdir" \
                 "and --datadir are not included"

            local opt cleaned

            for opt in $opt
            do
                if [[ $opt != +(--libdir*|--datadir*) ]]; then
                    cleaned="$cleaned $opt"
                fi
            done

            opt=$cleaned
        fi

        if [ "$verbose" ]; then

            #   print the listing more nicely. Get a hand from perl here
            #   to format the option listing

            echo "$opt" | $PERL -ane \
            "s/\s+/,/g; print '  ', join( qq(\n  ), sort split ',',$_), qq(\n)"
            echo
        fi

        CygbuildRunShell $conf $opt
        status=$?

    fi

    return $status
}

function CygbuildConfPerlCheck()
{
    local id="$0.$FUNCNAME"

    $PERL -e "use ExtUtils::MakeMaker 6.10"  # at least 6.10 works ok

    local status
    status=$?

    if [ "$status" != "0" ]; then

        cat<<EOF
$id [ERROR] It is not possible to make Perl source package.

Standard Perl (5.8.0) MM:MakeMaker 6.05 does not handle PREFIX variable
correctly to install files into separate directory. YInstall latest
MakeMaker from <http://search.cpan.org/author/MSCHWERN/ =>
ExtUtils-MakeMaker

  1. Download tar.gz and unpack, chdir to unpack directory
  2. Run: perl Makefile.PL
  3. Run: make install

EOF

        return 1
    fi
}

function CygbuildConfPerlMain()
{
    local id="$0.$FUNCNAME"
    local conf="$srcdir/Makefile.PL"
    local status=0

    #   Not good, Perl make Maker is broken. User cannot control PREFIX.
    #   See message http://www.makemaker.org/drafts/prefixification.txt

    if [ -f "$conf" ]; then
        echo "--   Running: perl Makefile.PL PREFIX=$instdir/usr"

        local _prefix=$instdir/usr

        CygbuildPushd
            cd $builddir || exit 1
            $PERL Makefile.PL # PREFIX=$_prefix SITEPREFIX=$_prefix
            status=$?
        CygbuildPopd

    fi

    return $status
}

function CygbuildCmdConfAutomake()
{
     if [[ ! -f configure  &&  -f makefile.am ]]; then
        if [ -f "bootstrap" ]; then
            echo "--   Hm, automake package. Let's see..."
            ./bootstrap

            if [ -f configure ]; then
                CygbuildDie "--   ./configure appeared." \
                      "--   Now run again commands [reshadow] and [configure]"
            else
                echo "--   Don't know what to do."
                return 1
            fi
        fi
    fi
}

function CygbuildCmdConfMain()
{
    local id="$0.$FUNCNAME"
    local perlconf="$srcdir/Makefile.PL"
    local dummy=$(pwd)      # For debugger
    local status=0
    local script=$SCRIPT_CONFIGURE_CYGFILE

    echo "** Configure command"

    if ! CygbuildIsBuilddirOk ; then
        echo "--   Hm, no shadow yet. Running it now."
        CygbuildCmdShadowDelete
        CygbuildCmdShadowMain || return $?
    fi

    CygbuildCmdConfAutomake || return 1

    CygbuildPushd

        cd $builddir || exit 1

        CygbuildVerb "--   Configuring in $(pwd)"

        CygbuildMakefileCheck

        if [ -f "$script" ]; then

            echo "--   [NOTE] External configure script $script"

            CygbuildChmodExec $script
            $script $instdir
            status=$?

        elif [ -f "$perlconf" ]; then

            CygbuildConfPerlCheck &&
            CygbuildConfPerlMain
            status=$?

        elif [ -x configure ]; then

            CygbuildConfCC
            status=$?

        elif CygbuildIsMakefileTarget configure ; then

            #   ./configure generated "Makefile", so this elif must be
            #   after the previous one.

            echo "--   Running: make configure (auto detected; no ./configure)"
            $MAKE configure
            status=$?

        elif [ -f Imakefile ]; then

            echo "--   Looks like imake(1). Running xmkmf(1)"
            xmkmf

            if [ ! -f Makefile ]; then
                echo "--   Hm, Looks like Xconsoritum package," \
                     "running: xmkmf -a"
                xmkmf -a
            fi

        else

            echo "--   No standard configre script found" \
                 "If it's there, run 'reshadow' to update."

        fi

    CygbuildPopd

    return $status
}

function CygbuildSetLDPATHpython()
{
    local id="$0.$FUNCNAME"

    #  Make sure all paths are there

    local try=$(cd /usr/lib/python2.*/config && pwd)

    if  [ "$try" ] && [ -d "$try" ]; then

        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$try   # global-def
        export LD_RUN_PATH=$LD_RUN_PATH:$try           # global-def

        CygbuildVerb "--    Added Python to paths " \
                 "LD_LIBRARY_PATH=$LD_LIBRARY_PATH" \
                 "LD_RUN_PATH=$LD_RUN_PATH"

    fi
}

function CygbuildCmdBuildPython()
{
    local id="$0.$FUNCNAME"
    local status=0

    #  Python *.dll libraries must also have this.
    CYGBUILD_LDFLAGS="-no-undefined"

    CygbuildPushd
        CygbuildSetLDPATHpython
        cd $builddir                                &&
        echo "-- Building: python setup.py build"   &&
        CygbuildRunShell $PYTHON setup.py build
        status=$?
    CygbuildPopd

    return $status
}

function CygbuildCmdBuildMainMakefile()
{
    local id="$0.$FUNCNAME"
    local status=0
    local envfile=$EXTRA_BUILD_ENV_OPTIONS
    local optfile=$EXTRA_BUILD_OPTIONS

    CygbuildExitNoDir "$builddir" "$id: builddir not found [$builddi]"

    # #todo: There are two competing files, use only one of them.
    # if [ -f "$envfile" ]; then
    #     echo "--     Reading external env: $envfile"
    #     source $envfile || return $?
    # fi

    CygbuildPushd

        cd $builddir || exit 1

        local retval=$CYGBUILD_RETVAL.$FUNCNAME
        CygbuildMakefileName "." > $retval
        local makefile=$(< $retval)

        echo "--   Building with standard make(1) $makefile"

        if [ ! "$makefile" ]; then
            CygbuildWarn "--   [WARN] No Makefile." \
                 "If you already tried [configure]" \
                 "You may need to write custom script build.sh (or reshadow)"
            status=17  # Just random number
        else

            #   Run in separate shell so that reading configuration
            #   file settings do not interfere currently running process

            local debug
            [[ "$OPTION_DEBUG" > 0 ]] && debug="debug"

            (
                if [ -r $optfile ]; then
                    echo "--     Reading extra env from $optfile"
                    [ "$verbose" ] &&  cat $optfile
                    source $optfile || exit $?
                fi

                [ "$debug" ] && set -x

                local dummy=$(pwd)   # For debugging

                local env
                CygbuildShellEnvironenment > $retval
                [ -s $retval ] && env=$(< $retval)

                eval $MAKE -f $makefile                 \
                    AM_LDFLAGS="$CYGBUILD_AM_LDFLAGS"   \
                    $env                                \
                    $CYGBUILD_MAKEFLAGS
            )

            status=$?
        fi

    CygbuildPopd

    return $status
}

function CygbuildCmdBuildMain()
{
    local id="$0.$FUNCNAME"
    local status=0
    local script="$SCRIPT_BUILD_CYGFILE"

    echo "** Build command"

    CygbuildNoticeBuilddirMaybe || return $?

    if [ -f "$script" ]; then

        echo "--   [NOTE] Building with external: $script $PKG $VER $REL"

        CygbuildPushd
            cd $builddir || exit 1
            CygbuildChmodExec $script
            $script $PKG $VER $REL
            status=$?
        CygbuildPopd

    elif CygbuildIsPythonPackage ; then

        CygbuildCmdBuildPython
        status=$?

    else

        CygbuildCmdBuildMainMakefile
        status=$?

    fi

    return $status
}

function CygbuildCmdDependCheckMain()
{
    local id="$0.$FUNCNAME"

    echo "-- Checking dependencies in README and setup.hint"

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildPerlModuleLocation  > $retval
    local module=$(< $retval)

    if [ ! "$module" ]; then
        return 1
    fi

    local destdir=$DIR_CYGPATCH
    local file=$destdir/setup.hint

    if [ ! -f "$file" ]; then
        CygbuildDie "--  $id: [ERROR] Can't find $file. Forgot to run [files]?"
    fi

    echo "--   Calling $module::CygcheckDepsCheckMain()"

    local debug=${OPTION_DEBUG:-0}

    #   1. Load library MODULE
    #   2. Call function with parameters.

    $PERL -e "require qq($module); SetDebug($debug); \
        CygcheckDepsCheckMain( qq($instdir), qq($destdir) );"
}

function CygbuildCmdTestMain()
{
    local id="$0.$FUNCNAME"

    CygbuildPushd
        cd $builddir || CygbuildDie "$id: [builddir] error"
        $MAKE test 2>&1 | tee $PKGLOG
    CygbuildPopd
}

function CygbuildCleanConfig ()
{
    # Clean configuration files

    $RM -f config.status config.log
}

function CygbuildCmdCleanMain()
{
    local id="$0.$FUNCNAME"
    local dir=${1:-$builddir}
    local opt="$2"

    echo "-- Running 'make clean' (or equiv.) in $dir"

    CygbuildExitNoDir $dir "$id: [ERROR] 'dir' does not exist [$dir]"

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildMakefileName $dir > $retval
    local makefile=$(< $retval)

    local status=0

    if CygbuildIsPythonPackage ; then

        CygbuildMakefileRunPythonInDir "$srcdir" clean

    elif [ ! "$makefile" ]; then
        if [ "$opt" != "nomsg" ]; then
            echo "--   No Makefile found, nothing to clean in $dir"
        fi
    else
        CygbuildPushd

            cd $dir  || exit 1

            local file

            $MAKE -f $makefile clean ||
            {
                echo "--   [NOTE] Hm, running rm *.o *.exe *.dll instead"
                echo "--   [NOTE] Better, patch the Makefile to include"
                echo "--   [NOTE] target 'clean:'"

                set -o noglob    # Don not expand variables, like  "*.exe"

                    if $FIND . \
                        -type f '(' $CYGBUILD_FIND_OBJS ')' \
                        > $retval
                    then
                        for file in $(< $retval)
                        do
                            $RM $verbose "$file"
                        done
                    fi

                set +o noglob

            }
        CygbuildPopd
    fi

    return $status
}

function CygbuildCmdDistcleanMain
{
    local id="$0.$FUNCNAME"
    local dir=${1:-$builddir}
    local opt="$2"

    echo "-- Running 'make distclean' (or equiv.) in $dir"

    local status=0

    if CygbuildIsPythonPackage ; then
        #   Nothing to do
        :
    else
        CygbuildMakefileRunTarget "distclean" "$dir" "$opt"
    fi

    return $status
}

function CygbuildCmdCleanByType()
{
    local id="$0.$FUNCNAME"
    local target=$1               # clean, distclean, realclean
    local dir=${2:-$builddir}
    local opt="$3"

    [ ! "$target" ]   && target="clean"

    if [ "$target" = "clean" ]; then
        CygbuildCmdCleanMain
    elif [ "$target" = "distclean" ]; then
        CygbuildCmdDistcleanMain
    else
        CygbuildMakefileRunTarget $target
    fi
}

function CygbuildInstallPackageInfo()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    local dest=$DIR_INFO
    local file
    local done

    $FIND $srcdir                                               \
        -type d '(' -name ".inst" -o -name ".build" ')' -prune  \
        -a ! -name ".inst"                                      \
        -a ! -name ".build"                                     \
        -o -type f '(' -name "*.info" -o -name "*.info-*" ')'   \
        | $SORT > $retval

    for file in $(< $retval)
    do
        if [ ! "$done" ]; then                # Do only once
            $MKDIR -p "$DIR_INFO" || return 1
            done=1
            echo "--   Installing [info] files to $dest"
        fi

        if [ -f "$file" ]; then
            CygbuildVerb "--     Info file $file"
            $INSTALL_SCRIPT $INSTALL_FILE_MODES $file $dest
        fi
    done


    # Package must not supply central 'dir' file

    file=$DIR_INFO/dir

    if [ -f "$file" ] ; then
        $RM "$file"   || return 1
    fi

}

function CygbuildInstallTaropt2match ()
{
    #   Convert each --exclude=  option into BASH match format.

    local type="$1"   # exclude or include
    shift

    local find="--exclude="

    if [ "$type" = "include" ]; then
        find="--include="
    fi

    local ret item

    for item in $*
    do
        if [[ "$item" == $find* ]]; then
            item=${item/$find}     # Delete this portion
            if [[ "$ret"  &&  "$item" ]]; then
                ret="$ret|$item"
            else
                ret="$item"
            fi
        fi
    done

    if [ "$ret" ]; then
        ret="@($ret)"                   # BASH extended match syntax
        echo "$ret"
    else
        return 1
    fi
}

function CygbuildInstallPackageDocs()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local scriptInstallFile="$INSTALL_SCRIPT $INSTALL_FILE_MODES"
    local scriptInstallDir="$INSTALL_SCRIPT $INSTALL_BIN_MODES -d"
    local optExclude="$CYGBUILD_TAR_INSTALL_EXCLUDE"

    local dest=$DIR_DOC_GENERAL

    CygbuildFileReadOptionsMaybe "$EXTRA_TAR_OPTIONS_INSTALL" > $retval
    local optExtra=$(< $retval)

    local matchExclude matchInclude

    if [ "$$optExtra" ]; then
        CygbuildInstallTaropt2match exclude "$optExtra" > $retval
        [ -s $retval ] && matchExclude=$(< $retval)

        CygbuildInstallTaropt2match include "$optExtra" > $retval
        [ -s $retval ] && matchInclude=$(< $retval)
    fi

    local done name file match

    for file in $builddir/[A-Z][A-Z][A-Z]* \
                $builddir/changelog        \
                $builddir/ChangeLog        \
                $builddir/*.html           \
                $builddir/*.pdf            \
                $builddir/*.txt

    do

        [ ! -f "$file" ]          &&  continue
        [ ! -s "$file" ]          &&  continue  # Zero length

        #   Ignore backups

        [[ $file == @(*[~#]|*.bak|*.rej|*.orig) ]]    && continue

        name=${file##*/}
        match=""

        #   In for loop, the patterns in $CYGBUILD_INSTALL_IGNORE
        #   would expand to file names without 'noglob'.

        CygbuildMatchBashPatternList \
            "$file" $CYGBUILD_INSTALL_IGNORE && continue

        if [[ "$matchExclude"  &&  "$name" == $matchExclude ]]; then
            continue
        fi

        if [ ! "$done" ]; then      #  Do this only once
            CygbuildRun $scriptInstallDir $dest || return $?
            done=1
            echo "--   Installing docs to $dest ${test:+(TEST MODE)}"
        fi

        CygbuildRun $scriptInstallFile $file $dest

    done

    #  tar does not yet support --include options, so do it here

    if [ "$matchInclude" ]; then
        CygbuildPushd

            cd "$builddir"

            # @(<pattern>) => <pattern>

            matchInclude=${matchInclude/\@(}
            matchInclude=${matchInclude/)}
            matchInclude=${matchInclude//\|/ }

            for file in $matchInclude
            do
              [ -f "$file" ] || continue
              CygbuildRun $scriptInstallFile $file $dest
            done

        CygbuildPopd
    fi

    #   Next, install whole doc/, Docs/ ... directory

    CygbuildDetermineDocDir $builddir > $retval
    local dir=$(< $retval)

    if [ "$dir" ]; then

        #   Are there any files in it?

        local status
        $LS $dir/* > /dev/null 2>&1
        status=$?

        if [ "$status" = "0" ]; then

            echo "--   Installing docs from $dir"

            CygbuildRun $scriptInstallDir $dest || return $?

            CygbuildPushd

                cd $dir || exit 1

                #   Remove manual pages, there are already installed in
                #   man/manN/

                local taropt="--extract"

                if [ "$test" ]; then
                    taropt="--list"
                    echo "--   [NOTE] Test mode: install in $dir"
                fi

                status=""

                $TAR $optExclude $optExtra $verbose --create --file=- * \
                   | ( $TAR -C "$dest" $taropt --file=- )

                status=$?

            CygbuildPopd

            if [ "$status" != "0" ]; then
                CygbuildWarn "$id: [ERROR] tar failed to move files. " \
                     "Need to run [files]?"
                return $status
            fi

            CygbuildVerb "--  Fixing permissions in $dest"

            $FIND $dest -print > $retval

            local mode644 mode755

            for item in $(< $retval)
            do
                if [ -d "$item" ] || [[ $item == $CYGBUILD_MATCH_FILE_EXE ]]
                then
                    mode755="$mode755 $item"
                else
                    mode644="$mode644 $item"
                fi
            done

            if [ "$mode644" ]; then
                chmod 644 $mode644 || return $?
            fi

            if [ "$mode755" ]; then
                chmod 755 $mode755 || return $?
            fi

            return $status
        fi
    fi
}

function CygbuildInstallExtraManual()
{
    local id="$0.$FUNCNAME"
    local scriptInstallFile="$INSTALL_SCRIPT $INSTALL_FILE_MODES"
    local scriptInstallDir="$INSTALL_SCRIPT $INSTALL_BIN_MODES -d"

    local mandest=$instdir/$CYGBUILD_MANDIR_FULL
    local addsect=$CYGBUILD_MAN_SECTION_ADDITIONAL
    local file page name nbr mansect manpage program

    #   Convert Perl pod pages to manuals.

    local done=''

    for file in $DIR_CYGPATCH/*.pod           \
                $DIR_CYGPATCH/*.[1-9]         \
                $DIR_CYGPATCH/*.[1-9]$addsect
    do

        [[ $file == *\[*  ]]    && continue # Name was not expanded
        [ ! -f "$file" ]        && continue

        name=${file##*/}        # /path/to/program.1x.pod => program.1x.pod
        name=${name%.pod}       # program.1x.pod => program.1x
        manpage=$DIR_CYGPATCH/$name
        program=${name%$addsect}        # program.1x => program.1
        program=${program%.[0-9]}       # program.1 => program
        nbr=${name##*.}                 # program.1x => 1x

        if [[ $nbr != [0-9]* ]]; then
            CygbuildDie "$file does not include SECTION number (like *.1*)"
        fi

        if [[ $file == *.pod ]]; then

            if [ ! $done ]; then
                echo "--   Converting *.pod files to manual pages"
                done=1
            fi

            #  Unfortunately pod2man always includes some headers, so it
            #  must be fixed with sed. The manual page name is defined
            #  directly form $file and would loook like PROGRAM.6(SECTION)
            #  when it should read PROGRAM(SECTION)

            pod2man                                                 \
                --section="$nbr"                                    \
                --release="dummy123"                                \
                --center="User Contributed Documentation" $file |   \
                $SED -e 's/dummy123//g'                             \
                     -e "s/$name/$program/ig"                       \
                > $manpage  ||                                      \
                return $?
        fi

        #  Copy manual pages to installation directory

        nbr=${nbr%$addsect}
        mansect=$mandest/man$nbr

        echo "--   Copying external manual page $manpage to $mandest"

        $scriptInstallDir  $mansect
        $scriptInstallFile $manpage $mansect

    done
}

function CygbuildInstallExtraManualCompress()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    #  Compress all manual pages

    local DIR_DOC_GENERAL=$instdir/$CYGBUILD_MANDIR_FULL

    echo "--   Compressing manual pages"

    if [ ! -d "$DIR_DOC_GENERAL" ]; then
        echo "--   [WARN] Directory not found: $DIR_DOC_GENERAL"
    else

        if $FIND $DIR_DOC_GENERAL -type f  > $retval
        then
            $GZIP --force --best $(< $retval) || return $?
        fi

        if $FIND $DIR_DOC_GENERAL -type l -name "*.[1-9]" > $retval
        then
            for file in $(< $retval)
            do
                #   If same program is "alias", then we have to rearrange
                #   things a bit
                #
                #       xsetbg.1 -> xloadimage.1
                #
                #   If we compress xloadimage.1.gz, then the link would be
                #   invalid

                CygbuildPushd
                    cd ${file%/*} || exit $?
                    local name=${file##*/}

                    CygbuildPathAbsoluteSearch $name > $retval
                    path=$(< $retval)

                    if [ "$path" ] && [ -f "$path.gz" ]; then
                        $LN -sf $verbose "$path.gz" "$name.gz" || exit 1
                        $RM "$name"
                    fi
                CygbuildPopd
            done
        fi
    fi
}

function CygbuildInstallExtraMain()
{
    local id="$0.$FUNCNAME"

    CygbuildInstallExtraManual
}

function CygbuildInstallCygwinPartPostinstall()
{
    local id="$0.$FUNCNAME"

    local file=$SCRIPT_POSTINSTALL_CYGFILE
    local dest=$SCRIPT_POSTINSTALL_FILE

    if [ -f "$file" ]; then
        local scriptInstallFile="$INSTALL_SCRIPT $INSTALL_FILE_MODES"
        local scriptInstallDir="$INSTALL_SCRIPT $INSTALL_BIN_MODES -d"

        local tofile=$dest/$PKG.sh

        echo "--   Installing [Cygwin] postinstall script to dir $tofile"

        $scriptInstallDir $dest
        $scriptInstallFile $file $tofile
    fi
}

function CygbuildInstallCygwinPartMain()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local scriptInstallFile="$INSTALL_SCRIPT $INSTALL_FILE_MODES"
    local scriptInstallDir="$INSTALL_SCRIPT $INSTALL_BIN_MODES -d"

    local file
    CygbuildDetermineReadmeFile > $retval &&
    file=$(< $retval)

    if [ ! "$file" ]; then
        CygbuildDie "-- [FATAL] Can't find Cygwin specific README file"
    fi

    #   NOTE: the *.README file does not include RELEASE, just VERSION.

    for elt in \
      "required $file  $DIR_DOC_CYGWIN $PKG-$VER.README" \
      "optional $SCRIPT_PREREMOVE_CYGFILE   $DIR_PREREMOVE_CYGWIN $PKG.sh" \
      "optional $PREREMOVE_MANIFEST_CYGFILE $DIR_PREREMOVE_CYGWIN $PKG-$PREREMOVE_MANIFEST_NAME" \
      "optional $PREREMOVE_MANIFEST_FROM_CYGFILE $DIR_PREREMOVE_CYGWIN $PKG-$PREREMOVE_MANIFEST_FROM_NAME"
    do
        set -- $elt

        local mode=$1
        local fromfile=$2
        local todir=$3
        local tofile="$todir/$4"

        if [ "$mode" = "required" ] && [ ! -f "$fromfile" ]; then
            CygbuildWarn "$id: [ERROR] Missing file/dir: $fromfile"
            return 1
        fi

        [ ! -f "$fromfile" ] && continue

        $scriptInstallDir   $todir              || return $?
        $scriptInstallFile  $fromfile $tofile   || return $?
    done
}

function CygbuildCmdInstallCheckInfoFiles()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local dummy=$(pwd)                    # For debug
    local dir=$instdir

    #   If there is central info "dir", then there must be postinstall
    #   script to handle it.

    local notes
    $FIND -L $dir -name dir -o -name \*.info > $retval
    [ -s $retval ] && notes=$(< $retval)

    if [ "$notes" ]; then
        local file="$SCRIPT_POSTINSTALL_CYGFILE"

        if [ ! -f "$file" ]; then
            echo "--    [ERROR] Info files found" \
                 "but there is no $file"
            return 1
        fi
    fi
}

function CygbuildCmdInstallCheckPythonFile ()
{
    local id="$0.$FUNCNAME"
    local file="$1"

    if [ ! "$PYTHON" ]; then
        return 1
    fi

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local name=${file##*/}
    local newfile=$retval.fix.$name

    $EGREP '^#!/' $file | head -1 > $retval
    local binpath=$(< $retval)

    if [ ! "$binpath" ]; then
        CygbuildWarn \
            "--   [WARN] $name incorrect/missing bang-slash #!, fixing it."
        echo "#!$PYTHON" > "$newfile" &&
        $CAT "$file" >> "$newfile"    &&
        CygbuildRun $MV "$newfile" "$file"
    fi

    if [[ $binpath != *@($PYTHON|/usr/bin/env python) ]]; then
        CygbuildWarn "--   [WARN] $name uses wrong python path, fixing it."
        $SED -e "s,^#!.*,#!$PYTHON," "$file" > "$newfile" &&
        CygbuildRun $CP "$newfile" "$file"
    fi
}

function CygbuildCmdInstallCheckPerlFile ()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local file="$1"

    if [ ! "$PYTHON" ]; then
        return 1
    fi

    local name=${file##*/}
    newfile=$retval.fix.$name
    local warn err

    CygbuildVerb "--   Checking perl -cw $name"

    #  Check that program is well formed

    $PERL -cw $file > $retval 2>&1
    local notes=$(< $retval)

    if [[ "$notes" == *@INC* ]]; then

        #  Cannot locate Time/ParseDate.pm in @INC ...
        CygbuildWarn \
            "--   [WARN] $name: requires external Perl libraries (CPAN)"
        warn="yes"

    elif [[ "$notes" == *\ line\ * ]]; then

        #  Example: Unquoted string "imsort" may clash with future
        #           reserved word at foo.pl line 143.
        CygbuildWarn \
            "--   [WARN] $name: report compile warnings to upstream author"
        warn="yes"

    fi

    [ "$warn" ] && CygbuildWarn "$notes"

    if [[ "$notes" == *syntax*OK*  ]]; then
        # All is fine
        :
    elif [[ "$notes" == *syntax* ]]; then
        CygbuildWarn "--   [ERROR] $name: cannot be run"
        return 1
    fi

    local binpath
    $EGREP '^#!/' $file  | head -1 > $retval
    [ -s $retval ] && binpath=$(< $retval)

    if [ ! "$binpath" ]; then

        CygbuildWarn \
            "--   [WARN] $name incorrect/missing bang-slash #!, fixing it."
        echo "#!$PERL" > "$newfile" &&
        $CAT "$file" >> "$newfile"    &&
        CygbuildRun $MV "$newfile" "$file"

    elif [[ $binpath == +($PERL) ]]; then

        CygbuildWarn "--   [WARN] $name uses wrong perl path, fixing it."
        $SED -e "s,^#!.*,#!$PERL," "$file" > "$newfile" &&
        CygbuildRun $CP "$newfile" "$file"

    fi

    if CygbuildGrepCheck '^=pod' $file ; then
        echo "--   [INFO] found embeded POD from $file"
    else

        if CygbuildGrepCheck '^=cut' $file ; then
            #  Sometimes developers do not write well formed POD.
            echo "--   [NOTE] =pod tag is missing, but POD found: $file"
        else
            echo "--   [INFO] No embedded POD found from $file"
        fi
    fi
}

function CygbuildCmdInstallCheckShellFiles ()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local dir="$instdir$CYGBUILD_PREFIX"

    if [ ! -d "$dir/bin" ] || [ -d "$dir/sbin" ] ; then
        return 0
    fi

    local file rest

    #   Not all Perl files are installed with extension .pl
    #   Many will drop the *.{pl,py,sh} extension during install.

    file $dir/bin/* $dir/sbin/* 2> /dev/null |
    while read file rest
    do
        file=${file%:}

        if [ -h $file ]; then
            echo "--   [NOTE] symbolic link: $file"

            if CygbuildPathResolveSymlink "$file" > $retval ; then
                file=$(< $retval)
            else
                echo "--   [WARN] Couldn't resolve symlink"
            fi
        fi

        #   Make relative path if possible. Messages are better that way

        file=${file/$(pwd)\//}

        if [[ "$rest" == *perl* ]]; then
            CygbuildCmdInstallCheckPerlFile "$file"
        elif [[ "$rest" = *python* ]]; then
            CygbuildCmdInstallCheckPythonFile "$file"
        fi

    done
}

function CygbuildCmdInstallCheckTempFiles()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local dir=$instdir
    local ignore="$CYGBUILD_IGNORE_ZERO_LENGTH"
    local done file ret

    for file in $( $FIND -L $dir -type f                   \
                   '(' -size 0 -name "*[#~]*" ')'    \
                 )
    do
        [[ "$file" == $ignore ]] && continue

        [ ! "$done" ] && CygbuildWarn \
                         "--   [ERROR] Check zero length files or backup files"

        done="done"
        ret=1
        CygbuildWarn "$(ls -l $file)"
    done

    return $ret
}

function CygbuildCmdInstallCheckReadme()
{
    local id="$0.$FUNCNAME"
    local retva=$CYGBUILD_RETVAL.$FUNCNAME
    local dummy=$(pwd)                    # For debug
    local dir=$instdir
    local readme="$PKG*.README"
    local status=0

    $FIND -L $dir -name "$readme"  > $retval

    if [ ! -s $retval ]; then
        CygbuildWarn "--    [WARN] File is missing: $readme"
        let "status=status + 10"
        return $status
    fi

    local path=$(< $retval)
    local pkg=${path##*/}
    pkg=${pkg%.README}
    pkg=${pkg%-[0-9.]*}

    if [ "$pkg" != "$PKG" ]; then
        echo "--   [ERROR] package and dir name mismatch: $pkg != $PKG" \
             " $pkg != $PKG (searched for $readme)"
        let "status=status + 10"
    fi

    local purename=${path##*/}
    local origreadme=$DIR_CYGPATCH/$purename

    #   It is easy to mistakenly forgot to fill in:
    #   Cygwin port maintained by: <Your Name Here>  <your email here>

    local tags="(Your +name|Your +email)"
    local notes=""

    $EGREP -nie "$tags" $path /dev/null > $retval

    [ -s $retval ] && notes=$(< $retval)

    if [[ "$notes" == *[a-zA-Z0-9]* ]]; then
        CygbuildWarn "--   [WARN] Tags found: $tags"
        CygbuildWarn "--   [WARN] edit $origreadme"
        CygbuildWarn "$notes"
        let "status=status + 10"
    fi

    #   It is easy to mistakenly write:
    #   ----- version 4.2.7 -----
    #   When it should read:
    #   ----- version 4.2.7-1 -----

    local tags="[<](PKG|VER|older VER|REL|date)[>]"
    notes=""

    $EGREP -ne "$tags" $path /dev/null > $retval

    [ -s $retval ] && notes=$(< $retval)

    if [[ "$notes" == *[a-zA-Z0-9]* ]]; then
        CygbuildWarn "--    [WARN] Tags found: $tags"
        CygbuildWarn "--    [WARN] edit $origreadme"
        CygbuildWarn "$notes"
        let "status=status + 10"
    fi

    #   Check that ----- version 4.2.7-1 ----- corresponds
    #   current $VER-$REL
    #
    #   g-b-s uses
    #   ----------  <PKG>-<older VER>-1 -- <date> -----------
    #
    #  Convert special character like
    #  0.3+git20070827-1 =>  0.3[+]git20070827-1

    local rever=$(echo $VER | sed 's/\./[.]/g; s/+/[+]/g; ')    # regexp version
    local sversion=$rever-${REL:-1}                             # search version
    local version=$VER-${REL:-1}

    notes=""

    $EGREP --line-number --ignore-case -e \
        "-- +($PKG-|version +)?$sversion +--" $path /dev/null > $retval
    [ -s $retval ] && notes=$(< $retval)

    if [[ ! "$notes" ]]; then
        CygbuildWarn \
            "--   [WARN] Missing reference $version" \
            "(Perhaps you didn't run [install] after edit?)" \
            "from $path"

        [ "$verbose" ] && $EGREP --with-filename "$sversion" $path

        CygbuildWarn \
            "--   [INFO] Give different -r RELEASE or edit $origreadme"

        let "status=status + 10"
    fi

    return $status
}

function CygbuildCmdInstallCheckSetupHint()
{
    local id="$0.$FUNCNAME"
    local retva=$CYGBUILD_RETVAL.$FUNCNAME
    local dir=$DIR_CYGPATCH
    local file="setup.hint"
    local status=0
    local dummy=$(pwd)                    # For debug

    if [ ! -d "$dir" ]; then
        echo "--   [WARN] Cannot check setup.hint, no $dir"
        return
    fi

    #   -L = Follow symbolic links

    if ! $FIND -L $dir -name "$file"  > $retval ; then
        echo "--   [WARN] Hm, Can't find $file"
        return
    fi

    if [ ! -s $retval ]; then
        CygbuildWarn "--    [ERROR] Result file is empty or missing: $file"
        return 1
    fi

    local path=$(< $retval)

    if $EGREP "^sdesc:.+\.[ \t]*\"" $path /dev/null ; then
        CygbuildWarn "--   [ERROR] 'sdesc:' contains period(.)"
    fi

    #   Make case insensitive search for package name in ldesc / first line.
    #   Make sure libraries start with cyg* and not the old lib*

    $AWK '/^ldesc:/ {
            line = tolower($0);
            name = tolower(name);

            if ( match(line, name) == 0 )
            {
                next;
            }

            print;
            print "--   [ERROR] ldesc: mentions package name at first line" ;
        }

    ' name="$PKG" $path  >&2

    #  Installed files are here. We assume that developer always has
    #  every package and library installed

    local database="/etc/setup/installed.db"
    local lib

    for lib in $( $AWK  '/^requires:/ { sub("requires:", ""); print}' $path)
    do
        if $EGREP -q --files-with-matches "$lib" $database ; then
            echo "--   [OK] setup.hint $lib"
        else
            CygbuildWarn "--   [ERROR] setup.hint $lib package not installed"
        fi
    done
}

function CygbuildCmdInstallCheckDirStructure()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local pfx="$instdir$CYGBUILD_PREFIX"

    local ok try

    for try in $pfx/bin $pfx/sbin $pfx/lib $pfx/X11R6/bin
    do
        if [ -d "$try" ]; then
            ok=1
            break
        fi
    done

    local dir="$pfx/lib/X11/app-defaults"

    if [ -d "$dir" ]; then
        CygbuildWarn "--   [ERROR] No etc/X11/app-defaults, found $dir"
    fi

    if [ -d $instdir/doc ]; then
        CygbuildWarn "--   [ERROR] /doc should be /usr/doc"
    fi

    if [ -d $instdir/bin ]; then
        CygbuildWarn "--   [ERROR] /bin should be /usr/bin"
    fi

    if [ ! "$ok" ]; then
        CygbuildWarn "--   [ERROR] incorrect directory structure," \
             "$instdir contain no usr/bin, usr/sbin or usr/lib"
        return 1
    fi
}

function CygbuildCmdInstallCheckEtc()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local dir="$instdir"
    local file
    local status=0

    for file in $dir/etc/*
    do
        [[ $file == $CYGBUILD_IGNORE_ETC_FILES ]] && continue
        [ ! -f "$file" ]                          && continue

        CygbuildWarn "--   [WARN] May conflict with user's settings: $file"
        status=1
    done

    return $status;
}

function CygbuildCmdInstallCheckManualPages()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local addsect=$CYGBUILD_MAN_SECTION_ADDITIONAL
    local dir="$instdir"

    #   Every binary files should have corresponding manual page

    CygbuildFilesExecutable "$dir" > $retval

    local files=$(< $retval)

    if [ ! "$files" ]; then
        #   No executables, this may be a library package
        echo "--   [INFO] Manual page check: no executables found in $dir"
        return 0
    fi

    local file path manlist manPathList
    local status=0

    if $FIND -L $dir                \
        -type f                     \
        '('                         \
            -path    "*/man/*"      \
            -o -path "*/man[0-9]/*" \
        ')'                         \
        > $retval
    then
        for file in $(< $retval)
        do
            $EGREP -n 'Debian' $file > $retval

            if [ -s $retval ]; then
                echo "--   [INFO] If page was from Debian, it may need editing"
                $CAT $retval
            fi

            path=${file%/*}
            manPathList="$manPathList $path"

            name=${file##*/}        # Delete path
            name=${name%.gz}        # package.1.gz => package.1
            name=${name%.bz2}       # package.1.gz => package.1
            name=${name%$addsect}   # package.1x    => package.1
            name=${name%.[0-9]}     # package.1    => package
            manlist="$manlist $name "
        done
    fi

    #  Check incorrect locations
    #       .inst/usr/share/man1/
    #       .inst/usr/man1

    local try=$CYGBUILD_MANDIR_RELATIVE

    for path in $manPathList
    do
        if [[ $path != *$try* ]]; then
            CygbuildWarn "--   [ERROR] incorrect manual path [$try]: $path"
            status=1
        fi
    done

    local nameplain name

    for file in $files
    do

        # Ignore certain files
        # - w3m(1) installs sbin/w3m/cgi-bin/w3mman2html.cgi

        [[ $file == *.htm*          ]]    && continue
        [[ $file == */*test*/*      ]]    && continue
        [[ $file == *.cgi           ]]    && continue
        [[ $file == *cgi-bin*       ]]    && continue
        [[ $file == */doc/*         ]]    && continue
        [[ $file == */usr/share/*   ]]    && continue
        [[ $file == */usr/lib/*     ]]    && continue
        [[ $file == $CYGBUILD_IGNORE_ETC_FILES ]] && continue

        CygbuildFileIgnore "$file" && continue

        name=${file##*/}            # Delete path
        nameplain1=${name%.exe}     # package.exe => package
        nameplain2=${name%.*}       # package.sh, package.pl ...

        #   File start starts with leading dot?

        if [[ $file == */bin/* ]] && [[ $nameplain == .* ]]; then
            CygbuildWarn "--   [WARN] Suspicious file $file"
        fi

        #   The LIST is a string containing binary names and they are
        #   all surrounded by spaces: " prg1 prg2 ", see if

        if [[ "$manlist" == *\ $nameplain1\ * ]]; then

            :    # program.1

        elif [[ "$manlist" == *\ $nameplain2\ * ]]; then

            :

        elif [[ "$manlist" == *\ $name\* ]]; then

            :    # program.sh.1

        else
            echo "--   [WARN] No manual page for $file"
        fi

    done

    return $status
}

function CygbuildCmdInstallCheckDocPages()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local pfx=$CYGBUILD_PREFIX
    local dir=$instdir

    if ! $FIND -L $dir                   \
        -type f                          \
        '(' -path   "*/$pfx/doc/*"   ')' \
        > $retval
    then
        return
    fi

    local file path manlist manPathList
    local status=0

    for file in $(< $retval)
    do
        status=1

        CygbuildWarn "--   [ERROR] Wrong location $file"
    done

    return $status
}

function CygbuildCmdInstallCheckBinFiles()
{
    local id="$0.$FUNCNAME"
    local dir="$instdir"
    local status=0
    local maxsize=1000000       # 1 Meg *.exe is big

    #   If we find binary files, but they are not in $instdir, then
    #   Makefile has serious errors
    #   #TODO: why is here a subshell wrapper?

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    ( CygbuildFilesExecutable "$dir" ) > $retval
    local files=$(< $retval)

    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    CygbuildDependsList > $retval
    local depends=$(< $retval)

    if [ ! "$files" ]; then
        #   No executables, this may be a library package
        echo "--   [INFO] Binaries check: no executables found in $dir"
    fi

    #  All exe files must have +x permission

    $FIND -L $dir           \
    '(' -name \*.sh         \
        -o -name \*.exe     \
        -o -name "*.dll"    \
        -o -name "*.sh"     \
        -o -name "*.pl"     \
        -o -name "*.py"     \
    ')'                     \
    -a '(' -path "*python*site-pacages*" ')' -prune \
    -a \! -perm +111 -ls    \
    > $retval

    if [ -s $retval ]; then
        echo "--   [WARN] Hm, Some executables may have missing permission +x"
        $CAT $retval
        # status=1
    fi

    local installed

    if ls $CYGBUILD_DOCDIRCYG_FULL/$PKG*.README  > /dev/null 2>&1; then
        #   This package has already been installed into the system,
        #   otherwise this is a new package port
        installed="yes"
    fi

    local file
    local docdir="$CYGBUILD_DOCDIRCYG_FULL"

    #   FIXME: Currently every file in /bin is supposed to be executable
    #   This may not be always true?

    $FIND -L $dir -type f       \
        \(                      \
           -path "*/bin/*"      \
           -o -path "*/sbin/*"  \
        \)                      \
        > $retval

    local list=$(< $retval)

    for file in $list
    do
        if [ -h $file ]; then
            CygbuildPathResolveSymlink "$file" > $retval &&
            file=$(< $retval)
        fi

        local str=""
        local name=${file##*/}            # remove path

        #   Make sure none of the files clash with existing binaries

        if [ ! "$installed" ]; then

            CygbuildWhich $name > $retval
            [ -s $retval ] && str=$(< $retval)

            if [ "$str" ]; then
                echo "--   [NOTE] Binary name clash? Already exists $str"
                # status=1
            fi
        fi

        #   If files are compiled as static, the binary size is too big
        #   But X files may be huge

        if [[ "$file" != *X11* ]]; then

            $LS -l $file > $retval
            [ -s $retval ] && str=$(< $retval)

            if [ "$str" ]; then

                #  PATH -rwxr-xr-x  1 root None 1239 ...

                set -- $str
                local size=$5

                if [[ $size -gt $maxsize ]]; then
                    echo "--   [NOTE] Big file, need " \
                         "dynamic linking? $size $file"
                fi
            fi
        fi

        #   Sometimes package includes compiled binaries for Linux.
        #   Warn about those. The file(1) will report:
        #
        #   ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), for
        #   GNU/Linux 2.0.0, dynamically linked (uses shared libs),
        #   stripped

        $FILE $file > $retval
        [ -s $retval ] && str=$(< $retval)

        local name=${file##*.inst}

        if [[ "$str" == *Linux* ]]; then
            echo "--   [ERROR] file(1) reports Linux executable: $name"
            status=1

        elif [[ "$str" == *perl*   ]] && [[ ! $depends == *perl* ]] ; then
            echo "--   [ERROR] setup.hint may need Perl dependency" \
                 "for $name"
            status=1

        elif [[ "$str" == *python* ]] && [[ ! $depends == *python* ]]  ; then
            echo "--   [ERROR] setup.hint may need Python dependency" \
                 "for $name"
            status=1
        fi

        if [ "$verbose"  ]; then
            str=${str##*:}          # Remove path
            echo "--   $name: $str"

            #   Show library dependencies
            [[ $file == *.exe ]] && CygbuildCygcheck $file
        fi

    done

    return $status
}

function CygbuildCmdInstallCheckLibFiles()
{
    local id="$0.$FUNCNAME"
    local dir="$instdir"
    local status=0

    #   If we find binary files, but they are not in $instdir, then
    #   Makefile has serious errors

    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    $FIND -L $dir -type f           \
        '(' -name "*.a"             \
            -o -name "*.la"         \
            -o -name "*.dll" ')'    \
        > $retval

    local files=$(< $retval)

    if [ ! "$files" ]; then
        #   This is not a library package
        return
    fi

    local file

    for file in $files
    do
        file=${file##$srcdir/}
        echo "--   [INFO] Found lib $file"

        [ "$verbose" ] && CygbuildCygcheck $file

        if [[ $file == *dll  &&  $file == *usr/lib/*/* ]]; then

            #  This is ok case: /usr/lib/foo/input/file.dll

            echo "--   [NOTE] Hm, dynamically loaded lib?"

        elif [[ $file == *.a  &&  ! $file == *usr/lib/* ]]; then

            echo "--   [ERROR] Misplaced, should be in /usr/lib"
            status=2

        elif [[ $file == *dll  &&  ! $file == *usr/bin/* ]]; then

            echo "--   [ERROR] Misplaced, should be in /usr/bin"
            status=2
        fi

    done

    $FIND -L $dir -type f '(' -name "*.info" -o -name "*.info-[0-9]" ')' \
        > $retval
    local info=$(< $retval)

    $FIND  -L $dir -type f -path "*/man/*"  > $retval
    local man=$(< $retval)

    if [[ ! "$info"  &&  ! "$man" ]]; then
        CygbuildWarn \
            "--   [NOTE] Libraries found, but no *.info or /man/ files"
        # status=1
    fi

    if [[ "$files" != *.dll* ]]; then
        CygbuildWarn "--   [WARN] Libraries found, but no *.dll files"
    fi

    return $status
}

function CygbuildCmdInstallCheckLineEndings()
{
    #   Check Ctrl-M character: 0x0D, \015, \cM
    #   There is no easy "one command", because
    #
    #   a) It is not good to insert control characters directly into
    #      this program. It would be possible to type shell C-vC-m to get
    #      pure "^M" and use it in egrep expression.
    #
    #   b) sed does not know \r
    #   c) AWK strips \r at the end of lines before the line is "available"
    #   d) perl would do it, but its startup is slow
    #   e) od(1) would do, but's it's slower than cat(1)
    #
    #   => cat -v seems to be best compromize

    if [ ! -d "$DIR_CYGPATCH" ]; then
        echo "-- Skipped check. No $DIR_CYGPATCH"
    else
        # --files-with-matches = ... The scanning will stop on the first match.

        if  head $DIR_CYGPATCH/* | $CAT -v \
            | $EGREP --files-with-matches "\^M" \
              > /dev/null 2>&1
        then
            echo "-- [INFO] Converting to Unix line endings: $DIR_CYGPATCH/*"
            CygbuildFileConvertToUnix $DIR_CYGPATCH/*
        fi
    fi
}

function CygbuildCmdInstallSymlinkExe()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    # 2007-04-18
    # From: Eric Blake <ebb9-PGZyUNKar/Q@public.gmane.org>
    # Subject: All maintainers: repackage symlinks to executables
    # See http://permalink.gmane.org/gmane.os.cygwin.applications/14466

    $FIND $instdir -type l -name '*.exe' > $retval

    if [ -s $retval ]; then
        echo "-- [ERROR] Symlinks must not end to .exe."
            "Recompile with coreutils 6.9 installed."
        return 1
    fi
}

function CygbuildCmdInstallCheckMain()
{
    local id="$0.$FUNCNAME"

    #   See if there are any obvious errors
    #   - Zero length files

    local dummy=$(pwd)                    # For debug
    local stat=0

    CygbuildCmdInstallCheckLineEndings

    echo "** Checking content of installation in $instdir"

    CygbuildCmdInstallCheckTempFiles    || stat=$?
    CygbuildCmdInstallCheckInfoFiles    || stat=$?
    CygbuildCmdInstallCheckShellFiles   || stat=$?
    CygbuildCmdInstallCheckReadme       || stat=$?
    CygbuildCmdInstallCheckSetupHint    || stat=$?
    CygbuildCmdInstallCheckManualPages  || stat=$?
    CygbuildCmdInstallCheckDocPages     || stat=$?
    CygbuildCmdInstallCheckBinFiles     || stat=$?
    CygbuildCmdInstallCheckLibFiles     || stat=$?
    CygbuildCmdInstallCheckDirStructure || stat=$?
    CygbuildCmdInstallCheckEtc          || stat=$?
    CygbuildCmdInstallSymlinkExe        || stat=$?

    echo "-- Check done. Please verify messages above."

    return $stat
}

function CygbuildCmdInstallMain()
{
    local id="$0.$FUNCNAME"
    local scriptInstall=$SCRIPT_INSTALL_MAIN_CYGFILE
    local scriptAfter=$SCRIPT_INSTALL_AFTER_CYGFILE

    echo "** Install command"

    CygbuildExitNoDir $builddir \
              "$id: [ERROR] No builddir $builddir. Did you run 'shadow' ?"

    local dir=$instdir

    CygbuildPushd

        cd $builddir || exit 1

        if [ ! "$dir" ]; then
            CygbuildDie "$id: [ERROR] \$instdir is empty"
        fi

        local status

        if [ -d "$dir" ]; then

            #  -rf is too dangerous to run without check

            if [[ "$dir" == *.inst* ]]; then

                #   Other terminal is in this directory, so this might fail.

                echo "--   Emptying $dir"

                $RM -rf $dir/*

                if [ "$?" != "0" ]; then
                    CygbuildDie "-- [ERROR] Is some other terminal/window" \
                           "using the directory?"
                fi

            else
                CygbuildDie "$id: [ERROR] Suspicious \$instdir [$dir]"
            fi
        fi

        CygbuildInstallPackageDocs      &&
        CygbuildInstallPackageInfo      &&
        CygbuildInstallCygwinPartMain   &&
        CygbuildInstallCygwinPartPostinstall

        status=$?

        if [ "$status" != "0" ]; then
            local dummy="$id: FAILURE RETURN"       # For debug
            CygbuildPopd
            return $status
        fi

        if [ -f "$scriptInstall" ]; then

            $MKDIR -p $verbose "$instdir"
            echo "--   [NOTE] installing with external: $scriptInstall $dir"

            CygbuildChmodExec $scriptInstall
            $scriptInstall "$dir"

            status=$?

            if [ "$status" != "0"  ]; then
                CygbuildExit $status \
                    "$id: [ERROR] Failed to run $scriptInstall $dir"
            fi

        else
            echo "--   Running install to $instdir"

            CygbuildMakefileRunInstall ||
            {
                status=$?
                CygbuildPopd
                return $status
            }
        fi

        CygbuildMakefileRunInstallFixMain

        if [ -f "$scriptAfter" ]; then

            echo "--   [NOTE] Running external: $scriptAfter $dir"

            CygbuildChmodExec $scriptAfter

            CygbuildRun ${OPTION_DEBUG:+$BASHX} \
            $scriptAfter "$dir" ||
            {
                status=$?
                CygbuildPopd
                return $status
            }
        fi

        dummy="$srcdir"             # For debug only

        CygbuildExitNoDir "$srcdir" "$id: [ERROR] srcdir not found"

        dummy="END OF $id"

    CygbuildPopd

    CygbuildInstallExtraMain
    CygbuildInstallExtraManualCompress

    if [ "$verbose" ]; then
        echo "--   Content of: $instdir"
        $FIND -L ${instdir##$(pwd)/} -print
    else
        echo "-- See also: find .inst/ -print" \
             "${test:+(Note: test mode was on)} "
    fi
}

function CygbuildCmdScriptRunMain()
{
    local id="$0.$FUNCNAME"
    local script="$1"

    echo "-- Running $script $instdir"

    if [ -f "$script" ]; then

        local cmd=${OPTION_DEBUG:+"sh -x"}
        CygbuildRun $cmd $script $instdir

        if [ "$OPTION_DEBUG" ]; then

            #   postinstall usually runs the installed for info(1)
            #   files. Show the results if this dir exists.

            local dir=$instdir$CYGBUILD_INFO_FULL

            if [ -d "$dir" ]; then
                echo "-- [DEBUG] Content of info 'dir'"
                $FIND "$dir" -print
                $CAT "$dir/dir"
            fi
        fi
    fi
}

function CygbuildCmdPreremoveInstallMain()
{
    CygbuildCmdScriptRunMain "$SCRIPT_PREREMOVE_CYGFILE"
}

function CygbuildCmdPostInstallMain()
{
    CygbuildCmdScriptRunMain "$SCRIPT_POSTINSTALL_CYGFILE"
}

function CygbuildCmdStripMain()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local dir="$instdir"

    CygbuildExitNoDir "$dir" "$id: [ERROR] instdir [$instdir] not found"

    CygbuildFilesExecutable "$dir" "-o -type f ( -name "*.dll" )" \
    > $retval

    local files="$(< $retval)"
    local file done type list

    for file in $files
    do
        if [ ! "$done" ]; then
            echo "-- Stripping executables and *.dll"
            done=1
        fi

        type=""

        $FILE $file > $retval
        [ -s $retval ] && type=$(< $retval)

        #  Otherwise strip would say "File format not recognized"

        if [[ "$type" == *Intel* ]]; then
            CygbuildVerb "--   strip $file"
            list="$list $file"

        else
            CygbuildVerb "--   [INFO] Not a binary executable;" \
                 " strip skipped for $file"
        fi

    done

    if [ "$list" ]; then
        strip $list
    elif [ ! "$done" ]; then
        CygbuildWarn "--   [NOTE] Hm, no installed files to strip."
    fi
}

function CygbuildStripCheck()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local file

    $FIND $instdir \
        -type f '(' -name "*.exe" -o -name "*dll" ')' \
        | head -1 \
        > $retval

    [ -s $retval ] && file=$(< $retval)

    if [ ! "$file" ]; then

        $FIND $instdir -type f -name "*.a" -o -name "*.la" > $retval
        [ -s $retval ] && file=$(< $retval)

        if [ ! "$file" ]; then
            file=
            CygbuildWarn \
                "-- [NOTE] No *.exe, *.a or *.dll files, skipped strip."
            return 0
        fi

        echo "-- Hm, looks like a library .a or .la package," \
                 "skipping strip."
        return 0
    fi

    #   If strip has been run, then 'nm file.exe':
    #       nm: file.exe: no symbols
    #
    #   Sometimes it says:
    #       Not an x86 executable

    local saved="$IFS"
    local IFS=" "
        nm $file 2>&1 | head -1 > $retval
        set -- $(< $retval)
    IFS="$saved"

    if [[ "$*" == *no*symbols* ]]; then
        return 0
    elif [[ "$*"  == *Not*x86* ]]; then
        echo "--   [ERROR] $file is not valid executable"
        $FILE $file
        return 0
    else
        CygbuildVerbWarn "--   [WARN] Symbols found. I'm going to call" \
                         "[strip] first"
        CygbuildCmdStripMain
    fi
}

function CygbuildCmdFilesWrite()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local to="$1"
    shift
    local trydirs="$*"

    if [[ ! (-d $1 || -d $2) ]]; then
        CygbuildWarn "$id: [ERROR] Template directory does not exist: [$from1]"
        CygbuildWarn "$id: it should be at /etc/cygbuild/template if you" \
             "installed cygbuild package. See Web page for download."
        return 1
    fi

    if [ ! -d "$to" ]; then
        CygbuildWarn "$id: [ERROR] Write directory does not exist: $to"
        return 1
    fi

    echo "-- Writing default files to $to"

    local file

    for file in package.README setup.hint
    do
        CygbuildFileExists $file $trydirs > $retval || return $?
        local from=$(< $retval)
        local dest=$to/$file

        [[ $file == *README ]] && dest=$to/$PKG.README

        if [ -f "$dest" ]; then
            CygbuildVerb "--     Skip, already exists $dest"
        else
            $CP $verbose "$from" "$dest" || return $?
        fi
    done

    local dir

    for dir in $trydirs
    do
        [ ! -d "$dir" ] && continue

        for file in $dir/*.tmp
        do
            [ ! -f "$file" ] && continue

            local sh=${file##*/}        # /path/to/file.sh.tmp => file.sh.tmp
            local script=${sh%.tmp}     # file.sh.tmp => file.sh
            local dest=$to/$script

            if [ -f "$dest" ]; then
                #   User has taken template file into use
                CygbuildVerb "--    Skip, already exists $dest"

            elif [ -f "$to/$sh" ]; then
                #  Template file is already there.
                :
            else
                $CP $verbose "$file" "$to" || return $?
            fi
        done
    done
}

function CygbuildCmdFilesMain()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    local templatedir
    CygbuildTemplatePath > $retval
    [ -s $retval ] && templatedir=$(< $retval)

    if [ ! "$templatedir" ]; then
        CygbuildWarn "$id [ERROR] variable templatedir is empty"
        return 1
    fi

    local destdir=$DIR_CYGPATCH
    local userdir=$CYGBUILD_TEMPLATE_DIR_USER

    if [ ! "$destdir" ]; then
        CygbuildWarn "$id [ERROR] variable 'destdir' is empty"
        return 1
    fi

    if [ ! -d "$destdir" ]; then
        CygbuildCmdMkdirs "$verbose" || return 1
    fi

    CygbuildCmdFilesWrite $destdir $userdir $templatedir
}

function CygbuildCmdFinishMain()
{
    local id="$0.$FUNCNAME"
    local status=0

    if [[ $objdir == *$PKG-$VER*  ]];then

        echo "** [finish] Removing $objdir"

        if CygbuildIsGbsCompat ; then
            echo "-- [NOTE] GBS compat mode: results are not in ./.sinst" \
                 "but in $TOPDIR. Please note that possible GPG signatures" \
                 "are now invalid"

            CygbuildPushd
                #   Display *-src package and binary package
                cd "$TOPDIR" && ls -lat | head -3 | sed 's/^/   /'
            CygbuildPopd
        fi

        if [ "$(pwd)" = "$objdir" ]; then
            cd "$TOPDIR"                 #  Can't remove, if we're inside it
        fi

        $RM -rf "$objdir"
        status=$?

        if [ -d "$objdir" ]; then
            echo "--   [NOTE] rm failed. Is Windows using the directory?"
        fi

    else
        CygbuildWarn "$id: [WARN] Doesn't look like unpack dir [$PKG-$VER]," \
             "so not touching $objdir"
    fi

    return $status
}

#######################################################################
#
#       Guess functions: so that -f or -r need not be supplied
#
#######################################################################

function CygbuildFilePackageGuessFromDirectory()
{
    local id="$0.$FUNCNAME"
    local dir=$(pwd)
    local ret

    #   Does it look like foo-N.N ?

    [[ ! $dir == *-*[0-9]* ]]  && return 1

    if CygbuildDefineVersionVariables $dir ; then

        ret=$CYGBUILD_STATIC_VER_PACKAGE-$CYGBUILD_STATIC_VER_VERSION

        #  Directory looks like package-N.N/ add RELEASE

        if [ "$OPTION_RELEASE" ]; then
            ret=$ret-$OPTION_RELEASE
        fi
    fi

    dummy="$id: RETURN"         # Will show up in debugger
    echo $ret
}

function CygbuildFilePackageGuessArchive()
{
    local regexp="$1"
    local ignore="$2"

    $LS | $AWK  \
    '
     $0 ~ regexp  {
        if (length(ignore)>1  &&  match($0, ignore) > 1)
        {
            next;
        }
        print;
    }' regexp="$regexp" ignore="$ignore"
}

function CygbuildFilePackageGuessMain()
{
    #   DESCRIPTION
    #
    #       1) This function searches *current* directory for Cygwin Net
    #       release source file (*.tar.bz2). It is assumed, that this
    #       script (cygbuild) came from there and is used for building
    #       binaries from sources.
    #
    #       2) If user is instead trying to *port* a new package, he has
    #       ascended to the subdirectory foo-1.1/ where the packaging
    #       happens. In that case, the package name and version is read
    #       from the directory name.
    #
    #   LIST OF RETURN VALUES
    #
    #       <original package location>     This can be "!" if not found
    #       <release>
    #       <unpack dir i.e. TOP dir>

    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    #   If there is only one PACKAGE in current directory, make an educated
    #   guess and use that if user did not supply option -f
    #   We expect to see files like:
    #
    #       package-N.N.tar.bz2
    #       package-N.N.tar.gz
    #
    #   Finally, if there is a separate script that gets sources from external
    #   source, run it.

    local ret dummy len
    local -a arr

    #   The SRC package is not looked for, because that would be the Cygwin
    #   Net release source package. We need to find out the original
    #   developer package.

    if CygbuildIsArchiveScript ; then

        #  Debian uses: package_version.orig.tar.gz

        local ver="$SCRIPT_PACKAGE[_-]$SCRIPT_VERSION"

        CygbuildFilePackageGuessArchive \
            "$ver.(tar.gz|tar.bz2|orig.tar.gz|orig.tar.bz2|tgz)" \
            "(-src.tar.bz2|$SCRIPT_PKGVER-$SCRIPT_RELEASE[.]|[.]sig)" \
            >  $retval

        arr=( $(< $retval) )
        dummy="${arr[*]}"          # For bash debugging, what we got?
        len=${#arr[*]}

        if [ $len = "0" ]; then
            CygbuildWarn "-- [WARN] Packing script detection failed."
        fi

    else

        CygbuildFilePackageGuessArchive \
            "[0-9.]+-[0-9].*(tar.bz2)" \
            >  $retval

        arr=( $(< $retval) )
        len=${#arr[*]}
    fi

    #   Check if all files have same first word: PACKAGENAME. If not,
    #   we do not know what package user wants to use

    if [[ $len -gt 1 ]]; then

        local tmp=${arr[0]}     # package-N.N.tar.gz
        local word=${tmp%%-*}   # package
        local element fail

        for element in ${arr[*]}
        do
            if [[ "$element" != $word* ]]; then
                CygbuildWarn \
                    "--    [WARN] Different archive files: $word <> $element" \
                    "Please use option -f FILE"
                fail=1
                break
            fi
        done

        if [ ! "$fail" ]; then
            ret=${arr[0]}
        fi

    elif [ "$len" = "1" ]; then     # Fresh and empty dir. Good. One tar file.

        ret=${arr[0]}

    else

        #  No tar files around to guess, try if this directory holds
        #  package name and user is currently porting a package

        local retval=$CYGBUILD_RETVAL.$FUNCNAME
        CygbuildFilePackageGuessFromDirectory > $retval &&
        ret=$(< $retval)

        # CygbuildWarn "--   [INFO] Cannot find original package. Version guessed from dir"
    fi

    local pwd=$(pwd)

    if [[ "$ret"  &&  $ret != */*  ]]; then
        #  Make absolute path
        ret=$pwd/$ret
    fi

    #   When doing Source builds, the script is named foo-2.1-1.sh
    #   and files are located in current directory. The Source directory
    #   is supposed be directly under it.

    local tdir release

    if [ "$SCRIPT_PKGVER" ]; then
        tdir=$pwd/$SCRIPT_PKGVER
        release=$SCRIPT_RELEASE
    fi

    dummy="$id: RETURN $ret $release $tdir"

    [ ! "$ret" ] && ret="!"         #  Nothing found

    echo "$ret" "$release" "$tdir"
}

function CygbuildFileReleaseGuess()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local ret

    #   Debian source packages are in format
    #   package_N.N.orig.tar.gz

    local -a arr

    $LS 2> /dev/null \
        | $EGREP -e '[-_][0-9]+(-src\.tar|\.orig\.tar|\.patch)' \
        > $retval

    [ -s $retval ] && arr=( $(< $retval) )

    local dummy="$arr"          # For debug

    local count=${#arr[*]}

    if [ "$count" = "1" ]; then
        ret=${arr[0]}
    elif [ "$count" = "2" ]; then

        #  Found exactly two, source and binary package. Pick source
        #  package-N.N-RELEASE-src.tar.bz2
        #  package-N.N-RELEASE.tar.bz2

        echo "${arr[*]}"                \
             | $TR ' ' '\n'             \
             | $EGREP -e '-src|\.orig.' \
             > $retval

        ret=$(< $retval)
    fi

    if [ "$ret" ]; then
        echo $ret
    else
        return 1
    fi
}

#######################################################################
#
#       Main
#
#######################################################################

function CygbuildCommandMainCheckHelp()
{
    local tmp

    for tmp in "$@"
    do
        case "$tmp" in
            -h|help)
                CygbuildHelpShort 0
                ;;
            --help)
                CygbuildHelpLong 0
                ;;
            -V|--version)
                echo "$CYGBUILD_NAME $CYGBUILD_VERSION $CYGBUILD_HOMEPAGE_URL"
                exit 0
                ;;
        esac
    done
}

function CygbuildCommandMain()
{
    local id="$0.$FUNCNAME"

    CygbuildBootVariablesId
    CygbuildBootVariablesCache
    CygbuildBootVariablesGlobal

    local retval=$CYGBUILD_RETVAL.$FUNCNAME

    #  If the first argument is filename, remove it
    #  ./links-1.99.20-1.sh --verbose all

    if [[ "$1" == *+(cygbuild|.sh) ]]; then
        shift
    fi

    CygbuildDefineGlobalCommands
    CygbuildDefileInstallVariables

    # ................................................. read options ...

    local arg args dir quiet
    local release package

    local stripflag="yes"
    unset verbose

    local OPTIND=1

    #   Globally visible options

    unset OPTION_DEBUG              # global-def
    unset OPTION_DEBUG_VERIFY       # global-def
    unset OPTION_FILE               # global-def
    unset OPTION_GBS_COMPAT         # global-def
    unset OPTION_RELEASE            # global-def
    unset OPTION_PREFIX             # global-def
    unset OPTION_SIGN               # global-def
    unset OPTION_PASSPHRASE         # global-def
    unset OPTION_PREFIX             # global-def
    unset OPTION_PREFIX_MAN         # global-def
    unset OPTION_PREFIX_CYGINST     # global-def
    unset OPTION_PREFIX_CYGBUILD    # global-def
    unset OPTION_PREFIX_CYGSINST    # global-def
    unset verbose                   # global-def
    unset test                      # global-def

    OPTION_SPACE="yes"              # global-def


    #   On Cygwin upgrades, it may be possible that this proram is not
    #   installed

    if ! CygbuildWhich getopt > /dev/null ; then
        CygbuildDie "$id: 'getopt' not in PATH. Cannot read options."
    fi

    getopt \
        -n $id \
        --long checkout,debug:,Debug:,email:,gbs,init-pkgdb:,install-prefix:,install-prefix-man:,cyginstdir:,cygbuilddir:,cygsinstdir:,install-usrlocal,file:,passphrase:,nomore-space,sign:,release:,Prefix:,sign:,test,verbose,version,Version,no-strip \
        --option cDd:e:f:gmp:Pr:s:tvVx -- "$@" \
        > $retval

    if [ $? != 0 ] ; then
        CygbuildDie "$id: Cannot read options."
    fi

    eval set -- $(< $retval)
    tmp=15

    while [ "$*" ]
    do

      # safeguard against infinite loops

      tmp=$((tmp - 1))

      if [ $tmp -eq 0 ]; then
          CygbuildDie "$id:  [FATAL] Infinite loop while parsing arguments"
      fi

      local dummy="$1, $*"        # just for debugging

      case $1 in

            -c|--checkout)
                OPTION_VC_PACKAGE="yes"         # global-def
                shift 1
                ;;

            --cyginstdir)
                OPTION_PREFIX_CYGINST="${2%/}"  # global-def no trail. slash
                shift 2
                ;;

            --cygbuilddir)
                OPTION_PREFIX_CYGBUILD="$2"     # global-def
                shift 2
                ;;

            --cygsinstdir)
                OPTION_PREFIX_CYGSINST="$2"     # global-def
                shift 2
                ;;

            -d|--debug)
                if [[ "$2" != [0-9] ]]; then
                    CygbuildWarn "-- [WARN] Debug level" \
                        " not numeric [$2]. Adjusting to 1"
                else
                    OPTION_DEBUG=$2             # global-def
                    shift 2

                fi
                ;;

            -D|--Debug)
                OPTION_DEBUG_VERIFY="yes"       # global-def
                shift
                ;;

            -e|--email)
                export CYGBUILD_EMAIL="$2"      # global-def
                shift 2
                ;;

            -g|--gbs)
                export OPTION_GBS_COMPAT="gbs"  # global-def
                shift 1
                ;;

            -f|--file)
                OPTION_FILE="$2"                # global-def
                package="$2"
                CygbuildStrRemoveExt "$package" > $retval
                package=$(< $retval)
                shift 2
                ;;

            --init-pkgdb)
                CygbuildDefineGlobalPackageDatabase "$2"
                shift 2
                CygbuildExit 0 "-- Done. Database is up to date (for now)."
                ;;

            --install-prefix)
                OPTION_PREFIX="$2"              # global-def
                shift 2
                ;;

            --install-prefix-man)
                OPTION_PREFIX_MAN="$2"          # global-def
                shift 2
                ;;

            --install-usrlocal)
                shift
                CygbuildDefileInstallVariablesUSRLOCAL
                ;;

            -p|--passphrase)
                if [[ "$2" == -* ]]; then
                    CygbuildDie "$id: [ERROR] -p option needs pass phrase." \
                           "Got [$2]"
                fi

                OPTION_PASSPHRASE="$2"          # global-def
                shift 2
                ;;

            -m|--nomore-space)
                OPTION_SPACE=""                 # global-def
                shift
                ;;

            -r|--release)
                if [ "$2" = "date" ]; then
                    CygbuildDate > $retval
                    release=$(< $retval)
                else
                    release="$2"
                fi

                if ! CygbuildIsNumber "$release" ; then
                    CygbuildDie "$id: [ERROR] release value must be numeric." \
                         "Got [$release]"
                    exit 1
                fi

                OPTION_RELEASE=$release         # global-def
                shift 2
                ;;

            -s|--sign)
                if ! CygbuildGPGavailableCheck ; then
                    CygbuildWarn "-- [WARN] -s option used, but no gpg" \
                        "is available"
                fi

                if [[ "$2" == -* ]]; then
                    CygbuildDie "$id: [ERROR] -s option needs signer ID." \
                        "Got [$2]"
                fi

                OPTION_SIGN="$2"                # global-def
                shift 2
                ;;

            -P|-Prefix)
                OPTION_PREFIX="yes";            # global-def
                shift
                ;;

            -t|--test)
                echo "-- [NOTE] RUNNING IN TEST MODE - Changes are minimized"
                test="test"                     # global-def
                shift
                ;;

            -v|--verbose)
                verbose="--verbose"             # global-def
                shift
                ;;

            -V|--version|--Version)
                echo $CYGBUILD_VERSION
                return
                ;;

            -x|--no-strip)
                stripflag=
                shift
                ;;

            --) shift
                break
                ;;

            -*) CygbuildDie "$id: Unknown option  [$1]. Aborted."
                ;;
      esac
    done

    # ............................................ special commands ...
    # These do not need to know about package, release etc.

    local opt arg
    local status=0

    for opt in "$@"
    do
        case $opt in

          getsrc)               shift
                                arg="$1"
                                shift
                                CygbuildCmdGetSource "$arg"
                                exit $?
                                ;;
        esac
    done

    # ........................................ determine environment ...

    if [ "$verbose" ] && [ ! "$OPT_VC_PACKAGE" ]; then

        local vctype
        CygbuildVersionControlType > $retval
        [ -s $retval ] && vctype=$(< $retval)

        if [ "$vctype" ]; then
            CygbuildWarn \
                "-- [INFO] Version controlled source. Need option --checkout?"
        fi
    fi

    CygbuildCheckRunDir
    CygbuildDefineGlobalScript

    #  See if user supplied the RELEASE. This can be implicit in the
    #  package name, in which case it is ok. Otherwise user has to
    #  explicitly give it. Either way, we need to know it, otherwise
    #  the build directories cannot be determined correctly

    PACKAGE_NAME_GUESS=                 # global-def
    local releaseGuess
    local srcGuess

    if [ ! "$package" ]; then

        if ! CygbuildFilePackageGuessMain > $retval ; then
            echo "$id: [FATAL] $? CygbuildFilePackageGuessMain()"   \
                 " call error $?"                                   \
                 "Please debug and check content of $retval"        \
                 "Is filesystem full?"
            exit 1
        fi

        local -a arr=( $(< $retval) )

        PACKAGE_NAME_GUESS=${arr[0]}
        releaseGuess=${arr[1]}
        srcGuess=${arr[2]}
        package=$PACKAGE_NAME_GUESS

        if [ $package = "!" ]; then
            CygbuildDie "[FATAL] Can't determine package, version, release." \
                "Are you at dir foo-N.N/ or do you need option -f ?"
        fi

    fi

    if [ ! "$release" ]; then           # User did not give -r RELEASE
        if [ "$releaseGuess" ]; then
            release=$releaseGuess
        else
            CygbuildFileReleaseGuess > $retval
            [ -s $retval ] && release=$(< $retval)
        fi
    fi

    if [ ! "$release" ] && [ "$package" ]; then
        CygbuildStrRelease $package > $retval || exit 1
        tmprel=$(< $retval)
    fi

    if [ ! "$release" ] && [ ! "$tmprel" ]; then

        #   User did not supply -r, or we cannot parse release from
        #   -f NAME

        CygbuildVerb "-- [NOTE] -r RELEASE not set. Assuming 1"
        release=1
    fi

    if [ $# -lt 1 ]; then
        CygbuildWarn "$id: [ERROR] COMMAND is missing." \
            "See option -h"
        exit 1
    fi

    # ................................................ set variables ...

    local top src argDirective

    if [ "$srcGuess" ]; then
        #   This is foo-2.1-1.sh unpack script, so source is not unpackges
        #   yet.
        top=$(pwd)
        src=$srcGuess
        argDirective=noCheckSrc
    else
        CygbuildSrcDirLocation $(pwd) > $retval
        local -a arr=( $(< $retval) )

        top=${arr[0]}
        src=${arr[1]}
    fi

    CygbuildDefineEnvClear

    CygbuildDefineGlobalMain    \
        "$top"                  \
        "$src"                  \
        "$release"              \
        "$package"              \
        "$argDirective"

    if [ $? -ne 0 ]; then
        #   Somehing went wrong while defining variables
        exit 1
    fi

    CygbuildReadmeReleaseMatchCheck

    # ................................................ user commands ...

    local status=0

    for opt in "$@"
    do
        case $opt in

          all)
                #   The "prep" will also run "clean" and "distclean"
                #   because there are misconfigured source packages
                #   that dstribute compiled binaries.

                echo "-- [NOTE] command [all] is used for checking" \
                     "build procedure only." \
                     "See -h for source development options."

                #   The "{ A && B; } || :" reads:
                #
                #       IF command A succeeds, then run B. In either
                #       case always return true, so that we can continue.

                CygbuildCmdGPGVerifyMain Yn     &&
                CygbuildCmdPrepMain             &&
                CygbuildCmdShadowMain           &&
                CygbuildCmdConfMain             &&
                CygbuildCmdBuildMain            &&
                CygbuildCmdInstallMain          &&
                CygbuildCmdStripMain            &&
                CygbuildCmdPkgBinaryMain        &&
                {
                    if CygbuildHelpSourcePackage ; then
                        CygbuildCmdPkgSourceMain
                    elif [ "$OPTION_GBS_COMPAT" ] ; then
                        echo "-- Not attempting to build a source package"
                    fi ;
                }

                status=$?

                if [ "$status" != "0" ]; then
                    if CygbuildAskYes "There was an error. Run [finish]"
                    then
                        CygbuildCmdFinishMain
                        break
                    else
                        echo "... remove the SRC directory when ready"
                    fi
                else
                    CygbuildCmdFinishMain
                fi

                ;;

          auto*)                CygbuildCmdAutotool
                                ;;

          *clean)               CygbuildCmdCleanByType "$opt"
                                status=$?
                                ;;

          check)                CygbuildCmdInstallCheckMain
                                status=$?
                                ;;

          checksig)             CygbuildCmdGPGVerifyMain
                                status=$?
                                ;;

          check-deps)           # CygbuildCmdDependCheckMain
                                CygbuildCmdInstallCheckBinFiles
                                status=$?
                                ;;

          conf*)                CygbuildCmdConfMain
                                status=$?
                                ;;

          depend*)              CygbuildCmdDependMain
                                status=$?
                                ;;

          finish)               CygbuildCmdFinishMain
                                status=$?
                                ;;

          files)                CygbuildCmdFilesMain
                                status=$?
                                ;;

          install)              CygbuildCmdInstallMain
                                status=$?
                                ;;

          install-extra)        #  Generate POD manuals and
                                #  compress manual pages
                                CygbuildInstallExtraMain
                                status=$?
                                ;;

          list)
                                CygbuildPushd
                                    cd $srcdir &&
                                    find $instdir_relative -print
                                CygbuildPopd
                                ;;

          make|build)           CygbuildCmdBuildMain
                                status=$?
                                ;;

          makedirs|mkdirs)      CygbuildCmdMkdirs $verbose
                                status=$?
                                ;;

          makepatch|mkpatch)
                                CygbuildCmdMkpatchMain   \
                                    "$OPTION_SIGN"       \
                                    "$OPTION_PASSPHRASE" &&
                                CygbuildPatchCheck
                                status=$?
                                ;;

          package|bin-package|package-bin|pkg)
                                CygbuildNoticeMaybe
                                CygbuildNoticeGPG

                                if [ "$stripflag" ]; then
                                    CygbuildStripCheck      &&
                                    CygbuildCmdPkgBinaryMain
                                    status=$?
                                else
                                    CygbuildCmdPkgBinaryMain
                                    status=$?
                                fi
                                ;;

          package-devel|pkgdev)
                                CygbuildNoticeMaybe
                                if [ "$stripflag" ]; then
                                    CygbuildStripCheck      &&
                                    CygbuildCmdPkgDevelMain
                                    status=$?
                                else
                                    CygbuildCmdPkgDevelMain
                                    status=$?
                                fi
                                ;;

          package-sign|pkg-sign|sign|sign-package*)

                                if [ ! "$OPTION_SIGN" ]; then
                                    CygbuildWarn "[ERROR] -s option missing"
                                    status=1
                                else
                                    CygbuildGPGsignMain      \
                                        "$OPTION_SIGN"       \
                                        "$OPTION_PASSPHRASE"
                                    status=$?
                                fi
                                ;;

          repackage-all|repackage|repkg)

                                #   - Both bin and source packages are made:
                                #     install, pkg, fix, install pkg ...
                                #   - This is needed twice due to way
                                #     readmefix works.

                                CygbuildNoticeGPG

                                CygbuildCmdConfMain         &&
                                CygbuildCmdBuildMain        &&
                                CygbuildCmdInstallMain      &&
                                CygbuildCmdInstallCheckMain &&
                                CygbuildStripCheck          &&
                                CygbuildCmdPkgBinaryMain    &&
                                CygbuildCmdInstallMain      &&
                                CygbuildCmdPkgBinaryMain    &&
                                {
                                    CygbuildHelpSourcePackage   &&
                                    CygbuildCmdPkgSourceMain ;
                                }   || :                        &&
                                CygbuildCmdPublishMain
                                status=$?
                                ;;

          repackage-bin|repkgbin)
                                CygbuildNoticeGPG

                                CygbuildCmdConfMain         &&
                                CygbuildCmdBuildMain        &&
                                CygbuildCmdInstallMain      &&
                                CygbuildCmdPkgBinaryMain    &&
                                CygbuildCmdInstallCheckMain
                                status=$?
                                ;;

          repackage-devel|repkgdev)
                                CygbuildNoticeGPG

                                CygbuildCmdConfMain         &&
                                CygbuildCmdBuildMain        &&
                                CygbuildCmdInstallMain      &&
                                CygbuildCmdPkgDevelMain     &&
                                CygbuildCmdInstallCheckMain
                                status=$?
                                ;;

          patch)                CygbuildPatchApplyMaybe
                                status=$?
                                ;;

          patch-check)          verbose="verbose" CygbuildPatchCheck
                                status=$?
                                ;;

          prep*|unpack)         CygbuildCmdPrepMain
                                status=$?
                                ;;

          preremove)            CygbuildCmdPreremoveInstallMain
                                status=$?
                                ;;
          postinstall)          CygbuildCmdPostInstallMain
                                status=$?
                                ;;

          publish)              CygbuildCmdPublishMain
                                status=$?
                                ;;

          source-package|package-source|spkg)

                                CygbuildHelpSourcePackage
                                status=$?

                                if [ "$status" = "0" ]; then
                                    CygbuildNoticeGPG
                                    CygbuildNoticeMaybe
                                    CygbuildCmdPkgSourceMain
                                    status=$?
                                fi
                                ;;

          readme)               CygbuildDocFileReadme
                                status=$?
                                ;;

          readmefix)            CygbuildCmdReadmeFix
                                status=$?
                                ;;

          reshadow)             CygbuildCmdShadowDelete  &&
                                CygbuildCmdShadowMain
                                status=$?
                                ;;

          rmshadow)             CygbuildCmdShadowDelete
                                status=$?
                                ;;

          shadow)               CygbuildCmdShadowMain
                                status=$?
                                ;;

          strip)                if [ "$stripflag" ]; then
                                    CygbuildCmdStripMain
                                    status=$?
                                else
                                    status=0
                                fi
                                ;;

          test)                 CygbuildCmdTestMain
                                status=$?
                                ;;

          unpatch)              CygbuildPatchApplyMaybe unpatch
                                status=$?
                                ;;

          upstream-download|udl)
                                CygbuildCmdDownloadUpstream
                                status=$?
                                ;;

          vars) set -x
                CygbuildDefineGlobalMain "$TOPDIR" "$srcdir" \
                    "$release" "$package"
                return
                ;;

        verify) CygbuildCmdGPGVerifyMain
                status=$?
                ;;

          *)    CygbuildWarn "$id: [ERROR] bad argument [$opt]. See -h"
                exit 1
                ;;

        esac

        if [ "$status" != "0" ]; then
            CygbuildExit $status "$id: [FATAL] status is $status."
        fi

    done

    echo "-- Done."
}

function CygbuildMain()
{
    local id="$0.$FUNCNAME"

    #  Run a quick option check before we call all initialization
    #  function that are slow. Also export library functions.

    CygbuildCommandMainCheckHelp "$@"
    CygbuildBootFunctionExport

    #   This file can be included as a bash library. Like this:
    #
    #       #!/bin/bash
    #       ... load library
    #       export CYGBUILD_LIB=1
    #       source $(/usr/bin/which cygbuild.sh)
    #       ... call functions

    if [ ! "$CYGBUILD_LIB" ]; then

        if [[ $# -gt 0 ]]; then
            CygbuildCommandMain "$@"
            CygbuildFileCleanTemp
        else
            CygbuildWarn "$id: No options given. See -h"
        fi
    fi
}

function Test ()
{
    PKG=$(basename $(pwd) | sed 's/-.*//' )
    DIR_CYGPATCH=CYGWIN-PATCHES
    CYGBUILD_RETVAL="/tmp/Cygbuild.tmp"
    PERL=perl

#    CygbuildDefineGlobalCommands
    set -x

    local tmp=/tmp/xterm-229

    CygbuildVersionInfo $tmp
#    CygbuildStrPackage $tmp
}

CygbuildMain "$@"

# End of file
