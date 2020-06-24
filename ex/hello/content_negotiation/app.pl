use Mojolicious::Lite -signatures;

get '/:user' => { user => '🌐' } => sub ($c) {
  my $user = $c->stash->{user};
  $c->respond_to(
    txt  => {text => "Hello $user!"},
    html => {template => 'user'},
  );
};

app->start;

__DATA__

@@ user.html.ep
<div id="greeting">
  Hello <div id="user"><%= $user %>!</div>
</div>
