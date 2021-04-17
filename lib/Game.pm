=pod
TODO:
- format stats output
- format input prompt
- dynamically cast campaign class
=cut


use strict;
use warnings;
use Jampa;

package Game;

sub new {
	my $class = shift;
	my $self = {
		player => new Jampa(),
		last_value => 0,,
	};

	bless $self, $class;
	return $self;
}

sub stats {
	my $self = shift;
	my %stats = %{$self->{player}->{stats}};

	foreach my $key (keys %stats) {
		my $stat = $stats{$key};
		print "@{[ucfirst($stat->{name})]}: $stat->{amount} ($stat->{multiplier}x)\n";
	}
}

sub loop {
	my $self = shift;
	while (<>) {
		chomp;

		if( $self->{last_value} ge 0 ) {
			$self->stats();
			$self->{player}->tick();
		}

		my $result = $self->{player}->do($_);
                print "$result->{fortune}\n" if $result->{fortune};
		print "$result->{message}\n";

		$self->{last_value} = $result->{value};
	}
}

1;
