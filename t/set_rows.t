# Test::MockDBI tests for setting DBI::rows() return value


# ------ enable testing mock DBI
BEGIN { push @ARGV, "--dbitest"; }


# ------ use/require pragmas
use strict;				                # better compile-time checking
use warnings;				            # better run-time checking
use Test::More tests =>  4;		        # advanced testing


# ------ define variables
my $out = "";				            # test program output


# ------ no #rows argument
$out = `t/set_rows-no-arg.pl 2>&1`;
like($out, qr/OK/,
 "no #rows argument");


# ------ undef argument
$out = `t/set_rows-undef.pl 2>&1`;
like($out, qr/OK/,
 "undef argument");


# ------ numeric argument
$out = `t/set_rows-numeric.pl 2>&1`;
like($out, qr/OK/,
 "numeric argument");


# ------ different numeric argument
$out = `t/set_rows-different-numeric.pl 2>&1`;
like($out, qr/OK/,
 "different numeric argument");


# ------ we won't bother to test non-numeric arguments,
# ------ as I can't see any use for them but I can't
# ------ see prohibiting them either
