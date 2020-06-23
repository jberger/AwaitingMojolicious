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
  <a href="https://metacpan.org/pod/OtherMod">OtherMod</a>               <!-- / highlight fix -->
END

# sample(dist) skip-sample
$mock->routes->get('/module/MyModule' => {json => {
  distribution => 'MyMods',
}});
# end-sample skip-sample

# sample(fav) skip-sample
$mock->routes->get('/favorite/_search' => sub ($c) {
  return $c->reply->not_found
    unless $c->param('q') eq 'distribution:MyMods';
  $c->render(json => { hits => { total => 123 } });
});
# end-sample skip-sample

$t->app->ua->server->app($mock);
$t->app->config->{api} = '/';

$t->get_ok('/doc/MyModule')
  ->status_is(200)
  ->text_is('h1#NAME' => 'MyModule')
  ->element_exists('a[href="/doc/OtherMod"]')
  ->element_exists_not('a[href^="https://metacpan.org/pod"]')
  ->text_like('h1#NAME + p + h1#DISTRIBUTION + p', qr'MyMods.*123++');

done_testing;

