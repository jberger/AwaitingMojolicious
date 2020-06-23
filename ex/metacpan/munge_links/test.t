use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Mojo::File 'curfile';
use Mojolicious;

my $t = Test::Mojo->new(curfile->sibling('app.pl'));

my $mock = Mojolicious->new;
# sample(test)
$mock->routes->get('/pod/MyModule' => {text => <<'END'});
  <h1 id="NAME">MyModule</h1>
  <p>My Test Module</p>
  <a href="https://metacpan.org/pod/OtherMod">OtherMod</a>               <!-- / highlight fix -->
END
# end-sample

$t->app->ua->server->app($mock);
$t->app->config->{api} = '/';

# sample(test)
# ...

$t->get_ok('/doc/MyModule')
  ->status_is(200)
  ->text_is('h1#NAME' => 'MyModule')
  ->element_exists('a[href="/doc/OtherMod"]')
  ->element_exists_not('a[href^="https://metacpan.org/pod"]');
# end-sample

done_testing;

