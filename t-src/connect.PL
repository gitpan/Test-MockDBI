# Source for t/connect.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# DBI connect() for mock DBI.


# ------ setup for Test::MockDBI
BEGIN { push @ARGV, "--dbitest"; }
 

# ------ use/require pragmas
use strict;				# better compile-time checking
use warnings;				# better run-time checking
use lib "blib/lib";			# use local copy of Test::MockDBI
use DBI;				# database interface
use Test::MockDBI;			# Test DBI with Test::MockObject


# ------ define variables
my $dbh   = "";				# database handle


# ------ get a row from the database: must have 1+ columns with 1st column defined
$dbh = DBI->connect("universe", "mortal", "root-password")
 || die "cannot connect to '$ENV{DBI_DSN}': " . DBI::errstr() . "\n";
if (ref($dbh) eq "DBI") {
	print "dbh is a DBI\n";
} else {
	print "dbh is NOT a DBI?\n";
}
$dbh->disconnect();
EOF

close($ofh);
chmod(0755, $ARGV[0]);
