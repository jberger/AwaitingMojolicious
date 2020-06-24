use Mojolicious::Lite -signatures;

get '/:user' => { user => '🌐' } => sub ($c) {
  my $user = $c->stash->{user};
  $c->render(text => "Hello $user!", format => 'txt');
};

app->start;

