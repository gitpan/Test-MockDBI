package Test::MockDBI;
# Test DBI interfaces using Test::MockObject.


# ------ use/require pragmas
use 5.008;                              # minimum Perl is V5.8.0
use strict;                             # better compile-time checking
use warnings;                           # better run-time checking
use Data::Dumper;                       # dump data in a pleasing format
use Test::MockObject::Extends;          # mock objects for extending classes
require Exporter;                       # we are an Exporter
use Data::Dumper;


# ------ exportable constant
use constant MOCKDBI_WILDCARD => 0;     # DBI type wildcard ("--dbitest=TYPE")


# ------ global variables
our %EXPORT_TAGS                        # named lists of symbols to export
 = ( 'all' => [ qw( MOCKDBI_WILDCARD ) ] );
our @EXPORT_OK                          # symbols to export upon request
 = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();                     # symbols to always export
our @ISA = qw(Exporter);                # we ISA Exporter :)
our $VERSION = '0.50';                  # our version number


# ------ file-global variables
my %array_retval  = ();                 # return array values for matching SQL
my @bad_params    = ();                 # list of bad parameter values
my @cur_array     = ();                 # current array to return
my $cur_scalar    = undef;              # current scalar to return
my $cur_sql       = "";                 # current SQL
my %fail          = ();                 # hash for methods to fail, why and how
my $fail_param    = 0;                  # TRUE when failing due to bad param
my $instance      = undef;              # my only instance
my $mock          = "";                 # mock DBI object from Test::MockObject::Extends
my $object        = "";                 # our fake DBI object
my %scalar_retval = ();                 # return scalar values for matching SQL
my $type          = 0;                  # DBI testing type from command line


# ------ convert argument to defined value, use "" if undef argument
sub Define {
    my $arg = shift;                    # argument to convert

    if (defined($arg)) {
        return ($arg);
    }
    return "";
}


# ------ return TRUE if SQL matches pattern, handle undef values
sub sql_match {
    my $sql     = Define(shift);        # SQL
    my $pattern = Define(shift);        # SQL regex string to match

    if (!$sql && !$pattern) {
        return 1;
    }
    if (!$pattern) {
        return 0;
    }
        if ($sql =~ m/$pattern/ms) {
                return 1;
        }
        return 0;
}


# ------ check if this DBI method should fail
sub fail {
    my $method  = shift;                # method name
    my $spec    = "";                   # method failure specification

    # ------ fail returned data due to bad parameter
    if ($fail_param &&
     ($method =~ m/^fetch/ || $method =~ m/^select/)) {
        $fail_param = 0;
        return 1;
    }

    # ------ no failure modes for this DBI method
    $spec = $fail{$method};
    if (!defined($spec)) {
        return 0;
    }

    # ------ no failure modes for this MockDBI type
    if (!defined($spec->{$type})) {
        return 0;
    }

    # ------ return TRUE if SQL matches
    return sql_match($cur_sql, $spec->{$type}->{"SQL"});
}


# ------ force an array return value
sub force_retval_array {
    local $_;                           # localized topic

    foreach (@{ $array_retval{MOCKDBI_WILDCARD()} }, @{ $array_retval{$type} }) {
        if (sql_match($cur_sql, $_->{"SQL"})) {
            if (ref($_->{"retval"}) eq "ARRAY"
             && ref($_->{"retval"}->[0]) eq "CODE") {
                return &{ $_->{"retval"}->[0] }();
            }
            return @{ $_->{"retval"} };
        }
    }
    if (scalar(@_) < 1) {
        return undef;
    }
    if (scalar(@_) == 1 && !defined($_[0])) {
        return undef;
    }
    return @_;
}


# ------ force a scalar return value
sub force_retval_scalar {
    local $_;                           # localized topic

    foreach (@{ $scalar_retval{MOCKDBI_WILDCARD()} }, @{ $scalar_retval{$type} }) {
        if (sql_match($cur_sql, $_->{"SQL"})) {
            if (ref($_->{"retval"}) eq "CODE") {
                return &{ $_->{"retval"} }();
            }
            return $_->{"retval"};
        }
    }
    return $_[0];
}


