use Mojolicious::Lite -signatures;

use Mojo::URL;

plugin Config => {
  default => {
    api => 'https://fastapi.metacpan.org/v1/',
  },
};

# sample(url)
helper api_url => sub ($c) {
  return Mojo::URL->new($c->app->config->{api});
};

helper get_doc => sub ($c, $module) {
  my $url = $c->api_url;
  push @{$url->path}, 'pod', $module;
  my $tx = $c->ua->get($url);
  return $tx->result->text;
};
# end-sample

get '/doc/:module' => sub ($c) {
  my $module = $c->stash('module');
  my $doc = $c->get_doc($module);
  $c->render(text => $doc);
};

app->start;


