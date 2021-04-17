#!/usr/bin/env perl

=pod
TODO:
- load campagin from command line
=cut

use strict;
use warnings;

BEGIN {
	push @INC, ('./lib', './campaigns');
}

use Game;

my $game = new Game();
$game->loop();