# ------ fake the specified DBI method call
sub fake {
    my $method = shift;                 # file-global method name
    my $arg    = shift;                 # first method arg
    my $retval = shift;                 # scalar or $_[0] to return

    print "\n$method()";
    if (defined($arg)) {
        print " '$arg'";
    }
    print "\n";
    if (fail($method)) {
        return undef;
    }

    if ($method =~ m/^fetch/ || $method =~ m/^select/) {
        if ($method eq "fetch"
         || $method eq "fetchrow_array"
         || $method eq "selectrow_array") {
            return force_retval_array($retval, @_);
        }
        return force_retval_scalar($retval);
    }
    return $retval;
}


# ------
# ------ Test::MockDBI external methods
# ------


# ------ return the current DBI testing type number
sub get_dbi_test_type {
    return $type;
}


# ------ set the current DBI testing type number
sub set_dbi_test_type {
    $type = shift;
    if (!defined($type) || $type !~ m/^\d+$/) {
        $type = 0;
    }
}


# ------ force a DBI method to be bad
sub bad_method {
    my $self   = shift;                 # my blessed self
    my $method = shift;     # method name
    my $type   = shift;     # type number from --dbitest=TYPE
    my $sql    = shift;     # SQL pattern for badness

    $fail{$method}->{$type}->{"SQL"} = $sql;
}


# ------ set up an array return value for the specified SQL pattern
sub set_retval_array {
    my $self   = shift;                 # my blessed self
    my $type   = shift;     # type number from --dbitest=TYPE
    my $sql    = shift;     # SQL pattern for badness

    push @{ $array_retval{$type} },
     { "SQL" => $sql, "retval" => [ @_ ] },
}


# ------ set up scalar return value for the specified SQL pattern
sub set_retval_scalar {
    my $self   = shift;                 # my blessed self
    my $type   = shift;     # type number from --dbitest=TYPE
    my $sql    = shift;     # SQL pattern for badness

    push @{ $scalar_retval{$type} },
     { "SQL" => $sql, "retval" => $_[0] },
}


# ------ force a parameter to be bad
sub bad_param {
    my $self      = shift;              # my blessed self
    my $bad_type  = shift;     # type number from --dbitest=TYPE
    my $bad_param = shift;  # "known" bad parameter number
    my $bad_value = shift;  # "known" bad parameter value

        push(@bad_params, [ $bad_type, $bad_param, $bad_value ] );
}


#
# ------ GLOBAL INITIALIZATION
#
# ------ initialize our instance
$instance = bless {}, "Test::MockDBI";

# ------ set our testing type if we are in test mode
$type = 0;
if ($#ARGV >= 0 && $ARGV[0] =~ m/^--?dbitest(=(\d+))?/) {
    $type = 1;
    if (defined($2)) {
        $type = $2;
    }
    shift;
}

