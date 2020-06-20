use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

use FindBin '$Bin';
require "$Bin/app.pl";

my $t = Test::Mojo->new;

# sample(tests)
$t->get_ok('/')
  ->status_is(200)
  ->content_type_like(qr'text/html')
  ->text_is('#greeting #user' => 'World');

$t->get_ok('/Mickey')
  ->status_is(200)
  ->content_type_like(qr'text/html')
  ->text_is('#greeting #user' => 'Mickey');
# end-sample

done_testing;

