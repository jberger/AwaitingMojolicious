use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

use FindBin '$Bin';
require "$Bin/app.pl";

my $t = Test::Mojo->new;

$t->get_ok('/')
  ->status_is(200)
  ->content_is('Hello World!');

done_testing;

