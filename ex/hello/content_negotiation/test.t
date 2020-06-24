use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Mojo::File 'curfile';

my $t = Test::Mojo->new(curfile->sibling('app.pl'));

# sample(root)
$t->get_ok('/')
  ->status_is(200)
  ->content_type_like(qr'text/html')
  ->text_is('#greeting .user' => '🌐');

$t->get_ok('/.txt')
  ->status_is(200)
  ->content_type_like(qr'text/plain')
  ->content_is('Hello 🌐!');

$t->get_ok('/.json')
  ->status_is(200)
  ->content_type_like(qr'application/json')
  ->json_is({hello => '🌐!'});
# end-sample

# sample(user)
$t->get_ok('/C-3PO')
  ->status_is(200)
  ->content_type_like(qr'text/html')
  ->text_is('#greeting .user' => 'C-3PO');

$t->get_ok('/Leia.txt')
  ->status_is(200)
  ->content_type_like(qr'text/plain')
  ->content_is('Hello Leia!');

$t->get_ok('/Chewbacca.json')
  ->status_is(200)
  ->content_type_like(qr'application/json')
  ->json_is('/hello' => 'Chewbacca!');
# end-sample

# sample(others)
$t->get_ok('/Lando', {Accept => 'text/plain'})
  ->status_is(200)
  ->content_type_like(qr'text/plain')
  ->content_is('Hello Lando!');

$t->get_ok('/Ackbar?format=txt')
  ->status_is(200)
  ->content_type_like(qr'text/plain')
  ->content_is('Hello Ackbar!');
# end-sample

done_testing;

