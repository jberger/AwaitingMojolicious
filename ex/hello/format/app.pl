use Mojolicious::Lite;

get '/' => {
  text => 'Hello 🌐!',
  format => 'txt',
};

app->start;

