#!/usr/bin/env perl

use strict;
use warnings;

BEGIN {
	push @INC, './lib';
}

use Game;

my $game = new Game();
$game->loop();
