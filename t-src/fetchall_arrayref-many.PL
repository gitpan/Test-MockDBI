# Source for t/fetchall_arrayref-many.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Test::MockDBI fetchall_arrayref() with many-element array returned
# (For our purposes, 2 eq many.)


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
my $retval = ();			# return value from fetchall_arrayref()


# ------ set up return values for DBI fetchall_arrayref*() methods
$dbh = DBI->connect("", "", "");
$md->set_retval_scalar(2, "FETCH", [ [ "go deep", 476 ], [ 1066, "Yellow Pages" ] ]);
$dbh->prepare("other SQL");
if (defined($dbh->fetchall_arrayref())) {
	print "ERROR\n";
} else {
	print "UNDEF\n";
}
$dbh->finish();
$dbh->prepare("FETCH");
$retval = $dbh->fetchall_arrayref();
if (defined($retval)
 && ref($retval)      eq "ARRAY"
 && ref($retval->[0]) eq "ARRAY"
 && ref($retval->[1]) eq "ARRAY"
 && $retval->[0]->[0] eq "go deep" && $retval->[0]->[1] == 476
 && $retval->[1]->[0] == 1066      && $retval->[1]->[1] eq "Yellow Pages") {
	print "OK\n";
} else {
	print "ERROR\n";
}
$dbh->finish();
EOF

close($ofh);
chmod(0755, $ARGV[0]);
