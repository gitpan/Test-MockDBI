# Test making DBI parameters bad


# ------ use/require pragmas
use strict;                             # better compile-time checking
use warnings;                           # better run-time checking
use Test::More tests =>  5;             # advanced testing


# ------ define variables
my @array = ();				# generic array
my $out   = "";                         # test command output


# ------ bad param: simple test OK
$out = `t/bad_param-ok.pl 2>&1`;
like($out, qr/MOCK_DBI: BAD PARAM 1 = 'jimbo'.+OK/ms,
 "bad param: simple test OK");


# ------ bad param: 2nd param bad
$out = `t/bad_param-ok-2.pl 2>&1`;
like($out, qr/MOCK_DBI: BAD PARAM 2 = 'noblesville'.+OK/ms,
 "bad param: 2nd param bad");


# ------ bad param: 2nd of 3 params bad
$out = `t/bad_param-ok-2of3.pl 2>&1`;
@array = ($out =~ m/BAD/g);
ok($out =~ m/'46062'.+'noblesville'.+'IN'.+OK/ms && scalar(@array) == 1,
 "bad param: 2nd of 3 params bad");


# ------ bad param: no bad params bound
$out = `t/bad_param-ok-none.pl 2>&1`;
@array = ($out =~ m/BAD/g);
ok($out =~ m/'46062'.+'Noblesville'.+'IN'.+OK/ms && scalar(@array) == 0,
 "bad param: no bad params bound");


# ------ bad param: different DBI type so no bad params found
$out = `t/bad_param-diff-type.pl 2>&1`;
like($out, qr/bind_param\(\)\s+parm 1, value \$VAR1 = 'jimbo';\s+execute\(\)\s+fetchrow_arrayref\(\)\s+OK/ms,
 "bad param: different DBI type so no bad params found");
