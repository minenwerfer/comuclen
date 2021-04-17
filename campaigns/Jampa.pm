use strict;
use warnings;

package Jampa;
use parent 'Player';

sub new {
	my $class = shift;
	my $self = $class->SUPER::new('Andre Jampa');

	bless $self, $class;
	return $self;
	
}

sub _stats {
	return {
		luck => {
			name => 'sorte',
			multiplier => 1,
			amount => 0,
		},
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
			},
                        func => sub {
                                my $self = shift;
                                my @fortune = (
                                        "$self->{sname} fez um curso",
                                        "$self->{sname} participou de uma conferência internacional",
                                        "$self->{sname} foi convidado para ser fellow na universidade de Harvard"
                                );

                                return $fortune[int(rand($#fortune))];
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

sub _tick {
	print "Tick!\n";
}

1;
