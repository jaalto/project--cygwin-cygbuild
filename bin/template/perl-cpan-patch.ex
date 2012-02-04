# Changes needed for Perl files that need external CPAN libraries
#
# 1. Remove "use" calls from original program
# 2. Add BEGIN block like below

-use Mail::Box::Manager;
-use Mail::Message;
-use Date::Format;
-use Date::Parse;
 use Getopt::Long qw(:config no_ignore_case bundling);

BEGIN
{
    my @need = qw
    (
        Mail::Box::Manager
 	Mail::Message
        Date::Format
        Date::Parse
    );

    for ( @need )
    {
        eval "use $_;" ;
        push @list, $_   if $@;  # Eval error
    }

    if ( @list )
    {
        die q([FATAL] Perl CPAN modules are needed. Please install them with:

              cpan ) . qq(@list\n);
    }
}

# End of file
