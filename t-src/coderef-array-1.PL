# Source for t/coderef-array-1.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Test::MockDBI fetch*() with 1-element array returned from coderef


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
my @retval = ();			# return value from fetchrow_array()


# ------ set up return values for DBI fetchrow_array*() methods
$dbh = DBI->connect("x", "y", "z");
$md->set_retval_array(2, "FETCHROW_ARRAY", sub { return 1054; });
$dbh->prepare("other SQL");
if (defined($dbh->fetchrow_array())) {
	print "ERROR\n";
} else {
	print "UNDEF\n";
}
$dbh->finish();
$dbh->prepare("FETCHROW_ARRAY");
@retval = $dbh->fetchrow_array();
if (defined($retval[0]) && $retval[0] == 1054) {
	print "OK\n";
} else {
	print "ERROR\n";
}
$dbh->finish();
EOF

close($ofh);
chmod(0755, $ARGV[0]);
