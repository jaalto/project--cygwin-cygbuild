        #T2HTML-TITLE Cygbuild README
        #T2HTML-OPTION --as-is
        #T2HTML-OPTION --css-code-bg
        #T2HTML-OPTION --css-code-note
        #T2HTML-OPTION Note:

Project Description

    Description

        Cygbuild is like Debian dh_make(1) .deb or rpm(1) .rpm maker
        utility, but for Cygwin platform. If you are familiar with
        .deb or .rpm or Activestate Perl .ppm and .ppd files, the
        Cygwin Net release packaging <http://www.cygwin.com> is just
        another variant of these similar packaging methods. The
        process is quite straight forward: one must mirror whole
        system directory structure where the files would go (a la
        Slackware), fill in the files and wrap all in a
        package-NN.NN-RELEASE.tar.bz2 archive. The end user unpacks
        this premade tar package at system root /. This is the
        methodology of making Cygwin Net releases.

        Normally the porting process starts by downloading some
        interesting package that would be nice to have in Cygwin as
        well. So the porter must

        o   Unpack original package (tar -zxf tar.gz)
        o   Configure it (./configure)
        o   Build it (make all) .. usually there are some Cygwin work to doa
        o   Verify that installation uses install(1). If not, the porter
            must make corrections and adjustments.

        All of these steps can be automated in a certain degree for
        those that use standard conventions:

        o   GNU packaging, which use automake, autoconf and ./configure
        o   Debian *.orig.tar.gz packages
        o   Perl packages that include standard Makefile.PL
        o   Python packages that include standard setup.py

        If the automatic packaging cannot be used (./configure && make
        all && make install), there are custom install files that the
        porter can tweak. The manual explains this in detail. See doc/
        directory for details.

    What are the benefits of using Cygbuild?

        Years back the portes used simple (some ~300 lines) bourne
        shell example script at (see <http://cygwin.com/setup.html>)
        which outlined the rudimentary helper tasks. During developing
        Cygbuild, the command names from the original porting tool has
        been preserved (conf, prep, make, strip pkg, spkg ...). The
        advantages are:

        o   You do not have to write separate installation scripts to every
            package. The same script can be used over and over; every time
            you port a new version of some package.
        o   The detection of packaging type (Perl, Library, stripping of
            *.exe *.dll etc.) is all automatic.
        o   It is possible to use optional user written external scripts
            which provide modularised way of handling difficult ports.
            This is similar to how Debian packages work.
        o   A 'check' command is provided to help developer notify things
            missing that should have been taken cared of.
        o   A 'readmefix' is provided to help maintaining the  Cygwin
            specific <package>.README.
        o   Perl packages are recognized and treated accordingly.
        o   It is possibly to build snapshot packges
            straight from version control sources.
        o   Extendable. Written in bash and uses Perl module cygbuild.pl for
            tasks that are too hard or slow for bash.

        Cygbuild resembles in many respects how Debian packaging is
        handled with separate control files and patching
        possibilities. There is also alternative utility, cygport.
        that resembles more like how Gentoo manages the ports. See
        Yaakov Selkowitz's <http://cygwinports.sunsite.dk/> for more
        information.

Dependencies

        The aplication consists of set of programs that use intepreted
        languages. The dependencies are:

	o   Bash                            3.x
        o   Perl                            5.004+
        o   GNU compiler collection         any version
	o   GNU binutils
        o   GNU awk, make, grep, tar...     any version
        o   GNU diffutils                   any version
        o   patchutils                      any version
        o   Wget                            any version
        o   Python                          any version
        o   Standard programs: ls, etc.     any version

        This program runs solely with Free Software. It does not rely
        on any component of non-Free Software.

        It is possible to setup a Cygwin cross compiling environment
        in Free OS. See document "Cygwin/X Contributor's Guide" at
        <http://x.cygwin.com/docs/cg/prog-build-cross.html>

Information for developers

	FIXME: This information is not complete

    Policy for documenting changes

        All changes are documented using Emacs editor and standard
        package *add-log.el*, which provides command `C-x' `4' `a' to
        record a change at point. Emacs will pick up the main
        `ChangeLog' file and open an entry there. An example:

            * Makefile: (TOP LEVEL): Added new variable $USER

        All version control commit message have following convention,
	where the first line is short and informative description. It
	starts with a filename chaged followed by colon. Longer
	description, separated by empty line, may follow (but not
	required). And example:

	    <filename>: <one line change description>

	    <longer description, if needed. a copy from
	    Changelog can be pasted when making a commit>

    Makefiles

	To see all make targets, run command:

	    make help-dev

        The make files are in separate directory `etc/makefile' from
        where they are included to main `Makefile'. File are:

            Makefile        The main controller.
            id.mk           Maintainer information (variables)
            vars.mk         General variables
            unix.mk         Common targets (clean, install etc.)
            cygwin.mk       Cygwin specific targets (making Net releases)
            net*.mk         Network connection targets

    To convert into installable Cygwin binary package

        First, make world release. It is a preliminary preparation step:

            make release-world

        After that Cygwin binary and source packages can be made. The
        first command will make the Cygwin binary package and the
        `list-cygwin' will show the content of the made package. The
        Cygwin source package (not really needed) can be made with
        'make release-cygwin-source'.

            make RELEASE=1 release-cygwin-bin
            make list-cygwin

        There is also command 'make publish-cygwin'. See RELEASEDIR
        variable in etc/makefile/* for more information.

    Source packages

        See make target `release-cygwin-source'.

    Exporting archive

        There is a make target `release-world' that makes a tar.gz
        file from checkout. Should that ever be needed. This target
        can be used to make a backup of the project without version
        control insformation and temporary files.

    Converting text files into HTML

        In order to convert text files (README) into HTML, free
        program *t2html.pl* is needed. See
        http://perl-text2html.sourceforge.net/

	    make doc doc-readme

End of file
