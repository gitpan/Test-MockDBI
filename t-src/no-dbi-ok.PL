# Source for t/no-dbi-ok.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Check that DBI appears to work if Test::MockDBI is invoked.
 
BEGIN { push @ARGV, "--dbitest=1"; }
use lib "blib/lib";
use Test::MockDBI;
use i2i;

my $i2i = new I2I;
my $city;
my $select = $i2i->Query(q{SELECT zip5_cityname from ziplist5 where zip5_zipcode='91709'});
$city = $select->fetchrow_arrayref();
$select->finish();
print "$city->[0]\n";
EOF

close($ofh);
chmod(0755, $ARGV[0]);
