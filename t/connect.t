# Test::MockDBI DBI connect


# ------ enable testing mock DBI
BEGIN { push @ARGV, "--dbitest=3"; }


# ------ use/require pragmas
use strict;				# better compile-time checking
use warnings;				# better run-time checking
use Test::More tests =>  1;		# advanced testing
use lib "blib/lib";			# use local modules
use Test::MockDBI;			# what we are testing


# ------ define variables
my $out = "";				# command output


# ------ DBI connect() OK
$out = `t/connect.pl 2>&1`;
like($out, qr/connect\(\)\s+'CONNECT TO universe AS mortal WITH root-password'\s+dbh is a DBI\s+disconnect\(\)/ms,
 "DBI connect() OK");
