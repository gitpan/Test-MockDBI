# Source for t/set_rows-no-arg.pl so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Test::MockDBI DBI::rows() return value when no argument


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


# ------ no #rows argument
$tmd = get_instance Test::MockDBI;
$tmd->set_rows(1, "some rows");
$dbh = DBI->connect();
$dbh->prepare("some rows");
if (!defined($dbh->rows())) {
    print "OK\n";
} else {
    print "ERROR\n";
}
EOF

close($ofh);
chmod(0755, $ARGV[0]);
