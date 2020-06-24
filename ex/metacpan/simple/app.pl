use Mojolicious::Lite -signatures;

use Mojo::URL;

plugin Config => {
  default => {
    api => 'https://fastapi.metacpan.org/v1/',
  },
};

helper get_doc => sub ($c, $module) {
  my $url = $c->app->config->{api};
  $url .= "pod/$module";
  my $tx = $c->ua->get($url);
  return $tx->result->text;
};

get '/doc/:module' => sub ($c) {
  my $module = $c->stash('module');
  my $doc = $c->get_doc($module);
  $c->render(text => $doc);
};

app->start;


