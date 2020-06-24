use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Mojo::File 'curfile';

my $t = Test::Mojo->new(curfile->sibling('app.pl'));

# sample(tests)
$t->get_ok('/')
  ->status_is(200)
  ->content_type_like(qr'text/plain')
  ->content_is('Hello 🌐!');

$t->get_ok('/Greedo')
  ->status_is(200)
  ->content_type_like(qr'text/plain')
  ->content_is('Hello Greedo!');
# end-sample

done_testing;

