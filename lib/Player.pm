=pod
TODO:
- find a way to order hashes
=cut

use strict;
use warnings;

package Player;

sub new {
	my ($class, $name) = @_;
        my $self = {};

        bless $self, $class;

        $self->{name} = $name;
        $self->{choices} = $self->_choices();
        $self->{stats} = $self->_stats(); 

	($self->{sname}) = split ' ', $name;

	return $self;
}

sub tick {
	my $self = shift;
	$self->{round} += 1;
	$self->_tick();
}

sub do {
	my ($self, $action) = @_;
	my $choice = $self->{choices}->{$action};
	my @stats;

	if( !$choice ) {
		return {
			value => -1,
		      	message => "Ação desconhecida"
		};
	}

	foreach my $key (keys %{$choice->{costs}}) {
		my $value = $choice->{costs}->{$key};
		my %stat = %{$self->{stats}->{$key}};

		my $name = $stat{name};
		my $available = int($stat{amount});
		my $required = int($value);

			if ($available < $required)  {
			return {
				value => -1,
				message => "@{[ucfirst($name)]} insuficiente. Necessário: $required, disponível: $available"
			};
		}

		$stat{key} = $key;
		$stat{cost} = $required;
		push @stats, \%stat;
	}

	my $spent_str = '';
	my $profit_str = '';
	my $i = 0;
	foreach my $stat (@stats) {
		my $key = $stat->{key};
		my $name = $stat->{name};
		my $cost = $stat->{cost};

		$self->{stats}->{$key}->{amount} -= $cost;

		$spent_str .= ' e ' if $i++ > 0;
		$spent_str .= "$cost de $name" ;

	} $i = 0;

	foreach my $key (keys %{$choice->{provides}}) {
		$_ = $key;
		my $multiplier = 0;

		if ( m/_multiplier/ ) {
			($key) = split '_';
			$multiplier = 1;
		}

		my $value = rand($choice->{provides}->{$_});
		my $stat = $self->{stats}->{$key};
		my $name = $stat->{name};

		$name = "multiplicador de $name" if $multiplier;

		if ($multiplier) {
			$value = int(1000*$value)/1000;
			$stat->{multiplier} += $value;
		} else {
			$value = int($value * $stat->{multiplier});
			$stat->{amount} += $value;
		}

		$profit_str .= ' e ' if $i++ > 0;
		$profit_str .= "$value de $name";
	}


	my $fortune = $choice->{func}
		? $choice->{func}($self)
		: 0;

	return {
		value => 0,
		      message => "$self->{name} gastou $spent_str e ganhou $profit_str",
		      fortune => $fortune
	};
}

1;
