use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Mojo::File 'curfile';

my $t = Test::Mojo->new(curfile->sibling('app.pl'));

$t->get_ok('/')
  ->status_is(200)
  ->content_is('Hello World!');

done_testing;

