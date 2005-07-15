
use strict;
use warnings;

use lib "t/lib";
use Test::More qw( no_plan );
use Test::MockDBI;

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

is_deeply [$o->results], [], 'sql query retured no results';

my @history = $mock->history;
is scalar @history, 2, 'there were 2 database calls made';

isa_ok $history[0], 'DBD::Mock::StatementTrack';
isa_ok $history[1], 'DBD::Mock::StatementTrack';

my $history = $mock->history;
isa_ok $history, 'DBD::Mock::StatementTrack::Iterator';

$mock->clear_history;

@history = $mock->history;
is @history, 0, 'the history was cleared';

$history = $mock->history;

is $history->next(), undef, 'the history was cleared';

