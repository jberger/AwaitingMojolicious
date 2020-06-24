use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Mojo::File 'curfile';
use Mojolicious;

# sample(install) skip-sample
my $t = Test::Mojo->new(
  curfile->sibling('app.pl'),
  {api => '/'}, # config override!
);

# end-sample skip-sample
# sample(mock) skip-sample
my $mock = Mojolicious->new;
$mock->routes->get('/pod/MyModule' => {text => <<'END'});
  <h1 id="NAME">MyModule</h1>
  <p>My Test Module</p>
END
# end-sample skip-sample

# sample(install) skip-sample
$t->app->ua->server->app($mock);
# end-sample skip-sample

$t->get_ok('/doc/MyModule')
  ->status_is(200)
  ->text_is('h1#NAME' => 'MyModule');

done_testing;

