use Mojo::Base -strict;

use Mojolicious;
use Test::More;
use Test::Mojo;

use FindBin '$Bin';
require "$Bin/app.pl";

my $t = Test::Mojo->new;

my $mock = Mojolicious->new;
$mock->routes->get('/pod/MyModule' => {text => <<'END'});
  <h1 id="NAME">MyModule</h1>
  <p>My Test Module</p>
END

$t->app->config->{api} = '/';
$t->app->ua->server->app($mock);

$t->get_ok('/doc/MyModule')
  ->status_is(200)
  ->text_is('h1#NAME' => 'MyModule');

done_testing;

