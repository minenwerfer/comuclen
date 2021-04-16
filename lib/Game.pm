use strict;
use warnings;
use Jampa;

package Game;

sub new {
	my $class = shift;
	my $self = {
		player => new Jampa(),
		round => 0,
	};

	bless $self, $class;
	return $self;
}

sub stats {
	return;
}

sub loop {
	my $self = shift;
	while (<>) {
		# $self->{player}->tick();
		my $result = $self->{player}->do('career');
		print "$result->{message}\n";

		$self->{round}++;
	}
}

1;
