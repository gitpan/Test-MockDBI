# Test that DBI works OK when Test::MockDBI is used but not invoked.

use lib "blib/lib";
use strict;
use Test::More tests => 1;


# ------ define variables
my $out = "";				# command output


# ------- DBI works OK when Test::MockDBI is used but not invoked
$out = `t/dbi-ok.pl`;
like($out, qr/OK/,
 "DBI works OK when Test::MockDBI is used but not invoked");
