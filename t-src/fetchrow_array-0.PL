# Source for t/fetchrow_array-0.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Test::MockDBI fetchrow_array() when given no array to return


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
my @retval = ();			# return array from fetchrow_array()


# ------ set up return values for DBI fetch*() methods
$dbh = DBI->connect("", "", "");
$md->set_retval_array(2, "FETCHROW_ARRAYREF");
$dbh->prepare("other SQL");
if (defined($dbh->fetchrow_array())) {
	print "ERROR\n";
} else {
	print "UNDEF\n";
}
$dbh->finish();
$dbh->prepare("FETCHROW_ARRAYREF");
@retval = $dbh->fetchrow_array();
if (scalar(@retval) > 0) {
	print "ERROR\n";
} else {
	print "EMPTY ARRAY\n";
}
$dbh->finish();
EOF

close($ofh);
chmod(0755, $ARGV[0]);
