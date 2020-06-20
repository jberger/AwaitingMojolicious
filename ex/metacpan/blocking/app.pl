use Mojolicious::Lite -signatures;

use Mojo::URL;

plugin Config => {
  default => {
    api => 'https://fastapi.metacpan.org/v1',
  },
};

helper api_url => sub ($c) {
  return Mojo::URL->new($c->app->config->{api});
};

helper get_doc => sub ($c, $module) {
  my $url = $c->api_url;
  push @{$url->path}, 'pod', $module;
  my $tx = $c->ua->get($url);
  return $tx->result->dom;
};

helper get_dist => sub ($c, $module) {
  my $url = $c->api_url;
  push @{$url->path}, 'module', $module;
  my $tx = $c->ua->get($url);
  return $tx->result->json('/distribution');
};

helper get_favorites => sub ($c, $dist) {
  my $url = $c->api_url;
  push @{$url->path}, 'favorite', '_search';
  $url->query(q => "distribution:$dist");
  my $tx = $c->ua->get($url);
  return $tx->result->json('/hits/total');
};

helper munge_links => sub ($c, $dom) {
  $dom->find('a[href^="https://metacpan.org/pod/"]')->each(sub {
    my $module = Mojo::URL->new($_->{href})->path->parts->[-1];
    $_->{href} = $c->url_for('doc',  module => $module);
  });
  return $dom;
};

helper inject_dist => sub ($c, $dom, $dist, $faves) {
  my $html = $c->render_to_string(
    template => 'dist',
    dist => $dist,
    faves => $faves,
  );
  $dom->at('h1#SYNOPSIS')->prepend($html);
  return $dom;
};

get '/doc/:module' => sub ($c) {
  my $module = $c->stash('module');
  my $doc = $c->get_doc($module);
  $doc = $c->munge_links($doc);
  my $dist = $c->get_dist($module);
  my $faves = $c->get_favorites($dist);
  $doc = $c->inject_dist($doc, $dist, $faves);
  $c->render(text => $doc);
} => 'doc';

app->start;

__DATA__

@@ dist.html.ep
<h1 id="DISTRIBUTION">DISTRIBUTION</h1>
<p><%= $dist %> (<%= $faves %>++ on <a href="https://metacpan.org">MetaCPAN</a>)</p>
