# Source for t/fetchrow-many.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Test::MockDBI fetchrow() with many-element array returned
# (For our purposes, 2 eq many.)


# ------ enable testing mock DBI
BEGIN { push @ARGV, "--dbitest=2"; }


# ------ use/require pragmas
use strict;				    # better compile-time checking
use warnings;				# better run-time checking
use lib "blib/lib";			# use local modules
use Test::MockDBI;			# what we are testing


# ------ define variables
my $dbh    = "";			# mock DBI database handle
my $md					    # Test::MockDBI instance
 = Test::MockDBI::get_instance();
my @retval = ();			# return values from fetchrow()


# ------ set up return values for DBI fetchrow*() methods
$dbh = DBI->connect("", "", "");
$md->set_retval_array(2, "FETCHROW", "go deep", 476);
$dbh->prepare("other SQL");
if (defined($dbh->fetchrow())) {
	print "ERROR\n";
} else {
	print "UNDEF\n";
}
$dbh->finish();
$dbh->prepare("FETCHROW");
@retval = $dbh->fetchrow();
if (scalar(@retval) == 2
 && $retval[0] eq "go deep" && $retval[1] == 476) {
	print "OK\n";
} else {
	print "ERROR\n";
}
$dbh->finish();
EOF

close($ofh);
chmod(0755, $ARGV[0]);
