# Source for t/coderef-scalar-many.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Test::MockDBI fetch*() with many-element array returned from coderef


# ------ enable testing mock DBI
BEGIN { push @ARGV, "--dbitest=2"; }


# ------ use/require pragmas
use strict;				# better compile-time checking
use warnings;				# better run-time checking
use lib "blib/lib";			# use local modules
use Test::MockDBI;			# what we are testing


# ------ define variables
my $dbh    = "";			# mock DBI database handle
my $md					# Test::MockDBI instance
 = Test::MockDBI::get_instance();
my $retval = "";			# return value from fetchrow_arrayref()


# ------ set up return values for DBI fetchrow*() methods
$dbh = DBI->connect("x", "y", "z");
$md->set_retval_scalar(2, "FETCHROW", sub { return [ 1016, 1066 ]; });
$dbh->prepare("other SQL");
if (defined($dbh->fetchrow_arrayref())) {
	print "ERROR\n";
} else {
	print "UNDEF\n";
}
$dbh->finish();
$dbh->prepare("FETCHROW");
$retval = $dbh->fetchrow_arrayref();
if (defined($retval) && ref($retval) eq "ARRAY"
 && $retval->[0] == 1016 && $retval->[1] == 1066) {
	print "OK\n";
} else {
	print "ERROR\n";
}
$dbh->finish();
EOF

close($ofh);
chmod(0755, $ARGV[0]);
