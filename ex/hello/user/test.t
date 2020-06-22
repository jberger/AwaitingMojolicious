use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Mojo::File 'curfile';

my $t = Test::Mojo->new(curfile->sibling('app.pl'));

# sample(tests)
$t->get_ok('/')
  ->status_is(200)
  ->content_type_like(qr'text/plain')
  ->content_is('Hello World!');

$t->get_ok('/Olaf')
  ->status_is(200)
  ->content_type_like(qr'text/plain')
  ->content_is('Hello Olaf!');
# end-sample

done_testing;

