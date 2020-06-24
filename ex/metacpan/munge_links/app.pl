use Mojolicious::Lite -signatures;

use Mojo::URL;

plugin Config => {
  default => {
    api => 'https://fastapi.metacpan.org/v1/',
  },
};

helper api_url => sub ($c) {
  return Mojo::URL->new($c->app->config->{api});
};

# sample(doc) skip-sample
helper get_doc => sub ($c, $module) {
  my $url = $c->api_url;
  push @{$url->path}, 'pod', $module;
  my $tx = $c->ua->get($url);
  return $tx->result->dom;
};

# end-sample skip-sample
# sample(munge) skip-sample
helper munge_links => sub ($c, $dom) {
  $dom->find('a[href^="https://metacpan.org/pod/"]')->each(sub {
    my $module = Mojo::URL->new($_->{href})->path->parts->[-1];
    $_->{href} = $c->url_for('doc',  module => $module);
  });
  return $dom;
};
# end-sample skip-sample

# sample(doc) skip-sample
get '/doc/:module' => sub ($c) {
  my $module = $c->stash('module');
  my $doc = $c->get_doc($module);
  $doc = $c->munge_links($doc);
  $c->render(text => $doc);
} => 'doc';
# end-sample skip-sample

app->start;


