use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Mojo::File 'curfile';

my $t = Test::Mojo->new(curfile->sibling('app.pl'));

$t->get_ok('/')
  ->status_is(200)
  ->content_type_like(qr'text/plain')
  ->content_is('Hello 🌐!');

done_testing;

