# Source for t/bad_param-ok-none.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Test::MockDBI no bad params bound


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
my $select = "";			# DBI SQL SELECT statement handle


# ------ set up return values for DBI fetch*() methods
$dbh = DBI->connect("", "", "");
$md->bad_param(2, 2, "noblesville");
$md->set_retval_scalar(2, "other SQL", [ 42 ]);
$select = $dbh->prepare("other SQL");
$select->bind_param(1, "46062");
$select->bind_param(2, "Noblesville");
$select->bind_param(3, "IN");
$select->execute();
if ($select->fetchrow_arrayref()->[0] == 42) {
	print "OK\n";
}
$select->finish();
EOF

close($ofh);
chmod(0755, $ARGV[0]);
