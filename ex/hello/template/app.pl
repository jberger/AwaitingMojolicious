use Mojolicious::Lite -signatures;

get '/:user' => { user => '🌐' } => sub ($c) {
  $c->render(template => 'user');
};

app->start;

__DATA__

@@ user.html.ep
<div id="greeting">
  Hello <div class="user"><%= $user %></div>!
</div>
