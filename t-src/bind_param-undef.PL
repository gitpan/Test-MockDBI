# Source for t/bind_param-undef.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Test::MockDBI bind_param() undef parameter handling


# ------ setup for Test::MockDBI
# ------ also tests handling of --dbitest default value
BEGIN { push @ARGV, "--dbitest"; }
 

# ------ use/require pragmas
use strict;				# better compile-time checking
use warnings;				# better run-time checking
use lib "blib/lib";			# use local copy of Test::MockDBI
use DBI;				# database interface
use Test::MockDBI;			# Test DBI with Test::MockObject


# ------ define variables
my $dbh   = "";				# database handle


# ------ test no extra arg, hashref extra arg, and non-hashref extra arg
$dbh = DBI->connect("universe", "mortal", "root-password")
 || die "cannot connect to '$ENV{DBI_DSN}': " . DBI::errstr() . "\n";
$dbh->bind_param(1, 0);
$dbh->bind_param(2, "");
$dbh->bind_param(3, '0');
$dbh->bind_param(4, undef);
$dbh->bind_param(5, 1054);
$dbh->disconnect();
EOF

close($ofh);
chmod(0755, $ARGV[0]);
