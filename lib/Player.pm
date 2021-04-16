use strict;
use warnings;

package Player;

sub new {
	my $class = shift;
	my $self = {};

	bless $self, $class;
	return $self;
}

sub tick {
	my $self = shift;
	print $self->{name};
}

sub do {
	my ($self, $action) = @_;
	my $choice = $self->{choices}->{$action};
	my @stats;

	if( $choice ) {
		foreach my $key (keys %{$choice->{costs}}) {
			my $value = $choice->{costs}->{$key};
			my %stat = %{$self->{stats}->{$key}};

			my $name = $stat{name};
			my $available = $stat{amount};
			my $required = $value;
			
			if ($available lt $required)  {
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

			$spent_str .= ' e ' if $i++ gt 0;
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
				$value = int($value);
				$stat->{amount} += $value;
			}

			$profit_str .= ' e ' if $i++ gt 0;
			$profit_str .= "$value de $name";
		}
	
		return {
			value => 0,
			message => "$self->{name} gastou $spent_str e ganhou $profit_str"
		};
	}
}

1;
