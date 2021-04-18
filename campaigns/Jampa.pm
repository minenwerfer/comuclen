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

sub _lore {
	return <<EOF
Seu nome é André Jampa.

Você tem um inestimável espírito empreendedor e criativo, mas
o lugar onde você mora e sua atual situação financeira nunca
te permitiram alcançar o seu verdadeiro potencial.

Seu principal passatempo é malhar. É na academia que você encontra
a sua liberdade e redenção. Apesar do convívio social não ser muito
do seu agrado, você tenta simplesmente ignorar as pessoas ao seu redor
e se concentrar no treino. Nada melhor para o espírito do que a exaustão
física.

Quando não está erguendo pesos nem trabalhando, você está se empenhando
em manter um canal no YouTube. Para alimentá-lo, você perscruta a vida
de políticos e pessoas públicas procurando coisas erradas para denunciar.
Quanto mais você estuda, mais se torna apto a repassar a sua mensagem e alcançar
pessoas. A remuneração no entanto é quase inexistente.

EOF
}

sub _stats {
	return {
		luck => {
			name => 'sorte',
			multiplier => 1,
			amount => 0,
			low => 2,
			high => 10,
		},
		histamine => {
			name => 'histamina',
			multiplier => 1,
			amount => 50,
			low => 50,
			high => 200,
		},
		food => {
			name => 'caloria',
			multiplier => 1,
			amount => 3000,
			low => 3000,
			high => 20000,
		},
		money => {
			name => 'dinheiro',
			multiplier => 1,
			amount => 50,
			low => 20000,
			high => 500000,
		},
		knowledge => {
			name => 'conhecimento',
			multiplier => 1,
			amount => 0,
			low => 100,
			high => 130,
		}
	};
}

sub _choices {
	return {
		eat => {
			key => 'e',
			description => 'Ingerir calorias',
			provides => {
				food => 1100,
				histamine => 30,
			},
			costs => {
				money => 10,
			},
			func => sub {
				my $self = shift;

				if( int(rand(15)) % 5 == 0 ) {
					$self->{stats}->{food}->{amount} = int($self->{stats}->{food}->{amount} / 2);

					return {
						type => 'bad',
						message => 'A comida estava estragada e você sofreu uma violenta diarréia. Você 50% perde das suas calorias.',
					};
				}

				my @messages = (
					'Ovos capoeira sempre são uma boa pedida',
					'O abate do frango foi trabalhoso, mas rendeu um delicioso assado',
					'A macaxeira teria ficado boa se tivesse algum sal',
					'Uma longa jornada de trabalho pede um açaí',
				);

				return {
					type => 'good',
					message => $messages[rand($#messages + 1)],
				};
			}
		},
		work => {
			key => 'w',
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
			key => 'c',
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
                                my @messages = (
                                        "$self->{sname} fez um curso",
                                        "$self->{sname} participou de uma conferência internacional",
                                        "$self->{sname} foi convidado para ser fellow na universidade de Harvard"
                                );

                                return {
					type => 'good',
					message => $messages[int(rand($#messages + 1))]
				};
                        }
		},
		workout => {
			key => 'm',
			description => 'Fazer musculação',
			provides => {
				histamine => 50,
			},
			costs => {
				food => 1000,
			},
			func => sub {
				my $self = shift;
				
				my @messages = (
					'"Minha pose sex está cada vez mais incrível!"',
					'Você está realmente ficando com um ótimo shape',
					'Sua rotina de treino está cada vez mais gratificante',
					'Você acidentalmente deu uma cambalhota enquanto fazia supino inclinado. Apesar de ter provocado boas risadas, você por sorte não se feriu',
				);
				
				return {
					type => 'good',
					message => $messages[int(rand($#messages + 1))]
				};
			}
		}
	};
}

sub _tick {
	print "Tick!\n";
}

1;
