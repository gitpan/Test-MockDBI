# Test::MockDBI bad DBI method tests


# ------ enable testing mock DBI
BEGIN { push @ARGV, "--dbitest=2"; }


# ------ use/require pragmas
use strict;				# better compile-time checking
use warnings;				# better run-time checking
use Test::More tests => 15;		# advanced testing
use lib "blib/lib";			# use local modules
use Test::MockDBI;			# what we are testing


# ------ define variables
my $dbh = "";				# mock DBI database handle
my $md					# Test::MockDBI instance
 = Test::MockDBI::get_instance();


# ------ make all methods bad
$md->bad_method("connect",           2, "CONNECT");
$md->bad_method("disconnect",        2, "DISCONNECT");
$md->bad_method("errstr",            2, "");
$md->bad_method("prepare",           2, "");
$md->bad_method("prepare_cached",    2, "");
$md->bad_method("commit",            2, "");
$md->bad_method("bind_columns",      2, "");
$md->bad_method("bind_param",        2, "");
$md->bad_method("execute",           2, "");
$md->bad_method("finish",            2, "");
$md->bad_method("fetchall_arrayref", 2, "");
$md->bad_method("fetchrow_arrayref", 2, "");
$md->bad_method("fetchrow_array",    2, "");
$md->bad_method("fetchrow",          2, "");
$md->bad_method("fetch",             2, "^\$");


# ------ fake DBI object for testing
$dbh = bless {}, "DBI";

# ----- NOTE: connect() and disconnect() must be before prepare*()
# -----       as they set the current SQL


# ------ DBI connect()
is(DBI->connect(), undef,
 "DBI connect()");


# ------ DBI disconnect()
is($dbh->disconnect(), undef,
 "DBI disconnect()");


# ------ DBI prepare()
is($dbh->prepare(), undef,
 "DBI prepare()");


# ------ DBI finish()
is($dbh->finish(), undef,
 "DBI finish()");


# ------ DBI prepare_cached()
is($dbh->prepare_cached(), undef,
 "DBI prepare_cached()");


# ------ DBI commit()
is($dbh->commit(), undef,
 "DBI commit()");


# ------ DBI bind_columns()
is($dbh->bind_columns(), undef,
 "DBI bind_columns()");


# ------ DBI bind_param()
is($dbh->bind_param(), undef,
 "DBI bind_param()");


# ------ DBI execute()
is($dbh->execute(), undef,
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
# ------ also SQL match with explicit pattern but no SQL
is($dbh->fetch(), undef,
 "DBI fetch() + pattern without SQL");


# ------ SQL without pattern
is(ref($dbh->prepare("SELECT *")), ref($dbh),
 "SQL without pattern");
