# Source for t/test-type-default.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Default DBI testing type ("--dbitest" on command line)


# ------ setup for Test::MockDBI
BEGIN { push @ARGV, "--dbitest"; }
 

# ------ use/require pragmas
use strict;				# better compile-time checking
use warnings;				# better run-time checking
use lib "blib/lib";			# use local copy of Test::MockDBI
use Test::MockDBI;			# Test DBI with Test::MockObject


# ------ define variables
my $md = "";				# Test::MockDBI instance


# ------ default DBI test type when testing
$md = get_instance Test::MockDBI;
if ($md->get_dbi_test_type() == 1) {
	print "OK\n";
} else {
	print "BAD\n";
}
EOF

close($ofh);
chmod(0755, $ARGV[0]);
