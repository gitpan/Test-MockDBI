use 5.008;
use ExtUtils::MakeMaker;

# ------ get DBI parameters for later testing
if (!-s "DBI.cfg") {
	$| = 1;
	my $dsn  = prompt("DBI data source:");
	my $user = prompt("DBI username:");
	my $pass = prompt("DBI password:");
	my $sql  = prompt("DBI 'SELECT' SQL:");
	my $ofh;
	open($ofh, ">DBI.cfg") || die "cannot create DBI.cfg: $!\n";
	print $ofh <<"endPRINT";
DSN  $dsn
USER $user
PASS $pass
SQL  $sql
endPRINT
	close($ofh) || die "cannot close DBI.cfg: $!\n";
	chmod(0600, "DBI.cfg");
}


# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		    => 'Test::MockDBI',
    'VERSION_FROM'	=> 'lib/Test/MockDBI.pm',
    'PREREQ_PM'		=> { Test::MockObject => 0.14 },
    'clean'         => {FILES => "t/*.pl"},
    'PL_FILES'      => {
      "t-src/bad_param-diff-type.PL"             => "t/bad_param-diff-type.pl",
      "t-src/bad_param-ok-2.PL"                  => "t/bad_param-ok-2.pl",
      "t-src/bad_param-ok-2of3.PL"               => "t/bad_param-ok-2of3.pl",
      "t-src/bad_param-ok-none.PL"               => "t/bad_param-ok-none.pl",
      "t-src/bad_param-ok.PL"                    => "t/bad_param-ok.pl",
      "t-src/bind_param-extra-arg.PL"            => "t/bind_param-extra-arg.pl",
      "t-src/bind_param-undef.PL"                => "t/bind_param-undef.pl",
      "t-src/coderef-array-0.PL"                 => "t/coderef-array-0.pl",
      "t-src/coderef-array-1.PL"                 => "t/coderef-array-1.pl",
      "t-src/coderef-array-many.PL"              => "t/coderef-array-many.pl",
      "t-src/coderef-scalar-0.PL"                => "t/coderef-scalar-0.pl",
      "t-src/coderef-scalar-1.PL"                => "t/coderef-scalar-1.pl",
      "t-src/coderef-scalar-many.PL"             => "t/coderef-scalar-many.pl",
      "t-src/connect.PL"                         => "t/connect.pl",
      "t-src/dbi-ok.PL"                          => "t/dbi-ok.pl",
      "t-src/fetch-0.PL"                         => "t/fetch-0.pl",
      "t-src/fetch-1.PL"                         => "t/fetch-1.pl",
      "t-src/fetch-many.PL"                      => "t/fetch-many.pl",
      "t-src/fetchall_arrayref-0.PL"             => "t/fetchall_arrayref-0.pl",
      "t-src/fetchall_arrayref-1.PL"             => "t/fetchall_arrayref-1.pl",
      "t-src/fetchall_arrayref-many.PL"          => "t/fetchall_arrayref-many.pl",
      "t-src/fetchrow-0.PL"                      => "t/fetchrow-0.pl",
      "t-src/fetchrow-1.PL"                      => "t/fetchrow-1.pl",
      "t-src/fetchrow-many.PL"                   => "t/fetchrow-many.pl",
      "t-src/fetchrow_array-0.PL"                => "t/fetchrow_array-0.pl",
      "t-src/fetchrow_array-1.PL"                => "t/fetchrow_array-1.pl",
      "t-src/fetchrow_array-different-sql.PL"    => "t/fetchrow_array-different-sql.pl",
      "t-src/fetchrow_array-many.PL"             => "t/fetchrow_array-many.pl",
      "t-src/fetchrow_arrayref-0.PL"             => "t/fetchrow_arrayref-0.pl",
      "t-src/fetchrow_arrayref-1.PL"             => "t/fetchrow_arrayref-1.pl",
      "t-src/fetchrow_arrayref-different-sql.PL" => "t/fetchrow_arrayref-different-sql.pl",
      "t-src/fetchrow_arrayref-many.PL"          => "t/fetchrow_arrayref-many.pl",
      "t-src/no-dbi-ok.PL"                       => "t/no-dbi-ok.pl",
      "t-src/test-type-1.PL"                     => "t/test-type-1.pl",
      "t-src/test-type-another.PL"               => "t/test-type-another.pl",
      "t-src/test-type-default.PL"               => "t/test-type-default.pl"
     },
    ($] >= 5.005 ?
      (ABSTRACT_FROM    => 'lib/Test/MockDBI.pm',
       AUTHOR           => 'Mark Leighton Fisher <mark-fisher@fisherscreek.com>') : ()),
);
