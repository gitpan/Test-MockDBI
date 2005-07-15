package Test::MockDBI;

use strict;
use warnings;

use Carp;
use DBI;
use Test::MockObject;
use DBD::Mock;

use vars qw( $VERSION );
$VERSION = '0.01';

sub new {
    my $class = shift;

    my $dbh = DBI->connect("dbi:Mock:", "", "", { RaiseError => 1 }) 
        or croak $DBI::errstr;

    my $mock = Test::MockObject->new;
    $mock->fake_module('DBI', connect => sub { $dbh });
    $mock->fake_module(
        'DBI::db', 
         add_resultset => \&mock_add_resultset,
         history       => \&mock_history,
         clear_history => \&mock_clear_history,
    );

    return $dbh;
}

sub mock_add_resultset { 
    my ($self, $results) = @_;
    $self->{mock_add_resultset} = $results;
}

sub mock_history {
    my $self = shift;
    return wantarray 
        ? @{$self->{mock_all_history}} 
        : $self->{mock_all_history_iterator};
}

sub mock_clear_history {
    my $self = shift;
    $self->{mock_clear_history} = 1;
}

1;
__END__

=head1 NAME

Test::MockDBI - Perl extension for mocking database calls

=head1 SYNOPSIS

  use Test::MockDBI;
  use Test::More tests => 5;

  BEGIN { use_ok('MyClass') };

  my $mock = Test::MockDBI->new;

  $mock->add_resultset([
      [ 'results' ],
      [ 'result1' ],
      [ 'result2' ],
      [ 'result3' ],
  ]);

  can_ok 'MyClass', 'new';

  my $o = MyClass->new();

  isa_ok $o, 'MyClass';

  is_deeply [ $o->results ], [qw/ result1 result2 result3 /], 'sql query returned results';

  is_deeply [ $o->results ], [], 'sql query retured no results';

=head1 DESCRIPTION

Test::MockDBI provides a simplified interface to using DBD::Mock in your test cases.  See the SYNOPSIS above for an example of how it can be used.

=head1 SEE ALSO

L<DBD::Mock>

L<Test::MockObject>

=head1 AUTHOR

Todd Caine, E<lt>tcaine@cac.washington.edu<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2005 by Todd Caine

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
