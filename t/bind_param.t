# Test::MockDBI DBI connect


# ------ enable testing mock DBI
BEGIN { push @ARGV, "--dbitest=3"; }


# ------ use/require pragmas
use strict;				# better compile-time checking
use warnings;				# better run-time checking
use Test::More tests =>  2;		# advanced testing
use lib "blib/lib";			# use local modules
use Test::MockDBI;			# what we are testing


# ------ define variables
my $out = "";				# command output


# ------ DBI bind_param() OK
# ------ test no extra arg, hashref extra arg, and non-hashref extra arg
$out = `t/bind_param-extra-arg.pl 2>&1`;
like($out, qr/bind_param\(\)\s+parm 1, value \$VAR1 = 'dan';\s+attrs \$VAR1 = {\s+'horse' => 'big'\s+};\s+bind_param\(\)\s+parm 2, value \$VAR1 = 'sugar';\s+type 'small'\s+bind_param\(\)\s+parm 3, value \$VAR1 = 'molly';\s+disconnect\(\)/ms,
 "DBI bind_param() OK");


# ------ 0, '0', "", and undef handled
$out = `t/bind_param-undef.pl 2>&1`;
like($out, qr/VAR1 = 0;[^V]+VAR1 = '';[^V]+VAR1 = '0';[^V]+VAR1 = undef;[^V]+VAR1 = 1054;/ms,
 "0, '0', \"\", and undef handled");
