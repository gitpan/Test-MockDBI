# Source for t/fetchrow_array-1.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Test::MockDBI fetchrow_array() with 1-element array returned


# ------ enable testing mock DBI
BEGIN { push @ARGV, "--dbitest=2"; }


# ------ use/require pragmas
use strict;				                # better compile-time checking
use warnings;				            # better run-time checking
use lib "blib/lib";			            # use local modules
use Test::MockDBI;			            # what we are testing


# ------ define variables
my $dbh    = "";			            # mock DBI database handle
my $md					                # Test::MockDBI instance
 = Test::MockDBI::get_instance();
my @retval = ();			            # return values from fetchrow_array()


# ------ set up return values for DBI fetch*() methods
$dbh = DBI->connect("", "", "");
$md->set_retval_array(2, "FETCHROW_ARRAY", 42);
$dbh->prepare("other SQL");
@retval = $dbh->fetchrow_array();
if (scalar(@retval) == 0) {
	print "OK\n";
} else {
	print "ERROR\n";
}
$dbh->finish();
$dbh->prepare("FETCHROW_ARRAY");
@retval = $dbh->fetchrow_array();
if (scalar(@retval) == 1 && $retval[0] == 42) {
	print "OK\n";
} else {
	print "ERROR\n";
}
$dbh->finish();
EOF

close($ofh);
chmod(0755, $ARGV[0]);
