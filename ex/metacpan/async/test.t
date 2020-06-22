use Mojo::Base -strict, -signatures;

use Test::More;
use Test::Mojo;
use Mojo::File 'curfile';
use Mojolicious;

my $t = Test::Mojo->new(curfile->sibling('app.pl'));

my $mock = Mojolicious->new;
$mock->routes->get('/pod/MyModule' => {text => <<'END'});
  <h1 id="NAME">MyModule</h1>
  <p>My Test Module</p>
  <a href="https://metacpan.org/pod/OtherMod">OtherMod</a>
END

$mock->routes->get('/module/MyModule' => {json => {
  distribution => 'MyMods',
}});

$mock->routes->get('/favorite/_search' => sub ($c) {
  return $c->reply->not_found
    unless $c->param('q') eq 'distribution:MyMods';
  $c->render(json => { hits => { total => 123 } });
});

$t->app->ua->server->app($mock);
$t->app->config->{api} = '/';

$t->get_ok('/doc/MyModule')
  ->status_is(200)->or(sub{ diag $t->tx->res->dom->at('#error') })
  ->text_is('h1#NAME' => 'MyModule')
  ->element_exists('a[href="/doc/OtherMod"]')
  ->element_exists_not('a[href^="https://metacpan.org/pod"]')
  ->text_like('h1#NAME + p + h1#DISTRIBUTION + p', qr'MyMods.*123++');

done_testing;