# ------ non-zero type of DBI testing to perform
if ($type) {

    # ------ initialize DBI mock interface
    $mock = Test::MockObject::Extends->new();
    print "mock DBI interface initialized...\n";

    $mock->fake_module("DBI",
     connect =>  sub {
        my $self = shift;
        my $dsn  = Define(shift);
        my $user = Define(shift);
        my $pass = Define(shift);
        $object = bless({}, "DBI");
        $cur_sql = "CONNECT TO $dsn AS $user WITH $pass";
        $fail_param = 0;
        return fake("connect", $cur_sql, $object);
     },
     disconnect =>  sub {
        $cur_sql = "DISCONNECT";
        $fail_param = 0;
        return fake("disconnect", $_[1], 1);
     },
     errstr =>  sub {
        return "DBI error at '$cur_sql'";
     },
     prepare =>  sub {
        $cur_sql = Define($_[1]);
        $fail_param = 0;
        return fake("prepare", $_[1], $object);
     },
     prepare_cached =>  sub {
        $cur_sql = Define($_[1]);
        $fail_param = 0;
        return fake("prepare_cached", $_[1], $object);
     },
     commit =>  sub {
        return fake("commit", $_[1], 1);
     },
     bind_columns =>  sub {
        return fake("bind_columns", $_[1], 1);
     },
     bind_param => sub {
        my $self         = shift;         # my blessed self
        my $param        = Define(shift); # parameter number
        my $value        = shift;         # parameter value
        my $attr_or_type = Define(shift); # attributes or type
        my $bad_param    = "";            # 1 of @bad_params

        print "\nbind_param()\n";
        print "parm $param, value ";
        print Dumper($value);
        if ($attr_or_type) {
            if (ref($attr_or_type) eq "HASH") {
                print "  attrs ", Dumper($attr_or_type);
            } else {
                print "type '$attr_or_type'";
            }
        }
        print "\n";
        if (fail("bind_param")) {
           return undef;
        }
        foreach $bad_param (@bad_params) {
            if ($bad_param->[0] == $type
             && $bad_param->[1] == $param
             && $bad_param->[2] eq $value) {
                print "MOCK_DBI: BAD PARAM $param = '$value'\n";
                $fail_param = 1;
            }
        }
        return 1;
     },
     execute =>  sub {
        return fake("execute", $_[1], 1);
     },
     finish =>  sub {
        $fail_param = 0;
        return fake("finish", $_[1], 1);
     },
     fetchall_arrayref =>  sub {
        return fake("fetchall_arrayref", $_[1], undef);
     },
     fetchrow_arrayref =>  sub {
        return fake("fetchrow_arrayref", $_[1], undef);
     },
     fetchrow_array =>  sub {
        return fake("fetchrow_array", $_[1], undef);
     },
     fetchrow =>  sub {
        return fake("fetchrow", $_[1], undef);
     },
     fetch =>  sub {
        return fake("fetch", $_[1], undef);
     },
     );
    $mock->fake_new("DBI");
}



# ------ return our instance, as we are a singleton class
sub get_instance {
    return $instance;
}


1;

__END__


=head1 NAME

Test::MockDBI - Mock DBI interface for testing

