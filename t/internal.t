# Test::MockDBI tests for mocking DBI functionality within a program.


# ------ enable testing mock DBI
BEGIN { push @ARGV, "--dbitest"; }


# ------ use/require pragmas
use strict;				                # better compile-time checking
use warnings;				            # better run-time checking
use Test::More tests => 19;		        # advanced testing


# ------ define variables
my $dbh = "";				            # mock DBI database handle


# ------ check that Test::MockDBI loads OK
BEGIN { use_ok('Test::MockDBI') };


# ------ DBI connect()
$dbh = DBI->connect();
is(ref($dbh), "DBI",
 "DBI connect()");


# ------ DBI disconnect()
is($dbh->disconnect(), 1,
 "DBI disconnect()");


# ------ DBI prepare()
ok(ref($dbh->prepare("Xy")) eq "DBI" && $dbh->errstr eq "DBI error at 'Xy'",
 "DBI prepare()");


# ------ prepare() returns same handle as connect()
is($dbh->prepare("Xy"), $dbh,
 "prepare() returns same handle as connect()");


# ------ DBI prepare_cached()
ok(ref($dbh->prepare_cached("Xy")) eq "DBI" && $dbh->errstr eq "DBI error at 'Xy'",
 "DBI prepare_cached()");


# ------ prepare_cached() returns same handle as connect()
is($dbh->prepare_cached("Xy"), $dbh,
 "prepare_cached() returns same handle as connect()");


# ------ DBI commit()
is($dbh->commit(), 1,
 "DBI commit()");


# ------ DBI bind_columns()
is($dbh->bind_columns(), 1,
 "DBI bind_columns()");


# ------ DBI bind_param()
is($dbh->bind_param(), 1,
 "DBI bind_param()");


# ------ DBI finish()
is($dbh->finish(), 1,
 "DBI finish()");


# ------ DBI execute()
is($dbh->execute(), 1,
 "DBI execute()");


# ------ DBI fetchall_arrayref()
is($dbh->fetchall_arrayref(), undef,
 "DBI fetchall_arrayref()");


# ------ DBI fetchrow_arrayref()
is($dbh->fetchrow_arrayref(), undef,
 "DBI fetchrow_arrayref()");


# ------ DBI fetchrow_array()
is($dbh->fetchrow_array(), undef,
 "DBI fetchrow_array()");


# ------ DBI fetchrow()
is($dbh->fetchrow(), undef,
 "DBI fetchrow()");


# ------ DBI fetch()
is($dbh->fetch(), undef,
 "DBI fetch()");


# ------ DBI do()
is($dbh->do(), 1,
 "DBI do()");


# ------ DBI rows()
is($dbh->rows(), 0,
 "DBI rows()");