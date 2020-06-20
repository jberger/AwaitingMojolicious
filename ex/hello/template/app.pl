use Mojolicious::Lite -signatures;

get '/:user' => { user => 'World' } => sub ($c) { 
  $c->render(template => 'user');
};

app->start;

__DATA__

@@ user.html.ep
<div id="greeting">
  Hello <div id="user"><%= $user %></div>!
</div>
