#!/usr/bin/env perl

use Mojolicious::Lite -signatures;

use Mojo::ByteStream 'b';

app->static->paths(['.']);

plugin 'RevealJS';
plugin 'AutoReload';

helper section_group => sub {
  my ($c, $transition, @sections) = @_;
  my @out;
  for my $section (@sections) {
    my @class;
    push @class, "$transition-in"  unless $section eq $sections[0];
    push @class, "$transition-out" unless $section eq $sections[-1];
    push @out, $c->t(section =>  ('data-transition' => join(' ', @class)), $section);
  }
  return b join("\n", @out);
};

hook 'before_dispatch' => sub ($c) {
  $c->res->headers->cache_control('must-revalidate');
};

any '/' => {
  template => 'index',
  layout => 'revealjs',
  init => {
    # just a little wider, default height
    height => 700,
    width => 1000,
    sampler => { removeIndentation => \1 },
  },
};

app->start;

