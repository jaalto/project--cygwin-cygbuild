#!/bin/bash
#
#   libcheck.sh -- Library of check functions for cygbuild
#
#       Copyright (C) 2003-2010 Jari Aalto
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
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#       General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#	along with program. If not, write to the Free Software
#	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
#	02110-1301, USA.
#
#       Visit <http://www.gnu.org/copyleft/gpl.html>

shopt -s extglob    # Use extra pattern matching options

#######################################################################
#
#	    FILES
#
#######################################################################

function CygbuildCmdInstallCheckMakefiles()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local done file ret

    find -L "$builddir" -type f     \
        '(' -name Makefile          \
            -o -name makefile       \
            -o -name GNUMakefile    \
         ')' |
    xargs --no-run-if-empty \
    $EGREP --line-number '^[^#]*lib[a-z0.9]+\.a' /dev/null |
    $EGREP --invert-match '\.dll'  > $retval

    if [ -s "$retval" ]; then
        CygbuildEcho "-- [NOTE] Possibly linked by using static libraries"
        cat $retval | sed "s,^$srcdir/,,"
    fi
}

function CygbuildCmdInstallCheckTempFiles()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local dir="$instdir"
    local ignore="$CYGBUILD_IGNORE_ZERO_LENGTH"
    local done file ret

    find -L $dir -type f               \
        '(' -size 0 -name "*[#~]*" ')' \
        > $retval

    while read file
    do
        [[ "$file" == $ignore ]] && continue

        [ ! "$done" ] && CygbuildWarn \
                         "-- [ERROR] Check zero length files or backup files"

        done="done"
        ret=1

        CygbuildWarn "$(ls -l $file)"
    done < $retval

    return $ret
}

function CygbuildCmdInstallCheckInfoFiles()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local dummy=$(pwd)                    # For debug
    local dir="$instdir"

    find -L $dir -name dir -o -name "*.info" > $retval
    [ -s "$retval" ] && notes=$(< $retval)

    #   If there are *.info files, then there must be postinstall
    #   script to call install-info.

    local notes

    find -L $dir -name dir -o -name "*.info" > $retval
    [ -s "$retval" ] && notes=$(< $retval)

    if [ "$notes" ]; then
        local file="$SCRIPT_POSTINSTALL_CYGFILE"

        if [ ! -f "$file" ]; then
            CygbuildEcho "-- [ERROR] Info files found" \
                 "but there is no ${file/$srcdir\//}"
            return 1
        fi
    fi
}

