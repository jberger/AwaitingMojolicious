#!/usr/bin/env perl

use Mojolicious::Lite;

app->static->paths(['.']);

plugin 'RevealJS';
plugin 'AutoReload';

any '/' => {
  template => 'index',
  layout => 'revealjs',
  init => {
    sampler => { removeIndentation => \1 },
  },
};

app->start;

