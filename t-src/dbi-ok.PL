# Source for t/dbi-ok.pl, so we can use correct Perl binary in #!

use Config;

open($ofh, ">$ARGV[0]") || die "cannot create $ARGV[0]: $!\n";
print $ofh "$Config{startperl}\n";
print $ofh <<'EOF';
# Check that DBI works if Test::MockDBI is not invoked.
 

# ------ use/require pragmas
use strict;				# better compile-time checking
use warnings;				# better run-time checking
use lib "blib/lib";			# use local copy of Test::MockDBI
use DBI;				# database interface
use Test::MockDBI;			# Test DBI with Test::MockObject
use ExtUtils::MakeMaker;		# prompt() that plays nicely with Test::Harness


# ------ define variables
my $array = "";				# ref to array from DB
my $dbh   = "";				# database handle
my $dsn   = "";				# DB data source name
my $ifh;				# current input file handle
my $user  = "";				# DB username
my $pass  = "";				# DB password
my $sql   = "";				# SQL for testing


# ------  get DBI parameters for testing
open($ifh, "DBI.cfg") || die "cannot open DBI.cfg: $!\n";
$dsn = <$ifh>;
chomp($dsn);
$dsn =~ m/^\w+\s+(.*)/;
$dsn = $1;
$user = <$ifh>;
chomp($user);
$user =~ m/^\w+\s+(.*)/;
$user = $1;
$pass = <$ifh>;
chomp($pass);
$pass =~ m/^\w+\s+(.*)/;
$pass = $1;
$sql  = <$ifh>;
chomp($sql);
$sql =~ m/^\w+\s+(.*)/;
$sql = $1;
close($ifh);

# ------ get a row from the database: must have 1+ columns with 1st column defined
$dbh = DBI->connect($dsn, $user, $pass)
 || die "cannot connect to '$ENV{DBI_DSN}': " . DBI::errstr() . "\n";
$array = $dbh->selectrow_arrayref($sql);
if (scalar(@$array) > 0 && defined($array->[0])) {
	print "OK\n";
} elsif (scalar(@$array) <= 0) {
	print "BAD: nothing returned\n";
} else {
	print "BAD: item 0 is UNDEF\n";
}
EOF

close($ofh);
chmod(0755, $ARGV[0]);
