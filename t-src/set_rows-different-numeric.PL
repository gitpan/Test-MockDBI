# Source for t/set_rows-different-numeric.pl so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Test::MockDBI DBI::rows() return value when different numeric argument


# ------ enable testing mock DBI
BEGIN { push @ARGV, "--dbitest"; }


# ------ use/require pragmas
use strict;				                # better compile-time checking
use warnings;				            # better run-time checking
use lib "blib/lib";                     # use local modules too
use Test::MockDBI;                      # module we are testing


# ------ define variables
my $dbh = "";				            # mock DBI database handle
my $tmd = "";                           # Test::MockDBI object


# ------ different numeric #rows argument
$tmd = get_instance Test::MockDBI;
$tmd->set_rows(1, "some rows", 312);
$dbh = DBI->connect();
$dbh->prepare("some rows");
if ($dbh->rows() == 312) {
    print "OK\n";
} else {
    print "ERROR\n";
}
EOF

close($ofh);
chmod(0755, $ARGV[0]);
