use strict;
use warnings;

package Jampa;
use parent 'Player';

sub new {
	my $class = shift;
	my $self = $class->SUPER::new();

	$self->{name} = 'Andre Jampa';
	$self->{choices} = $self->_choices();
	$self->{stats} = $self->_stats();

	bless $self, $class;
	return $self;
	
}

sub _stats {
	return {
		histamine => {
			name => 'histamina',
			multiplier => 1,
			amount => 50,
		},
		food => {
			name => 'caloria',
			multiplier => 1,
			amount => 3000,
		},
		money => {
			name => 'dinheiro',
			multiplier => 1,
			amount => 50,
		},
		knowledge => {
			name => 'conhecimento',
			multiplier => 1,
			amount => 50
		}
	};
}

sub _choices {
	return {
		eat => {
			description => 'Ingerir calorias',
			provides => {
				food => 1100,
				histamine => 30,
			},
			costs => {
				money => 10,
			}
		},
		work => {
			description => 'Trabalhar como moto taxista',
			provides => {
				money => 200,
				knowledge => 10,
			},
			costs => {
				histamine => 20,
			}
		},
		career => {
			description => 'Investir na carreira profissional',
			provides => {
				money_multiplier => .3,
				knowledge => 15,
			},
			costs => {
				histamine => 50
			}
		},
		workout => {
			description => 'Fazer musculação',
			provides => {
				histamine => 50,
			},
			costs => {
				food => 1000,
			}
		}
	};
}

1;
