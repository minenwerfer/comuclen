=pod
TODO:
- format stats output
- dynamically cast campaign class
=cut

use strict;
use warnings;

package Game;

use Jampa;
use Term::ANSIColor qw/color colored/;
use Term::ReadKey qw/ReadMode ReadKey/;

use constant SLEEP_TIME => 3.5;

sub new {
	my $class = shift;
	my $self = {
		player => new Jampa(),
	};

	bless $self, $class;
	return $self;
}

sub refresh {
	print "[J\033[H\033[J";
}

sub wait {
	print "[Prima qualquer tecla para proseguir]\n";
	getc STDIN;
}

sub horizontal_line {
	my ($self, $width, $char) = @_;
	$char = $char || '-'; 
	$width = $width || 50;

	return "$char"x$width ."\n";
}

sub string_pad {
	my ($self, $string, $width, $char) = @_;
	$char = $char || ' ';

	my $pad = $width - length $string;
	$pad = $pad > 0 ? $pad : 0;

	return $string . "$char"x$pad;
}

sub stats {
	my $self = shift;
	my %stats = %{$self->{player}->{stats}};

	print "Estatísticas: \n";
	print $self->horizontal_line();
	foreach (sort keys %stats) {
		my $stat = $stats{$_};
		my $amount = $stat->{amount};
		my $color = $amount > $stat->{low}
			? ($amount > $stat->{high} ? 'green': 'yellow')
			: 'red';

		print " @{[ucfirst($stat->{name})]}: ". colored($amount, "$color bold") ." ($stat->{multiplier}x)\n";
	}

	print $self->horizontal_line() ."\n";
}

sub choices {
	my $self = shift;
	my %choices = %{$self->{player}->{choices}};

	print "Comandos: \n";
	print $self->horizontal_line();
	foreach (sort keys %choices) {
		my $choice = $choices{$_};

		print
		" ". colored($self->string_pad("($choice->{key})", 5), 'bold green') .
		$self->string_pad($choice->{description}, 20) ."\n";
	}

	print $self->horizontal_line() ."\n";
}

sub loop {
	my $self = shift;

	$self->refresh();
	print $self->{player}->_lore();
	$self->wait();

	while (1) {
		$self->refresh();
		print colored("Rodada #$self->{player}->{round}", 'bold') ."\n";
		print colored($self->horizontal_line(11, '='), 'bold') ."\n";

		$self->stats();
		$self->choices();
		print colored('>Insira um comando: ', 'bold blue');

		ReadMode 0;
		$_ = ReadKey 0;
		if ( m/q/ ) {
			last;
		}

		ReadMode 3;
		while( defined(my $key = ReadKey -1) ){}

		my $result = $self->{player}->do($_);
		my $fortune_color = $result->{fortune}->{type} eq 'good' ? 'white' : 'red' if defined $result->{fortune}->{type};

		print colored($result->{match}, 'bold green') ."\n";
                print colored("> $result->{fortune}->{message} <", "bold $fortune_color") ."\n" if $result->{fortune}->{message};
		print colored("< $result->{message} >", 'bold magenta') ."\n";
		print "\n";

		if( $result->{value} ge 0 ) {
			$self->{player}->tick();
		}

		print "\n";
		$self->wait();

	}
}

1;
