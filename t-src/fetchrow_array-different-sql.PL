# Source for t/fetchrow_array-different-sql.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Test::MockDBI fetch*() which return an array handle multiple SQL statements.


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


# ------ set up return values for DBI fetch*() methods
$dbh = DBI->connect("", "", "");
$md->set_retval_array(2, "FETCHROW_ARRAY", "go deep", 476);
$md->set_retval_array(2, "SELECT zip5_zipcode.+'Chino Hills'",
 "Experian stuff", 1492);
$dbh->prepare("other SQL");
if (defined($dbh->fetchrow_array())) {
	print "ERROR\n";
} else {
	print "UNDEF\n";
}
$dbh->finish();
$dbh->prepare("FETCHROW_ARRAY");
@retval = $dbh->fetchrow_array();
if (scalar(@retval) == 2 && $retval[0] eq "go deep" && $retval[1] == 476) {
	print "OK\n";
} else {
	print "ERROR\n";
}
$dbh->finish();
$dbh->prepare("STILL oTheR SQL");
if (defined($dbh->fetchrow_array())) {
	print "ERROR\n";
} else {
	print "UNDEF\n";
}
$dbh->finish();
$dbh->prepare("SELECT zip5_zipcode FROM ziplist5 WHERE zip5_cityname = 'Chino Hills'");
@retval = $dbh->fetchrow_array();
if (scalar(@retval) == 2 && $retval[0] eq "Experian stuff" && $retval[1] == 1492) {
	print "OK\n";
} else {
	print "ERROR\n";
}
$dbh->finish();
$dbh->prepare("LaSt sqL");
if (defined($dbh->fetchrow_array())) {
	print "ERROR\n";
} else {
	print "UNDEF\n";
}
$dbh->finish();
EOF

close($ofh);
chmod(0755, $ARGV[0]);