=head1 SYNOPSIS

  use Test::MockDBI;
     OR
  use Test::MockDBI qw( :all );

  Test::MockDBI::set_dbi_test_type(42);
  if (Test::MockDBI::get_dbi_test_type() == 42) {
    ...

  $mock_dbi = get_instance Test::MockDBI;

  $mock_dbi->bad_method(
   $method_name,
   $dbi_testing_type,
   $matching_sql);

  $mock_dbi->bad_param(
   $dbi_testing_type,
   $param_number,
   $param_value);

  $mock_dbi->set_retval_array(
   $dbi_testing_type,
   $matching_sql,
   @retval || CODEREF);
  $mock_dbi->set_retval_array(MOCKDBI_WILDCARD, ...

  $mock_dbi->set_retval_scalar(
   $dbi_testing_type,
   $matching_sql,
   $retval || CODEREF);
  $mock_dbi->set_retval_scalar(MOCKDBI_WILDCARD, ...

=head1 DESCRIPTION

Test::MockDBI provides a way to test DBI interfaces by
creating rules for changing the DBI's behavior, then
examining the standard output for matching patterns.

Testing using Test::MockDBI is enabled by setting
the DBI testing type to a non-zero value.  This can
be done either by using a first program argument
of "--dbitest[=TYPE]", or by using the class method
Test::MockDBI::set_dbi_test_type().  (Supplying a first
argument of "--dbitest[=TYPE]" often works well during
testing.)  TYPE is a simple integer (/^\d+$/).  Supplying
"--dbitest[=TYPE]" as a first argument works even if no
other command-line processing is done, as Test::MockDBI
does its own command-line processing to check for this
first "--dbitest[=TYPE]" argument.  You will want to
add "--dbitest[=TYPE]" during a BEGIN block before the
"use Test::MockDBI", so that the mock DBI is initialized
as early as possible.

TYPE is optional, as a first argument of "--dbitest"
will set the DBI testing type to 1 (one).  DBI testing
is also disabled by "--dbitest=0" (although this
may not be generally useful).  The class method
Test::MockDBI::set_dbi_test_type() can also be used to
set or change the DBI testing type.

When DBI testing is disabled, DBI is used as you would
expect.  This makes using Test::MockDBI transparent to
your users.

The one exportable constant is:

=over 4

=item MOCKDBI_WILDCARD

MOCKDBI_WILDCARD is the wildcard DBI testing type
("--dbitest=TYPE"), used when the fetch*() functions should
always return the same value no matter what DBI testing
type has been set.

=back

External methods are:

=over 4

=item get_dbi_test_type()

Returns the numeric DBI test type. The type is 0 when not
testing the DBI interface.

=item set_dbi_test_type()

Sets the numeric DBI test type. The type is set to 0 if the
argument cannot be interpreted as a simple integer digit
string (/^\d+$/).

=item bad_method()

For the DBI method $method_name, when the DBI testing type
is $dbi_testing_type and the current SQL matches the regex
pattern in the string $matching_sql, make the function fail
(usually by returning undef).

=item bad_param()

When the DBI testing type is $dbi_testing_type, make the
fetch*() functions fail if one of their corresponding
bind_param()s has parameter number $param_number with
the value $param_value.

=item set_retval_array()

When the DBI testing type is $dbi_testing_type and
the current SQL matches the pattern in the string
$matching_sql, fetch() and fetchrow_array() return the
contents of the array @retval.  If retval is actually a
CODEREF, the array returned from calling that subroutine
will be returned instead.

=item set_retval_scalar()

When the DBI testing type is $dbi_testing_type and
the current SQL matches the pattern in the string
$matching_sql, fetchall_arrayref(), fetchrow_arrayref(),
and fetchrow() return the scalar value $retval.  If retval
is actually a CODEREF, the scalar returned from calling
that subroutine will be returned instead.

=back

=head1 NOTES

A good source of Test::MockDBI examples is how the t/*.t
test programs examine the output (and modify the behavior)
of the t/*.pl test programs.

bad_method() forces developers to use a different DBI
testing type ("--dbitest=TYPE") for each different SQL
pattern for a DBI method.  This can be construed as
a feature.  (The workaround to this feature is to use
MOCKDBI_WILDCARD.)

DBI fetch() and fetchrow_array() will return the undef
value if the specified return value is a 1-element array
with undef as the only element.  I don't think this should
prove a major obstacle in testing.  It was coded this way
due to how Perl currently handles a return value of undef
when an array is expected, which is a one-element array
with undef as the only element.

MOCKDBI_WILDCARD is only supported for the fetch*()
return value setting methods, set_retval_scalar() and
set_retval_array().  It probably does not make sense for
the other external methods, as they are for creating DBI
failures (and how often do you want your code to fail for
all DBI testing types?)

If for some strange reason you should be installing
Test::MockDBI into a system with DBI but without any
DBD drivers (apart from DBD drivers bundled with DBI),
you can use:
    perl samples/sample.pl
    cp samples/DBI.cfg .
to create a sample DBM database for testing Test::MockDBI.

Test::MockDBI can be viewed as a "printf() and scratch
head" helper for DBI applications.

=head1 SEE ALSO

DBI, Test::MockObject, Test::More, Test::Simple,
IO::String (for capturing standard output)

DBD::Mock (another approach to testing DBI applications)

DBI trace() (still another approach to testing DBI
applications)

=head1 AUTHOR

Mark Leighton Fisher,
E<lt>mark-fisher@fisherscreek.comE<gt>

=head1 COPYRIGHT

Copyright 2004, Fisher's Creek Consulting, LLC.  Copyright
2004, DeepData, Inc.

=head1 LICENSE

This code is released under the same licenses as Perl
itself.