function CygbuildCmdInstallCheckTexiFiles()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local dir="$instdir"
    local infodir="$dir/usr/share/info"

    #  *.texi files should be converted into *.info

    CygbuildFindDo . -o -name "*.texi" > $retval

    local texi

    if [ -s $retval ] ; then
	CygbuildEcho "-- Texi files found"
	sed 's,^\./,,' $retval

	local file name info

	while read file
	do
	    name=${file##*/}
	    name=${name%.texi}
	    info="$infodir/$name.info"

	    if [ ! -f "$info" ]; then
		CygbuildEcho "-- [NOTE] Texi, but no info file" \
		    ${info#$srcdir/}
	    fi

	done < $retval
    fi
}

function CygbuildCmdInstallCheckPerlFile ()
{
    local id="$0.$FUNCNAME"
    local file="$1"

    [ -f "$file" ] || return 0

    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local _file=${file#$srcdir/}
    local name=${file##*/}

    #	Check that program is well formed

    perl -cw $file > $retval 2>&1

    #	Not interested in warning from Perl base system
    #	    Constant subroutine main::DEBUG redefined at /usr/lib/perl5/5.8/constant.pm line 103.

    grep --invert-match 'at /usr/lib/perl[0-9]/' $retval > $retval.tmp &&
    mv --force "$retval.tmp" "$retval"

    [ -s "$retval" ] || return 0

    local notes=$(< $retval)

    CygbuildVerb "-- Checking perl -cw $name"

    if [[ "$notes" == *@INC* ]]; then

        #  Cannot locate Time/ParseDate.pm in @INC ...
        CygbuildWarn \
            "-- [WARN] $name: requires external Perl libraries (CPAN)"

	CygbuildWarn "$notes"

    elif [[ "$notes" == *\ line\ * ]]; then

        #  Example: Unquoted string "imsort" may clash with future
        #           reserved word at foo.pl line 143.
        CygbuildVerb \
            "-- [NOTE] $name: report compile warnings to upstream author"

        CygbuildVerb "$notes"
    fi

    if [[ "$notes" == *syntax*OK*  ]]; then
        # All is fine
        :
    elif [[ "$notes" == *syntax* ]]; then
        CygbuildWarn "-- [ERROR] $name: cannot be run"
        return 1
    fi

    head --lines=1 "$file" > $retval
    local binpath=$(< $retval)

    local plpath="$PERL_PATH"
    local newfile="$retval.fix.$name"

    if ! echo $binpath | $EGREP --quiet '^#![[:space:]]*/' ; then

        CygbuildWarn \
            "-- [NOTE] $name incorrect or missing bang-slash line, fixing it"

	cat "$retval"

	#   Replace first line.

        echo "#!$plpath" > "$newfile" &&
        tail --lines=+2 "$file" >> "$newfile" &&
        CygbuildRun mv "$newfile" "$file"

    elif [[ ! $binpath == *$plpath* ]]; then

        CygbuildWarn "-- [WARN] $name uses wrong perl path, fixing it."
        sed -e "s,^#!.*,#!$plpath," "$file" > "$newfile" &&
        CygbuildRun mv "$newfile" "$file"

    fi

    if $EGREP '^[^#]*\<cp[[:space:]]+-l\>' $file ; then
        CygbuildEcho "-- [NOTE] cp -l detected;" \
	    "only efficient under NTFS: $_file"
    fi

    if CygbuildGrepCheck '^=pod' $file ; then
        CygbuildEcho "-- [INFO] POD section in $file"
    else

        if CygbuildGrepCheck '^=cut' $file ; then
            #  Sometimes developers do not write well formed POD.
            CygbuildEcho "-- [NOTE] =pod tag is missing, but POD found:" \
		$_file
        else
            CygbuildEcho "-- [INFO] No embedded POD found from $_file"
        fi
    fi
}

function CygbuildCmdInstallCheckPythonFile ()
{
    local id="$0.$FUNCNAME"
    local file="$1"

    [ -f "$file" ] || return 0

    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local pypath="$PYTHON_PATH"
    local newfile="$retval.fix.$name"
    local name=${file##*/}

    $EGREP '^#! */' $file | head --lines=1 > $retval
    local binpath=$(< $retval)

    if [ ! "$binpath" ]; then
        CygbuildWarn \
            "-- [WARN] $name incorrect/missing bang-slash #!, fixing it."
        echo "#!$pypath" > "$newfile" &&
        cat "$file" >> "$newfile"    &&
        CygbuildRun mv "$newfile" "$file"
    fi

    if [[ $binpath != *@($pypath|/usr/bin/env python) ]]; then
        CygbuildWarn "-- [WARN] $name uses wrong python path, fixing it."
        sed -e "s,^#!.*,#!$pypath," "$file" > "$newfile" &&
        CygbuildRun cp "$newfile" "$file"
    fi
}

function CygbuildCmdInstallCheckShellFiles ()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local dir="$instdir$CYGBUILD_PREFIX"

    if [ ! -d "$dir/bin" ] || [ -d "$dir/sbin" ] ; then
        return 0
    fi

    file $dir/bin/* $dir/sbin/* 2> /dev/null > $retval

    [ -s "$retval" ] || return 0

    local file rest

    while read file rest
    do
        file=${file%:}		    # Remove trailing colon from file(1)

        [ -f $file ] || continue

        # FIXME: really, do we need to heck symlinks here?
        if [ -h $file ]; then

            local link=$(
                cd ${file%/*} &&
                ls -l ${file##*/} |
                awk '{printf("-> %s\n", $(NF)) }'
            )

            CygbuildEcho "-- [NOTE] symbolic link:" \
                 ${file/$srcdir\/} $link

            if CygbuildPathResolveSymlink "$file" > $retval ; then
                file=$(< $retval)
            else
                CygbuildWarn "-- [WARN] Couldn't resolve symlink"
            fi
        fi

        if [[ "$rest" == *perl* ]]; then
            CygbuildCmdInstallCheckPerlFile "$file"
        elif [[ "$rest" = *python* ]]; then
            CygbuildCmdInstallCheckPythonFile "$file"
        elif [[ "$rest" = *\ Bourne\ * ]]; then
            CygbuildCmdInstallCheckShFile "$file"
        elif [[ "$rest" = *Bourne-Again* ]]; then
	    #	We need to enable extglob becaus "-nx" won't execute
	    #	any commands in the code.
            CygbuildCmdInstallCheckShFile "$file" "/bin/bash -O extglob"
        fi

    done < $retval
}

function CygbuildCmdInstallCheckShFile ()
{
    local id="$0.$FUNCNAME"
    local file="$1"
    local sh="$2"

    [ -f "$file" ] || return 0

    local shell=${sh:-"/bin/sh"}				# set default

    if [ ! "$sh" ]; then					# find better
	#   Bourne shells to use for checks.
	#   The strictest is the last one

	[ -f /bin/ash ]  &&  shell=/bin/ash		    	# Cygwin
	[ -f /bin/dash ] &&  shell=/bin/dash			# Debian
	[ -f /bin/posh ] &&  shell=/bin/posh			# Posix
    fi

    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local _file=${file#$srcdir/}

    $shell -nx "$file" > $retval
    [ -s "$retval" ] || return 0

    CygbuildEcho "-- Checking $shell -nx: $_file"
    cat "$retval"
}

function CygbuildCmdInstallCheckReadme()
{
    local id="$0.$FUNCNAME"
    local retval=$CYGBUILD_RETVAL.$FUNCNAME
    local dummy=$(pwd)                    # For debug
    local dir=$instdir
    local readme="$PKG*.README"
    local status=0

    find -L $dir -name "$readme"  > $retval

    if [ ! -s $retval ]; then
        CygbuildWarn "-- [WARN] File is missing: $readme"
        let "status=status + 10"
        return $status
    fi

    local path=$(< $retval)
    local name=${path##*/}
    local pkg=$name
    pkg=${pkg%.README}

    if [ "$pkg" != "$PKG-$VER" ]; then
        CygbuildEcho "-- [ERROR] README name mismatch: $pkg != $PKG-$VER"
        let "status=status + 10"
    fi

    local purename=${path##*/}
    local origreadme=$DIR_CYGPATCH/$purename

    #   It is easy to mistakenly forgot to fill in:
    #   Cygwin port maintained by: <Firstname Lastname>  <your email here>

    local tags="(Your +name|Your +email|Firname +Lastname)"
    local notes=""

    $EGREP --line-number --ignore-case --regexp="$tags" \
        $path /dev/null > $retval

    [ -s "$retval" ] && notes=$(< $retval)

    if [[ "$notes" == *[a-zA-Z0-9]* ]]; then
        CygbuildWarn "-- [WARN] Tags found: $tags"
        CygbuildWarn "-- [WARN] edit" ${origreadme#$srcdir/}
        CygbuildWarn "$notes"
        let "status=status + 10"
    fi

    #   It is easy to mistakenly write:
    #   ----- version 4.2.7 -----
    #   When it should read:
    #   ----- version 4.2.7-1 -----

    local tags="[<](PKG|VER|older VER|REL|date)[>]"
    notes=""

    $EGREP --line-number --regexp="$tags" $path /dev/null > $retval

    [ -s "$retval" ] && notes=$(< $retval)

    if [[ "$notes" == *[a-zA-Z0-9]* ]]; then
        CygbuildWarn "-- [WARN] Tags found: $tags"
        CygbuildWarn "-- [WARN] edit $origreadme"
        CygbuildWarn "$notes"
        let "status=status + 10"
    fi

    #   Check that ----- version 4.2.7-1 ----- corresponds
    #   current $VER-$REL
    #
    #   g-b-s uses
    #   ---------- <PKG>-<older VER>-1 -- <date> -----------
    #
    #  Convert special character like
    #  0.3+git20070827-1 =>  0.3[+]git20070827-1

    local rever

    CygbuildStrToRegexpSafe "$VER" > $retval
    [ -s "$retval" ] && rever=$(< $retval)

    local sversion=$rever-${REL:-1}                 # search version

    notes=""

    $EGREP --line-number --ignore-case \
        --regexp="-- +(version +)?($PKG-)?$sversion +--" \
        $path /dev/null > $retval

    [ -s "$retval" ] && notes=$(< $retval)

    if [[ ! "$notes" ]]; then
        local version=$VER-${REL:-1}

        CygbuildWarn \
            "-- [WARN] Missing reference $version -" \
            "Perhaps you didn't run [install] after edit?" \
            "from" ${path#$srcdir/}

        if [ "$verbose" ]; then
	    $EGREP --with-filename "$sversion" ${path#$srcdir/}
	fi

        CygbuildWarn \
            "-- [INFO] Give different -r RELEASE or edit $origreadme"

        let "status=status + 10"
    fi

    return $status
}

#######################################################################
#
#	    SETUP.HINT
#
#######################################################################

function CygbuildCmdInstallCheckSetupHintQuotes()
{
    local path=${1:-/dev/null}

    awk '
	BEGIN {
	    endquote = -1;
	}

#	{ print ">> " endquote " " $0 }

	/^[a-z]+:/ && ! /^(sdesc|ldesc):/ {

	    if (endquote == 0)
	    {
		printf("%s\n-- [ERROR] missing ending quote\n", prev)
	    }

	    endquote = -1
	    next
	}

	/^(sdesc|ldesc):/ {
	    start = 1

	    if (endquote == 0)
	    {
		printf("%s\n-- [ERROR] missing ending quote\n", prev)
	    }

	    prev = $0
	    endquote = 0
	}
	start == 1 && /[\"].*[\"]/ {
	    endquote = 1
	    start = 0
	    next
	}
	start == 1 && /[\"]/ {
	    start = 0
	    next
	}
        start == 1 {
            printf( "%s\n-- [ERROR] missing opening quote\n", $0)
            start = 0
            next
        }
	start == 0 && /[\"]/ {
	    endquote = 1
	}

	{ prev = $0 }
    ' "$path" | CygbuildMsgFilter >&2
}

function CygbuildCmdInstallCheckSetupHintFieldNames()
{
    local id="$0.$FUNCNAME"
    local path="$1"

    if [ ! "$path" ]; then
	CygbuildWarn "$id: Missing argument PATH"
	return 1
    fi

    #   Check required fields

    awk '
        BEGIN {
            hash["sdesc"]    = 0;
            hash["ldesc"]    = 0;
            hash["category"] = 0;
            hash["requires"] = 0;
        }

        /^sdesc:/    { hash["sdesc"] = 1 }
        /^ldesc:/    { hash["ldesc"] = 1 }
        /^category:/ { hash["category"] = 1 }
        /^requires:/ { hash["requires"] = 1 }

        END {
            for (var in hash)
            {
                if ( ! hash[var] )
                {
                    printf("-- [ERROR] missing field %s:\n", var)
                }
            }
        }
    ' "$path" | CygbuildMsgFilter >&2
}

function CygbuildCmdInstallCheckSetupHintSdesc()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local path="$1"

    if [ ! "$path" ]; then
	CygbuildWarn "$id: Missing argument PATH"
	return 1
    fi

    if $EGREP --quiet "^sdesc:.+\.[[:space:]]*\"" $path
    then
        CygbuildWarn "-- [ERROR] sdesc: contains extra period(.)"
    fi

    if $EGREP "^sdesc:[[:space:]]*\"[[:space:]]*[a-z]" $path > $retval
    then
        CygbuildWarn "-- [ERROR] sdesc: Starting sentence not capitalized"
        cat $retval
    fi

    if ! $EGREP --quiet "^sdesc:.*\"" $path
    then
        CygbuildWarn "-- [ERROR] sdesc: No starting double quote"
    fi
}

function CygbuildCmdInstallCheckSetupHintFieldCategory()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local path="$1"

    #  FIXME: Move to data/setup.hint-categies

    #  List of allowed values for Category header
    #  The authorative list is in the Cygwin installer setup.hint
    #  See also http://cygwin.com/setup.html
    #
    #  NOTICE: All must be space separated, no tabs anywhere.

    CYGBUILD_SETUP_HINT_CATEGORY=" Accessibility\
    Admin\
    Archive\
    Audio\
    Base\
    Database\
    Devel\
    Doc\
    Editors\
    Games\
    Gnome\
    Graphics\
    Interpreters\
    KDE\
    Libs\
    Mail\
    Math\
    Mingw\
    Misc\
    Net\
    Perl\
    Publishing\
    Python\
    Security\
    Science\
    Shells\
    System\
    Text\
    Utils\
    Web\
    X11 "

    if [ ! "$path" ]; then
	CygbuildWarn "$id: Missing argument PATH"
	return 1
    fi

    if ! $EGREP --ignore-case "^category:" $path > $retval ; then
	CygbuildWarn "-- [ERROR] setup.hint lacks header Category:"
	return 1
    fi

    local cr=$'\r'

    for item in $(< $retval) # Break on space to read categoies
    do
	#  Skip first word, the "Category:" header
	[[ "$item" == *:* ]] && continue

	item=${item/$cr/}   # remove CR from the last item

	if [[ ! "$CYGBUILD_SETUP_HINT_CATEGORY" == *\ $item\ * ]]; then
	    CygbuildWarn "-- [ERROR] setup.hint::Category is unknon: $item"
	fi
    done
}

function CygbuildCmdInstallCheckSetupHintLdesc()
{
    local path=${1:-/dev/null}
    local re="$PKG"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"

    #   Make case insensitive search for package name in ldesc / first line.
    #   Make sure libraries start with cyg* and not the old lib*

    CygbuildStrToRegexpSafe "$PKG" > $retval
    [ -s "$retval" ] && re=$(< $retval)

    #	Ignore compression utilities, whose name is same as the compression
    #	extension.

    awk '/^ldesc:/ && ! /compress|archive/ {
            line = tolower($0);
            name = tolower(name);

            if ( match(line, name) == 0 )
            {
                next;
            }

            print;
            print "-- [WARN] ldesc: mentions package name at first line" ;
            exit 0;
        }

    ' name="$re" $path | CygbuildMsgFilter >&2

    #  The ldesc: itself is already in double quotes, so there must be
    #  no extra quotes inside. This is fatal error.

    awk '/^ldesc:/,/^category:/ {

            gsub("ldesc: *\"","");

            if ( match($0, /\"./) > 0 )
            {
                print;
                print "-- [ERROR] ldesc: extra quotes: " $0
                exit 1;
            }
        }

    ' "$path" | CygbuildMsgFilter >&2
}

function CygbuildCmdInstallCheckSetupHintDependExists()
{
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local database="/etc/setup/installed.db"
    local path=${1:-/dev/null}

    if [ ! -s "$database" ] ; then
	CygbuildVerb "-- [NOTE] Not exists: $database"
	return 0
    fi

    #  We assume that developer always has every package and library
    #  installed

    awk  '/^requires:/ { sub("requires:", ""); print}' $path > $retval

    local lib

    for lib in $(< $retval)	# Break line on space to get LIBs
    do
	local re=$lib
	re=${re//\+/\\+}		# libstcc++ =>  libstcc\+\+

        if $EGREP --quiet --files-with-matches "\<$re\>" "$database"
        then
            CygbuildEcho "-- OK requires: $lib"
        else
            CygbuildWarn "-- [ERROR] requires: '$lib' package not installed." \
		         "Close matches, if any, below."

	    ${AWK:-awk} '$1 ~ re {
		print "   " $1
	    }' re="$lib"  "$database"
        fi
    done
}

function CygbuildCmdInstallCheckSetupHintCategory()
{
    #  Check category line
    local path=${1:-/dev/null}
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"

    head --lines=1 $instdir/usr/bin/* > "$retval" 2> /dev/null

    local package

    if [ -d $instdir/usr/lib/python*/ ] ||
       $EGREP --quiet '^#!.*python' "$retval"
    then
        package="Python"
    elif [ -d $instdir/usr/lib/perl5/ ] ||
       $EGREP --quiet '^#!.*perl' "$retval"
    then
        package="Perl"
    fi

    if [ "$package" ]; then

        awk '/^category:/ {
                if ( match($0, name) > 0 )
                {
                    exit 0;
                }

                print;
                print "-- [WARN] category: should include " name
                exit 0;
            }

        ' name="$package" "$path" | CygbuildMsgFilter >&2
    fi
}

function CygbuildCmdInstallCheckSetupHintMain()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local dir=$DIR_CYGPATCH
    local file="setup.hint"
    local status=0

    CygbuildEcho "-- setup.hint checks"

    if [ ! -d "$dir" ]; then
        CygbuildWarn "-- [WARN] Cannot check $file. No $dir"
        return 1
    fi

    #   -L = Follow symbolic links
    find -L $dir -name "$file"  > $retval 2> /dev/null

    if [ ! -s $retval ]; then
        CygbuildWarn "-- [ERROR] missing: $file"
        return 1
    fi

    local path=$(< $retval)

    CygbuildCmdInstallCheckSetupHintFieldNames "$path"
    CygbuildCmdInstallCheckSetupHintFieldCategory "$path"
    CygbuildCmdInstallCheckSetupHintSdesc "$path"

    CygbuildCmdInstallCheckSetupHintLdesc "$path"
    status=$?

    CygbuildCmdInstallCheckSetupHintQuotes "$path"
    status=$?

    CygbuildCmdInstallCheckSetupHintDependExists "$path"
    CygbuildCmdInstallCheckSetupHintCategory "$path"

    return $status
}

#######################################################################
#
#	    LIBRARY DEPS: PERL
#
#######################################################################

function CygbuildPerlLibraryDependsCache()
{
    local cache="$CYGBUILD_CACHE_PERL_FILES"

    [ -f "$cache" ] || return 0

    #	Call arguments are library names, like MIME::Base64.
    #	Output's first word is 'Std' or 'CPAN' to identify the module.

    perl -e \
    '
	$cache = shift @ARGV;

	-f $cache or
	    die "Invalid cache file: $cache => @ARGV";

	open my $FILE, "< $cache" or
	    die "Cannot open cache: $cache $!";

	$CACHE = join "", <$FILE>;
	close $FILE;

	#  Remove duplicates

	@hash{@ARGV} = 1;

	for my $module ( sort keys %hash )
	{
	    $lib   = $module;
	    $lib   =~ s,::,/,g;
	    $type  = "CPAN";
	    $path  = "";

	    if ( $CACHE =~ m,^(/usr/lib/perl[\d.]+/.*$lib.*),m )
	    {
		$type = "Std";
		$path = $1;
	    }

	    printf "%-5s %-20s $path\n", $type, $module;
	}
    ' "$cache" "$@"
}

function CygbuildPerlLibraryDependsGuess()
{
    #	Call arguments are library names, like MIME::Base64.
    #	Output's first word is 'Std' or 'CPAN' to identify the module.

    perl -e \
    '
	for my $module ( @ARGV )
	{
	    $lib = $module;
	    $lib =~ s,::,/,g;

	    for (@INC)
	    {
		next unless -d ;

		next if m,/\w+_perl/, ; # exclude site_perl, vendor_perl
		next unless m,/perl\d/,;

		$path = "$_/$lib.pm";
		$type = "Std";
		$type = "CPAN" unless -f $path;
	    }

	    printf "%-5s %-20s $path\n", $type, $module;
	}
    ' "$@"
}

function CygbuildPerlLibraryDependsMain()
{
    local cache="$CYGBUILD_CACHE_PERL_FILES"

    if [ "$cache" ] && [ -s "$cache" ]; then
	:
    else
	# Try to generate cache
	CygbuildBootVariablesGlobalCachePerlGenerate
    fi

    if [ "$cache" ] && [ -s "$cache" ]; then
	CygbuildPerlLibraryDependsCache "$@"
    else
	CygbuildWarn "-- No perl cache, results are pure guesswork..."
	CygbuildPerlLibraryDependsGuess "$@"
    fi
}

function CygbuildPerlLibraryList()
{
    [ "$1" ] || return 0

    #   Ignore $var::Libx
    #	1. grep: Look into non-comment lines only
    #	2. grep: return only matched portion.

    ${EGREP:-grep -E} --only-matching \
	'^[^#]*\<[^#$][a-zA-Z]+::[a-zA-Z]+\>' "$@" |
    ${EGREP:-grep -E} --only-matching \
	'\<[^$][a-zA-Z]+::[a-zA-Z]+\>' |
    sort --unique
}

function CygbuildCmdInstallCheckLibrariesPerl()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local deps="$retval.depends"
    local file="$1"

    [ "$verbose" ] || return 0

    CygbuildPerlLibraryList "$file" > $retval
    [ -s "$retval" ] || return 0

    CygbuildPerlLibraryDependsMain $(< $retval) > $deps

    if [ -s "$deps" ]; then
	CygbuildEcho "-- Possible libary deps in" ${file#$srcdir/}
	sort -r $deps | sed 's/^/   /'    # CPAN last
    fi
}

#######################################################################
#
#	    LIBRARY DEPS: PYTHON
#
#######################################################################

function CygbuildPythonLibraryDependsCache()
{
    local cache="$CYGBUILD_CACHE_PYTHON_FILES"

    if [ "$cache" ] && [ -s "$cache" ]; then
	:
    else
	# Try to generate cache
	CygbuildBootVariablesGlobalCachePythonGenerate
    fi

    [ -f "$cache" ] || return 0

    #	Call arguments are library names, like feedparser, html2text

    perl -e \
    '
	$cache = shift @ARGV;

	-f $cache or
	    die "Invalid cache file: $cache => @ARGV";

	open my $FILE, "< $cache" or
	    die "Cannot open cache: $cache $!";

	$CACHE = join "", <$FILE>;
	close $FILE;

	#   Remove duplicates

	@hash{@ARGV} = 1;

	#   import sys => /usr/include/python2.5/sysmodule.h
	#   /usr/lib/python2.5/lib-dynload/_socket.dll
	#   /usr/lib/python2.5/ctypes/macholib/__init__.py
	#   /usr/lib/python2.5/email/feedparser.py

	for my $module ( sort keys %hash )
	{
	    $lib   = $module;
	    $type  = "Ext";
	    $path  = "";

	    if ( $CACHE =~ m,^(.*/lib/python[\d.]+.*/$lib\b.*),m
		 or $CACHE =~ m,^.*/include/.*${lib}module\.h,m )
	    {
		$type = "Std";
		$path = $1;
	    }

	    printf "%-5s %-20s $path\n", $type, $module;
	}
    ' "$cache" "$@"
}

function CygbuildPythonLibraryDependsMain()
{
    # First attempt: You really can't look into Python installation
    # CygbuildPythonLibraryDependsCache "$@"

    CygbuildPythonCheckImport "$@"
}

function CygbuildPythonLibraryList()
{
    [ "$1" ] || return 0

    #	import sys
    #	from config import *
    #   from email.MIMEText import MIMEText
    #   import cPickle as pickle, md5, time, os, traceback, urllib2, sys, types
    #	import mimify; from StringIO import StringIO as SIO;

    perl -e '
	$debug = shift @ARGV;
	$file  = shift @ARGV;

	open my $FH, "<", $file  or  die "$!";

	binmode $FH;
	$_ = join "", <$FH>;
	close $FH;

	while ( /(from\s+(\S+)\s+import)/gm )
	{
	    $debug  and  warn "A: [$2] => $1\n";
	    $hash{$2} = 1;
	}

	while ( /^((?!\s*#)\s*import\s+(\S+[^\s[:punct:]])([^;\r\n]*))/gm )
	{
	    $hash{$2} = 1;
	    $debug  and  warn "B: [$2] => $1\n";

	    # [Handle cases like]
	    # import cPickle as pickle, md5, time, os, traceback, urllib2

	    $list = $3;
	    $list =~ s/\s+as\s+\S+\s*//g;

	    next unless $list;

	    $list =~ s/\s+//g;
	    $debug  and  warn "L: [$list]\n";

	    @libs = split /,/, $list;

	    $debug  and  warn "L: @libs\n";

	    @hash{@libs} = (1) x @libs;
	}

	%hash  and  print join " ", sort keys %hash;
	exit
    ' "${debug:+1}" "$@"
}

function CygbuildCmdInstallCheckLibrariesPython()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local deps="$retval.depends"
    local file="$1"

    [ "$verbose" ] || return 0

    CygbuildPythonLibraryList "$file" > $retval
    [ -s "$retval" ] || return 0

    CygbuildPythonLibraryDependsMain $(< $retval) > $deps

    if [ -s "$deps" ]; then
	CygbuildEcho "-- possible Python library deps in" ${file#$srcdir/}
	sort -r $deps	    # Extensions last
    fi
}

#######################################################################
#
#	    LIBRARY DEPS: RUBY
#
#######################################################################

function CygbuildRubyLibraryList()
{
    [ "$1" ] || return 0

    perl -e '
	$debug = shift @ARGV;
	$file  = shift @ARGV;

	open my $FH, "<", $file  or  die "$!";

	binmode $FH;
	$_ = join "", <$FH>;
	close $FH;

	while ( /^[^#]*\s*(?:require|include)\s+(\S+)/gm )
	{
	    $hash{$1} = 1;
	}

	%hash  and  print join " ", sort keys %hash;
	exit
    ' "${debug:+1}" "$@"
}

function CygbuildRubyLibraryDependsMain()
{
    local id="$0.$FUNCNAME"
    local cache="$CYGBUILD_CACHE_RYBY_FILES"

    if [ "$cache" ] && [ -s "$cache" ]; then
	:
    else
	# Try to generate cache
	CygbuildBootVariablesGlobalCacheRubyGenerate
    fi

    : # FIXME: TODO
    echo "$id: NOT IMPLEMENTED. Args: $*"
}

function CygbuildCmdInstallCheckLibrariesRuby()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local deps="$retval.depends"
    local file="$1"

    [ "$verbose" ] || return 0

    CygbuildRubyLibraryList "$file" > $retval
    [ -s "$retval" ] || return 0

    CygbuildRubyLibraryDependsMain $(< $retval) > $deps

    if [ -s "$deps" ]; then
	CygbuildEcho "-- possible Ruby library deps in" ${file#$srcdir/}
	sort -r $deps	    # Extensions last
    fi
}

#######################################################################
#
#	    MISCELLANEOUS
#
#######################################################################

function CygbuildCmdInstallCheckFSFaddress()
{
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"

    find -L "$instdir" -type f > $retval.list

    : > $retval

    local file _file cmd

    while read file
    do
	cmd="cat"

	[[ "$file" == *.@(dll|exe|la|[ao#~]) ]] && continue

	[[ "$file" == *.gz   ]] && cmd="gzip  -dc"
	[[ "$file" == *.bz2  ]] && cmd="bzip2 -dc"
	[[ "$file" == *.lzma ]] && cmd="lzma  -dc"

	_file=${file#$srcdir/}

	if $cmd "$file" |
	   $EGREP --line-number '675[[:space:]]+Mass[[:space:]]+Ave' \
	   > $retval.grep
	then
	   echo "$_file:$(< $retval.grep)" >> $retval
	fi

    done < $retval.list

    [ -s $retval ] || return 0

    local url="http://savannah.gnu.org/forum/forum.php?forum_id=3766"
    local new="51 Franklin St, Fifth Floor, Boston, MA, 02111-1301 USA"

    CygbuildEcho "-- [NOTE] Old FSF address (new is <$url>: $new)"
    cat $retval
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
    #   => cat --show-nonprinting seems to be best compromize

    if [ ! -d "$DIR_CYGPATCH" ]; then
        CygbuildEcho "-- Skipped check. No $DIR_CYGPATCH"
    else
        # --files-with-matches = ... The scanning will stop on the first match.

	if  head $DIR_CYGPATCH/* 2> /dev/null	|
	    cat --show-nonprinting		|
	    $EGREP --files-with-matches "\^M"	\
            > /dev/null 2>&1
        then
            CygbuildEcho "-- [INFO] Converting to Unix line endings in dir" \
			 ${DIR_CYGPATCH#$srcdir/}
            CygbuildFileConvertToUnix $DIR_CYGPATCH/*
        fi
    fi
}

function CygbuildCmdInstallCheckManualPages()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local addsect=$CYGBUILD_MAN_SECTION_ADDITIONAL
    local dir="$instdir"

    #   Every binary files should have corresponding manual page

    CygbuildFilesExecutable "$dir" > $retval

    local files=$(< $retval)

    if [ ! "$files" ]; then
        #   No executables, this may be a library package
        CygbuildEcho "-- [INFO] Manual page check: no executables found in" \
             ${dir/$srcdir\/}
        return 0
    fi

    find -L $dir                    \
        -type f                     \
        '('                         \
            -path    "*/man/*"      \
            -o -path "*/man[0-9]/*" \
        ')'                         \
        > $retval

    local file path manlist manPathList
    local status=0
    local itest

    rm --force $retval.debian

    while read file
    do
        $EGREP -n 'Debian' $file /dev/null >> $retval.debian

	itest=0

	if [[ "$file" == *.gz  ]]; then
	    gzip --test --verbose "$file"  > $retval.test 2>&1
	    itest=$?
	elif [[ "$file" == *.bz2 ]]; then
	    bzip2 --test --verbose "$file"  > $retval.test 2>&1
	    itest=$?
	fi

	if [ ! "$itest" = "0" ]; then
	    CygbuildWarn "-- [ERROR] integrity check failed:" ${file#$srcdir/}
	    cat $retval.test
	fi

        path=${file%/*}
        manPathList="$manPathList $path"

        name=${file##*/}        # Delete path
        name=${name%.gz}        # package.1.gz => package.1
        name=${name%.bz2}       # package.1.gz => package.1
        name=${name%$addsect}   # package.1x   => package.1
        name=${name%.[0-9]}     # package.1    => package
        manlist="$manlist $name "
    done < $retval

    if [ -s $retval.debian ]; then
        CygbuildEcho "-- [INFO] If manpage is from Debian, it may need editing"
        cat $retval.debian
    fi

    #  Check incorrect locations
    #       .inst/usr/share/man1/
    #       .inst/usr/man1

    local try="$CYGBUILD_PREFIX/$CYGBUILD_MANDIR_RELATIVE"

    for path in $manPathList
    do
        if [[ $path != *$try* ]]; then
            CygbuildWarn "-- [ERROR] incorrect manual path; want $try:" \
                         ${path/$srcdir\/}
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
            CygbuildWarn "-- [WARN] Suspicious file $file"
        fi

        #   The LIST is a string containing binary names and they are
        #   all surrounded by spaces: " prg1 prg2 "

        if [[ "$manlist" == *\ $nameplain1\ * ]]; then

            :    # program.1

        elif [[ "$manlist" == *\ $nameplain2\ * ]]; then

            :

        elif [[ "$manlist" == *\ $name\* ]]; then

            :    # program.sh.1

        else
            CygbuildWarn "-- [WARN] No manual page for $file"
        fi

    done

    return $status
}

function CygbuildCmdInstallCheckPkgDocdir()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local pfx="$CYGBUILD_PREFIX"
    local dir="$instdir"
    local cygdoc="$DIR_DOC_GENERAL"

    find -L $dir                         \
        -type f                          \
        '(' -path   "*/$pfx/doc/*"   ')' \
        > $retval

    [ -s "$retval" ] || return 0

    local status=0
    local item

    while read item
    do
        status=1
        CygbuildWarn "-- [ERROR] Wrong location $item"
    done < $retval

    for item in contrib
    do
        [ -d "$item" ]          || continue
        [ -d "$cygdoc/$item" ]  && continue

        CygbuildEcho "-- [NOTE] $item/ possibly missing from $cygdoc"
    done

    return $status
}

function CygbuildCmdInstallCheckDocdir()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local dir="$DIR_DOC_GENERAL"

    if [ ! -d "$dir" ]; then
        CygbuildWarn "-- [WARN] Hm, not found ${dir#$srcdir/}"
	return 0
    fi

    find -L "$dir"			\
        -type f                         \
        '(' -path   "*$PKG*"   ')'      \
        > $retval

    if [ ! -s "$retval" ] ; then
        CygbuildWarn "-- [WARN] Empty directory" ${dir/$srcdir\//}
        return 1
    fi

    local ignore="*@(AUTHORS)"
    local status=0
    local minsize=100
    local file

    while read file
    do
        [[ "$file" == $ignore ]] && continue
	[ -h "$file"	       ] && continue   # Ignore symlinks

        local size=0
        local _file=${file/$srcdir\//}

        CygbuildFileSize "$file" > $retval.size
        [ -s "$retval.size" ] && size=$(< $retval.size)

        if [ $size = 0 ] ; then
            CygbuildWarn "-- [WARN] empty file $_file"

        elif [[ ! "$file" == *.@(gif|jpg|png|xpm) ]] &&
	     (( $size < $minsize ))
	then
            CygbuildWarn "-- [WARN] Very small file ($size bytes) $_file"
        fi
    done < $retval

    return $status
}

CygbuildCygcheckLibraryDepSourceMake()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"

    CygbuildFindDo "."		    \
	-o -type f -iname "*make*"  \
	-o -name "*.mk"		    \
	-o -name "*.mak"	    \
	> $retval		    \
	2> /dev/null

    [ -s $retval ] || return 0

    : > $retval.grep

    while read file
    do
	$EGREP --with-filename --line-number --ignore-case \
	    '^[^#]*(xmlto|asciidoc)\>'	    \
	    "$file"			    \
	    > $retval.grep
    done < $retval

    [ -s $retval.grep ] || return 0

    # FIXME: Can we detect if this is mentioned in README?
    # FIXME: Might be difficult to parse result grep: $(XMLTO) etc.

    # CygbuildDetermineReadmeFile > $retval.me
    # local readme=$(< $retval.me)

    CygbuildWarn "-- [WARN] Possible build dependency"
    cat $retval.grep
}

CygbuildCygcheckLibraryDepSourceCpp()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"

    #  Programs may have direct shell calls like
    #
    #  execvp("/bin/diff")

    CygbuildFindDo "."		\
	-name "*.c"		\
	-o -name "*.cc"		\
	-o -name "*.cpp"	\
	> $retval		\
	2> /dev/null

    [ -s $retval ] || return 0

    local re="^[^#]*(\<exec\>|SMTPSERVER|SMTP_SERVER|<\sendmail\>)"
    re="$re|\<system\>.*[(]"
    local file

    : > $retval.grep

    while read file
    do
	$EGREP --line-number --with-filename		\
	    "^[^/]*exec[a-z]* *\(|include .*getopt\>"   \
	    "$file"					\
	    >> $retval.grep

	$EGREP --with-filename --line-number		\
	    "$re"					\
	    >> $retval.grep

    done < $retval

    [ -s $retval.grep ] || return 0

    CygbuildWarn "-- [WARN] Possible external system calls"
    cat $retval.grep
}

CygbuildCygcheckLibraryDepSourcePython()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"

    find "${instdir#$srcdir/}"	    \
	-type f			    \
	'('			    \
	    ! -path "*/doc/*"	    \
	    -a ! -path "*/man/*"    \
	')'			    \
	> $retval		    \
	2> /dev/null

    [ -s $retval ] || return 0

    : > $retval.grep

    while read file
    do
	$EGREP --with-filename --line-number	\
	    '^[^#]*\<os[a-z]*\.rename'		\
	    "$file"				\
	    > $retval.grep
    done < $retval

    [ -s $retval.grep ] || return 0

    CygbuildWarn "-- [WARN] Python::os.rename is" \
	"likely to fail on Cygwin"

    cat $retval.grep
}

CygbuildCygcheckLibraryDepSourceMain()
{
    CygbuildCygcheckLibraryDepSourceCpp
    CygbuildCygcheckLibraryDepSourceMake
    CygbuildCygcheckLibraryDepSourcePython
}

#######################################################################
#
#	    OTHER
#
#######################################################################

function CygbuildCmdInstallCheckBinFiles()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local dir="$instdir"
    local status=0
    local maxsize=1000000       # 1 Meg *.exe is big

    #   If we find binary files, but they are not in $instdir, then
    #   Makefile has serious errors
    #   FIXME: why is here a subshell wrapper?

    ( CygbuildFilesExecutable "$dir" ) > $retval
    local files=$(< $retval)

    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    CygbuildDependsList > $retval
    local depends=$(< $retval)

    if [ ! "$files" ]; then
        #   No executables, this may be a library package
        CygbuildEcho "-- [INFO] Binaries check: no executables found in $dir"
    fi

    #  All exe files must have +x permission

    find -L "$dir"          \
    '(' -name "*.sh"        \
        -o -name "*.exe"    \
        -o -name "*.dll"    \
        -o -name "*.sh"     \
        -o -name "*.pl"     \
        -o -name "*.py"     \
        -o -name "*.rb"     \
    ')'                     \
    -a ! -path "*python*site-pacages*" \
    -a ! -perm +111 -ls     \
    > $retval

    if [ -s "$retval" ]; then
        CygbuildWarn "-- [WARN] Some executables may have" \
                     "missing permission +x"
        cat "$retval"
        # status=1
    fi

    local installed

    if ls "/$CYGBUILD_DOCDIRCYG_FULL/$PKG*.README" > /dev/null 2>&1
    then
        #   This package has already been installed into the system,
        #   otherwise this is a new package port
        installed="installed"
    fi

    local docdir="$CYGBUILD_DOCDIRCYG_FULL"

    #   FIXME: Currently every file in /bin is supposed to be executable
    #   This may not be always true?

    find -L "$dir" -type f	    \
	'('			    \
	   -path "*/bin/*"	    \
	   -o -path "*/sbin/*"	    \
	   -o -path "*/lib/*"	    \
           -o -path "*/share/$PKG*" \
	   -o -path "*/usr/games/*" \
	')'			    \
        -a ! -name "*.dll"          \
	-a ! -name "*.pyc"          \
	-a ! -name "_*.py"          \
	-a ! -path "*test*"         \
	-a ! -path "*benchmark*"    \
	-a ! -path "*version*"      \
	-a ! -path "*.egg*"         \
	-a ! -path "*site-packages*" \
        > $retval.find

    [ -s "$retval.find" ] || return 0

    local file

    while read file
    do
        [ -d "$file" ] && continue

        if [ -h "$file" ]; then
            CygbuildPathResolveSymlink "$file" > $retval &&
            file=$(< $retval)
        fi

        local name=${file##*/}              # remove path
        local _file=${file/$srcdir\/}       # relative path

        #   Make sure none of the files clash with existing binaries

        if [ ! "$installed" ]; then

	    local str
            CygbuildWhich "$name" > $retval
            [ -s "$retval" ] && str=$(< $retval)

            if [ "$str" ]; then
                CygbuildEcho "-- [NOTE] Binary name clash [$name]?" \
                             "Already exists ${str/$srcdir\//}"
                # status=1
            fi
        fi

        #   If files are compiled as static, the binary size is too big
        #   But X files may be huge

        if [[ "$file" != *X11* ]]; then

	    CygbuildFileSizeRead "$file" > $retval

            local size
	    [ -s "$retval" ] && size=$(< "$retval")

	    if [[ ! "$size" == [0-9]* ]]; then
		CygbuildWarn "-- [WARNING] Internal error, can't read" \
		    " size: '$file'"
	    else
		if [[ $size -gt $maxsize ]]; then
		    CygbuildEcho "-- [NOTE] Big file, need " \
			 "dynamic linking? $size $file"
		fi
            fi
        fi

	if [[ "$file" == *.@(py|pl|rb) ]]; then
	    CygbuildWarn "-- [WARN] Should not have extension in $_file"
	fi

	local str
        file "$file" > $retval
        [ -s "$retval" ] && str=$(< $retval)

        local name=${file##*.inst}
	local plbin="$PERLBIN"
	local pybin="$PYTHONBIN"
	local rbbin="$RUBYBIN"

        #   Sometimes package includes compiled binaries for Linux.
        #   Warn about those. The file(1) will report:
        #
        #   ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), for
        #   GNU/Linux 2.0.0, dynamically linked (uses shared libs),
        #   stripped
	#


        if [[ "$str" == *Linux* ]]; then
            CygbuildEcho "-- [ERROR] file(1) reports Linux executable: $name"
            status=1

        elif [[ "$str" == *executable*Windows\ \(console\)* ]] &&
	     [[ ! $file == *.exe ]]
	then
	    # All binaries must have ".exe" suffix
	    # PE32 executable for MS Windows (console) Intel 80386 32-bit

            CygbuildEcho "-- [ERROR] No *.exe suffix in $_file"
            status=1

        elif [[ "$str" == *executable*Windows\ \(DLL\)* ]] &&
	     [[ $file != *.dll || $file != *.so ]]
	then
	    # *.so:  PE32 executable for MS Windows (DLL) (console) Intel 80386 32-bit

            CygbuildEcho "-- [ERROR] No *.so or *.dll suffix in $_file"
            status=1

        elif [[ "$str" == *Bourne-Again* ]] && [[ ! $depends == *bash* ]]
	then
            CygbuildEcho "-- [ERROR] setup.hint may need Bash dependency" \
                 "for $name"
            status=1

        elif [[ "$str" == *awk* ]] &&
	     awk 'NR == 1 && /gawk/ {exit 0}{exit 1}' "$file" &&
	     [[ ! $depends == *gawk* ]]
	then
            CygbuildEcho "-- [ERROR] setup.hint may need Gawk dependency" \
                 "for $name"
            status=1

        elif [[ "$str" == *perl*   ]] && [[ ! $depends == *perl* ]] ; then
            CygbuildEcho "-- [ERROR] setup.hint may need Perl dependency" \
                 "for $name"
            status=1

        elif [[ "$str" == *python* ]] && [[ ! $depends == *python* ]]  ; then
            CygbuildEcho "-- [ERROR] setup.hint may need Python dependency" \
                 "for $name"
            status=1

        elif [[ "$str" == *ruby* ]] && [[ ! $depends == *ruby* ]]  ; then
            CygbuildEcho "-- [ERROR] setup.hint may need Ruby dependency" \
                 "for $name"
            status=1
	fi

        if [[ "$str" == *perl*   ]]; then
            head --lines=1 "$file" > $retval.1st

            if ! $EGREP --quiet "$plbin([ \t]|$)" "$retval.1st"
            then
                CygbuildWarn "-- [WARN] possibly wrong Perl call" \
                     "in $_file:" $(cat "$retval.1st")
            fi

	    CygbuildCmdInstallCheckLibrariesPerl "$file"

        elif [[ "$str" == *python* ]]; then

            head --lines=1 "$file" > $retval.1st

            if ! $EGREP --quiet "$pybin([ \t]|$)" "$retval.1st"
            then
                CygbuildWarn "-- [WARN] possibly wrong Python call" \
                     "in $_file:" $(cat "$retval.1st")
            fi

	    CygbuildCmdInstallCheckLibrariesPython "$file"

        elif [[ "$str" == *ruby* ]]; then

            head --lines=1 "$file" > $retval.1st

            if ! $EGREP --quiet "$rbbin([ \t]|$)" "$retval.1st"
            then
                CygbuildWarn "-- [WARN] possibly wrong Ruby call" \
                     "in $_file:" $(< "$retval.1st")
            fi

	    CygbuildCmdInstallCheckLibrariesRuby "$file"
	fi

        # .................................................... other ...

        if [ "$verbose"  ]; then
            str=${str##*:}          # Remove path
            CygbuildEcho "-- $name: $str"

            #   Show library dependencies
            [[ $file == *.exe ]] && CygbuildCygcheckMain "$file"
        fi

    done  < "$retval.find"

    return $status
}

function CygbuildCmdInstallCheckSymlinks()
{
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local dir="$instdir"

    find $dir -ls | $EGREP --regexp='-> +/' > $retval || return 0

    local status=0
    local path link i j
    local -a arr

    #  find -ls listing looks like:
    #  xx 0 lrwxrwxrwx 1 root None 65 Sep  8 00:16 a -> b

    while read line
    do
        set -- $line
        arr=($line)
        i=$(( $# - 3 ))
        j=$(( $# - 1 ))

        path=${arr[$i]}
        link=${arr[$j]}

        if [[ "$link" == /* ]]; then
            CygbuildWarn "-- [WARN] Absolute symlink $path -> $link"
        fi
    done < $retval
}

function CygbuildCmdInstallCheckLibFiles()
{
    local id="$0.$FUNCNAME"
    local dir="$instdir"
    local status=0

    #   If we find binary files, but they are not in $instdir, then
    #   Makefile has serious errors

    local retval="$CYGBUILD_RETVAL.$FUNCNAME"

    find -L $dir -type f            \
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
        CygbuildEcho "-- [INFO] Found lib $file"

        [ "$verbose" ] && CygbuildCygcheckMain $file

        if [[ $file == *dll  &&  $file == *usr/lib/*/* ]]; then

            #  This is ok case: /usr/lib/foo/input/file.dll
            # CygbuildEcho "-- [NOTE] Hm, dynamically loaded lib?"
            :

        elif [[ $file == *.a  &&  ! $file == *usr/lib/* ]]; then

            CygbuildEcho "-- [ERROR] Misplaced, should be in /usr/lib"
            status=2

        elif [[ $file == *dll  &&  ! $file == *usr/bin/* ]]; then

            CygbuildEcho "-- [ERROR] Misplaced, should be in /usr/bin"
            status=2
        fi

    done

    find -L $dir -type f '(' -name "*.info" -o -name "*.info-[0-9]" ')' \
        > $retval
    local info=$(< $retval)

    find -L $dir -type f -path "*/man/*"  > $retval
    local man=$(< $retval)

    if [[ ! "$info"  &&  ! "$man" ]]; then
        CygbuildWarn \
            "-- [NOTE] Libraries found, but no *.info or /man/ files"
        # status=1
    fi

    if [[ "$files" != *.dll* ]]; then
        CygbuildWarn "-- [WARN] Libraries found, but no *.dll files"
    fi

    return $status
}

function CygbuildCmdInstallCheckDirStructure()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local pfx="$instdir$CYGBUILD_PREFIX"

    local tmp error try

    for try in $instdir/bin $pfx/bin $pfx/games $pfx/sbin $pfx/lib
    do
        if [ -d "$try" ]; then
            error=1
            break
        fi
    done

    for try in usr/share usr/lib
    do
	tmp="$instdir/$try"

	[ -d "$tmp" ] || continue

	if ls -F $tmp | $EGREP --quiet --invert-match '/' ; then
            error=1
	    CygbuildWarn "-- [ERROR] Files found in toplevel dir" \
			 ${tmp/$srcdir\/}
	    ls -F $tmp
	fi
    done

    if [ -d $pfx/X11R6 ]; then
        CygbuildWarn "-- [ERROR] deprecated $pfx/X11R6"
    fi

    local dir="$pfx/lib/X11/app-defaults"

    if [ -d "$dir" ]; then
        CygbuildWarn "-- [ERROR] No etc/X11/app-defaults, move $dir"
    fi

    if [ -d $instdir/doc ]; then
        CygbuildWarn "-- [ERROR] Incorrect /doc should be /usr/doc"
    fi

    if [ -d $instdir/bin ]; then
        #  For shells this is valied, but for anything else...
        CygbuildWarn "-- [WARN] /bin found. Should it be /usr/bin?"
    fi

    if [ -d $instdir/etc ]; then

        find "$instdir/etc" \
            ! -path "*/postinstall*" \
            -a ! -path "*/preremove*" \
            -a ! -path "*/app-defaults*" \
            -a ! -path "*/default*" \
            -type f \
            > $retval

        local file _file

        while read file
        do
            if [ -f $file ]; then

                _file=${file/$srcdir\//}

                CygbuildWarn "-- [ERROR] Instead of $_file," \
                             "use /etc/defaults/etc and postinstall"
                error=1
                break
            fi
        done < $retval
    fi

    if [ -d $instdir/user-share ]; then

        local item

        for item in $instdir/user-share/*
        do
            if [ -f "$item" ]; then
                CygbuildWarn "-- [ERROR] Use subdir for file $item"
                error=1
            elif [ -h $item ]; then
                CygbuildWarn "-- [NOTE] Symlink found: $item"
            fi
        done
    fi


    if [ ! "$error" ]; then
        CygbuildWarn "-- [ERROR] incorrect directory structure," \
             "$instdir contain no bin/ usr/bin usr/games usr/sbin or usr/lib"
        return 1
    fi
}

function CygbuildCmdInstallCheckDirEmpty()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local dir

    find "$instdir" -type d > $retval
    [ -s "$retval" ] || return 0

    while read dir
    do
        [ "$dir" = "$instdir" ] && continue

        if ! ls -A "$dir" | $EGREP --quiet '[a-zA-Z0-9]' ; then
            CygbuildWarn "-- [WARN] empty directory" ${dir/$srcdir\//}
        fi

    done < $retval
}

function CygbuildCmdInstallCheckEtc()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local dir="$instdir"
    local file
    local status=0

    for file in $dir/etc/*
    do
        [[ $file == $CYGBUILD_IGNORE_ETC_FILES ]] && continue
        [ ! -f "$file" ]                          && continue

        CygbuildWarn "-- [WARN] May conflict with user's settings: $file"
        status=1
    done

    return $status;
}

function CygbuildCmdInstallCheckSymlinkExe()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"

    # 2007-04-18
    # From: Eric Blake <ebb9-PGZyUNKar/Q@public.gmane.org>
    # Subject: All maintainers: repackage symlinks to executables
    # See http://permalink.gmane.org/gmane.os.cygwin.applications/14466

    find $instdir -type l -name '*.exe' > $retval

    if [ -s $retval ]; then
        CygbuildEcho "-- [ERROR] Symlinks must not end to .exe."
            "Recompile with coreutils 6.9 installed."
        return 1
    fi
}

function CygbuildCmdInstallCheckCygpatchDirectory()
{
    local id="$0.$FUNCNAME"
    local retval="$CYGBUILD_RETVAL.$FUNCNAME"
    local dir="$CYGBUILD_DIR_CYGPATCH_RELATIVE"

    [ -d "$dir" ] || return 0

    CygbuildFindDo $dir	-o -type f > $retval.list

    [ -s $retval.list ] || return 0

    local file

    while read file
    do
        [[ "$file" == *@(patch|diff|orig) ]] && continue
        [ -f $file ] || continue

        if $EGREP --line-number '[[:space:]]$' $file > $retval
        then
            CygbuildEcho "-- [NOTE] Trailing whitespaces found in $file"
            cat --show-nonprinting --show-tabs --show-ends $retval |
            sed 's/^/     /'
        fi

        if $EGREP --line-number --ignore-case \
           'copyright.*YYYY|your +name|[<]firstname' $file > $retval
        then
            CygbuildWarn "-- [WARN] Possible unfilled template line in $file"
            sed 's/^/     /' $retval
        fi
    done < $retval.list
}

#######################################################################
#
#	    MAIN
#
#######################################################################

function CygbuildCmdInstallCheckEverything ()
{
    local stat=0

    if [ "$verbose" ] ; then
	CygbuildCmdInstallCheckFSFaddress
    fi

    CygbuildCmdInstallCheckLineEndings

    if [ "$verbose" ] ; then
	CygbuildCmdInstallCheckMakefiles
    fi

    CygbuildCmdInstallCheckTempFiles         || stat=$?

    CygbuildCmdInstallCheckInfoFiles         || stat=$?

    if [ "$verbose" ] ; then
	CygbuildCmdInstallCheckTexiFiles     || stat=$?
    fi

    CygbuildCmdInstallCheckShellFiles        || stat=$?
    CygbuildCmdInstallCheckReadme            || stat=$?
    CygbuildCmdInstallCheckSetupHintMain     || stat=$?
    CygbuildCmdInstallCheckManualPages       || stat=$?
    CygbuildCmdInstallCheckPkgDocdir         || stat=$?
    CygbuildCmdInstallCheckDocdir            || stat=$?

    if [ "$verbose" ] ; then
	CygbuildCygcheckLibraryDepSourceMain || stat=$?
    fi

    CygbuildCmdInstallCheckBinFiles          || stat=$?
    CygbuildCmdInstallCheckSymlinks          || stat=$?
    CygbuildCmdInstallCheckLibFiles          || stat=$?
    CygbuildCmdInstallCheckDirStructure      || stat=$?
    CygbuildCmdInstallCheckDirEmpty          || stat=$?
    CygbuildCmdInstallCheckEtc               || stat=$?
    CygbuildCmdInstallCheckSymlinkExe        || stat=$?
    CygbuildCmdInstallCheckCygpatchDirectory || stat=$?

    CygbuildEcho "-- Check finished. Please verify possible messages."

    return $stat
}

# End of file
