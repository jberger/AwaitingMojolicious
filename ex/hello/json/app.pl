use Mojolicious::Lite -signatures;

get '/:user' => { user => '🌐' } => sub ($c) {
  my $user = $c->stash->{user};
  $c->render(json => {hello => "$user!"});
};

app->start;

