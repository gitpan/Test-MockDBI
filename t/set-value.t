# Test DBI fetch*() returning a specific value


# ------ use/require pragmas
use strict;				# better compile-time checking
use warnings;				# better run-time checking
use Test::More tests => 23;		# advanced testing


# ------ define variables
my $out = "";				# test command output


# ------ fetchrow_array() without args
$out = `t/fetchrow_array-0.pl 2>&1`;
like($out, qr/fetchrow_array\(\).+UNDEF.+fetchrow_array\(\).+EMPTY ARRAY/ms,
 "fetchrow_array() without args");


# ------ fetchrow_array() with 1-element array
$out = `t/fetchrow_array-1.pl 2>&1`;
like($out, qr/fetchrow_array\(\).+UNDEF.+fetchrow_array\(\).+OK/ms,
 "fetchrow_array() with 1-element array");


# ------ fetchrow_array() with many-element array
$out = `t/fetchrow_array-many.pl 2>&1`;
like($out, qr/fetchrow_array\(\).+UNDEF.+fetchrow_array\(\).+OK/ms,
 "fetchrow_array() with many-element array");


# ------ fetch() without args
$out = `t/fetch-0.pl 2>&1`;
like($out, qr/fetch\(\).+UNDEF.+fetch\(\).+EMPTY ARRAY/ms,
 "fetch() without args");


# ------ fetch() with 1-element array
$out = `t/fetch-1.pl 2>&1`;
like($out, qr/fetch\(\).+UNDEF.+fetch\(\).+OK/ms,
 "fetch() with 1-element array");


# ------ fetch() with many-element array
$out = `t/fetch-many.pl 2>&1`;
like($out, qr/fetch\(\).+UNDEF.+fetch\(\).+OK/ms,
 "fetch() with many-element array");


# ------ fetchall_arrayref() without args
$out = `t/fetchall_arrayref-0.pl 2>&1`;
like($out, qr/fetchall_arrayref\(\).+UNDEF.+fetchall_arrayref\(\).+UNDEF/ms,
 "fetchall_arrayref() without args");


# ------ fetchall_arrayref() with 1-element array
$out = `t/fetchall_arrayref-1.pl 2>&1`;
like($out, qr/fetchall_arrayref\(\).+UNDEF.+fetchall_arrayref\(\).+OK/ms,
 "fetchall_arrayref() with 1-element array");


# ------ fetchall_arrayref() with many-element array
$out = `t/fetchall_arrayref-many.pl 2>&1`;
like($out, qr/fetchall_arrayref\(\).+UNDEF.+fetchall_arrayref\(\).+OK/ms,
 "fetchall_arrayref() with many-element array");


# ------ fetchrow_arrayref() without args
$out = `t/fetchrow_arrayref-0.pl 2>&1`;
like($out, qr/fetchrow_arrayref\(\).+UNDEF.+fetchrow_arrayref\(\).+UNDEF/ms,
 "fetchrow_arrayref() without args");


# ------ fetchrow_arrayref() with 1-element array
$out = `t/fetchrow_arrayref-1.pl 2>&1`;
like($out, qr/fetchrow_arrayref\(\).+UNDEF.+fetchrow_arrayref\(\).+OK/ms,
 "fetchrow_arrayref() with 1-element array");


# ------ fetchrow_arrayref() with many-element array
$out = `t/fetchrow_arrayref-many.pl 2>&1`;
like($out, qr/fetchrow_arrayref\(\).+UNDEF.+fetchrow_arrayref\(\).+OK/ms,
 "fetchrow_arrayref() with many-element array");


# ------ fetchrow() without args
$out = `t/fetchrow-0.pl 2>&1`;
like($out, qr/fetchrow\(\).+UNDEF.+fetchrow\(\).+UNDEF/ms,
 "fetchrow() without args");


# ------ fetchrow() with 1-element array
$out = `t/fetchrow-1.pl 2>&1`;
like($out, qr/fetchrow\(\).+UNDEF.+fetchrow\(\).+OK/ms,
 "fetchrow() with 1-element array");


# ------ fetchrow() with many-element array
$out = `t/fetchrow-many.pl 2>&1`;
like($out, qr/fetchrow\(\).+UNDEF.+fetchrow\(\).+OK/ms,
 "fetchrow() with many-element array");


# ------ fetch*() that returns arrays handles multiple SQL statements
$out = `t/fetchrow_array-different-sql.pl 2>&1`;
like($out, qr/UNDEF.+OK.+UNDEF.+OK.+UNDEF/ms,
 "fetch*() that returns arrays handles multiple SQL statements");


# ------ fetch*() that returns scalars handles multiple SQL statements
$out = `t/fetchrow_arrayref-different-sql.pl 2>&1`;
like($out, qr/UNDEF.+OK.+UNDEF.+OK.+UNDEF/ms,
 "fetch*() that returns scalars handles multiple SQL statements");


# ------ coderef returns 0-element arrayref
$out = `t/coderef-scalar-0.pl`;
like($out, qr/fetchrow_arrayref\(\)\s+UNDEF.+fetchrow_arrayref\(\)\s+OK/ms,
 "coderef returns 0-element arrayref");


# ------ coderef returns 1-element arrayref
$out = `t/coderef-scalar-1.pl`;
like($out, qr/fetchrow_arrayref\(\)\s+UNDEF.+fetchrow_arrayref\(\)\s+OK/ms,
 "coderef returns 1-element arrayref");


# ------ coderef returns many-element arrayref
$out = `t/coderef-scalar-many.pl`;
like($out, qr/fetchrow_arrayref\(\)\s+UNDEF.+fetchrow_arrayref\(\)\s+OK/ms,
 "coderef returns many-element arrayref");


# ------ coderef returns 0-element array
$out = `t/coderef-array-0.pl`;
like($out, qr/fetchrow_array\(\)\s+UNDEF.+fetchrow_array\(\)\s+OK/ms,
 "coderef returns 0-element array");


# ------ coderef returns 1-element array
$out = `t/coderef-array-1.pl`;
like($out, qr/fetchrow_array\(\)\s+UNDEF.+fetchrow_array\(\)\s+OK/ms,
 "coderef returns 1-element array");


# ------ coderef returns many-element array
$out = `t/coderef-array-many.pl`;
like($out, qr/fetchrow_array\(\)\s+UNDEF.+fetchrow_array\(\)\s+OK/ms,
 "coderef returns many-element array");
