# Source for t/fetchrow-0.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Test::MockDBI fetchrow() when given no array to return


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
my $retval = "";			# return array from fetchrow()


# ------ set up return values for DBI fetch*() methods
$dbh = DBI->connect("", "", "");
$md->set_retval_scalar(2, "FETCHROW");
$dbh->prepare("other SQL");
if (defined($dbh->fetchrow())) {
	print "ERROR\n";
} else {
	print "UNDEF\n";
}
$dbh->finish();
$dbh->prepare("FETCHROW");
$retval = $dbh->fetchrow();
if (defined($retval)) {
	print "ERROR\n";
} else {
	print "UNDEF\n";
}
$dbh->finish();
EOF

close($ofh);
chmod(0755, $ARGV[0]);
