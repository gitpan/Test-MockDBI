# Test::MockDBI DBI::rows() return value when numeric argument

# $Id: set_rows-numeric.t 246 2008-12-04 13:01:22Z aff $

# ------ enable testing mock DBI
BEGIN { push @ARGV, "--dbitest"; }

# ------ use/require pragmas
use strict;            # better compile-time checking
use warnings;          # better run-time checking

use Test::More;        # advanced testing
use Test::Warn;

use File::Spec::Functions;
use lib catdir qw ( blib lib );    # use local module
use Test::MockDBI;     # module we are testing

plan tests => 2;

# ------ define variables
my $dbh = "";          # mock DBI database handle
my $tmd = "";          # Test::MockDBI object

# ------ numeric #rows argument
$tmd = get_instance Test::MockDBI;

warning_like{
  $tmd->set_rows(1, "some rows", 42);
} qr/set_rows is deprecated/, "Legacy warning displayed";

$dbh = DBI->connect();
my $sth = $dbh->prepare("some rows");
cmp_ok($sth->rows(),q[==], 42, q[Expect numeric value in return]);

__END__

