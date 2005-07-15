package MyClass;

use strict;
use warnings;
use vars qw( $VERSION );
$VERSION = '0.01';

use DBI;

sub new {
    my $class = shift;
    my @dsn = ();
    my $dbh = DBI->connect( @dsn ) or die $DBI::errstr;
    return bless { DBH => $dbh }, $class;
}

sub results {
    my $self = shift;
    my $aref = $self->{DBH}->selectall_arrayref(qq{
                   SELECT name FROM results ORDER BY name
               });
    return map { $_->[0] } @$aref;
}

1;
