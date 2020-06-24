use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Mojo::File 'curfile';

my $t = Test::Mojo->new(curfile->sibling('app.pl'));

# sample(tests)
$t->get_ok('/')
  ->status_is(200)
  ->content_type_like(qr'application/json')
  ->json_is({hello => '🌐!'})
  ->json_is('/hello' => '🌐!');

$t->get_ok('/R2-D2')
  ->status_is(200)
  ->content_type_like(qr'application/json')
  ->json_is('/hello' => 'R2-D2!');
# end-sample

done_testing;

