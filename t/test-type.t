# Test::MockDBI DBI test types


# ------ use/require pragmas
use strict;				# better compile-time checking
use warnings;				# better run-time checking
use Test::More tests =>  3;		# advanced testing
use lib "blib/lib";			# use local modules


# ------ define variables
my $out = "";				# command output


# ------ default test type
$out = `t/test-type-default.pl 2>&1`;
like($out, qr/OK/,
 "default test type");


# ------ test type 1
$out = `t/test-type-1.pl 2>&1`;
like($out, qr/OK/,
 "test type 1");


# ------ another test type
$out = `t/test-type-another.pl 2>&1`;
like($out, qr/OK/,
 "another test type");
