#!/usr/bin/perl -w 

package Merge;
use Cwd;

my $Book_Name = $ARGV[0];
my $cap_verses = $ARGV[1];
# Verifica o nome do livro foi passado
if (not defined $Book_Name) {
  print "Error: é preciso passar o nome do livro para extração do número da última nota.\n";
  exit;
}
# Verifica o capítulo/versiculos foi passado como argumentos
if (not defined $cap_verses) {
  print "Error: é preciso passar o capítulo de referência.\n";
  exit;
}
# Tranforma caracters para minúsculo
my $book = Convert::abrev($Book_Name);

my $file_book_f35 = getcwd . "/modules/bible/f35/$book.nt";
my $count = undef;

# Abre o livro e recupera numeração atual de notas
open(my $book_f35, $file_book_f35) or die "Erro ao abrir módulo principal: $!";
# Copia linhas para array
my @book_f35 = <$book_f35>;
# Pega número de nota a partir do final do texto que foi invertido
my $number_note = $1 if reverse("@book_f35") =~ />(\d+)=q FR</;
# Inverte número para a ordem normal e copia-o para o contador
$count = reverse($number_note);
# Fecha arquivo de livro
close $book_f35 or die "Erro ao fechar arquivo: $!";

sub content {
  my $verses = versification($Book_Name, $cap_verses, $_[0]);
  my $notes = $_[1];
  foreach my $line (split('\n', $notes)){
    # Itera o número de notas
    $count++;
    # Remove espaços no início da linha de nota
    $line =~ s/^\s+//;
    # Insere linha de nota no lugar do primeiro (*) encontrado
    $verses =~ s/\*/<RF q=$count>$line<Rf>/s;
  }
  # Remove espaços no início das linhas dos versos
  $verses =~ s/^\s+//gm;
  return $verses;
}

# Coloca referência de versos de acordo com os parâmetros recebidos, ex: perl perl/index.pl Lc 4:1-7
# Quer dizer que o texto pertence a todo capítulo 4 de Lucas, então cada linha do texto receberá, no ínicio, o número de versículo referente.
sub versification {
  # Recebe nome do livro e capítulo/verso, ex: Lucas 4:1-7
  my ($Book_name, $cap_verses, $verses_text) = @_;
  # Copia capítulo para a variável $cap
  my $cap = $1 if $cap_verses =~ /(\d+):?/;
  # Copia versículos, se houver, para a variável $verse
  my $verses = $1 if $cap_verses =~ /:(\d+-\d+)/;
  # Se somente o capítulo foi passado, então abre arquivo de referência para buscar o número de versos do capítulo
  if( not defined $verses){
    # Abre arquivo com as referências
    open (my $file_verses, getcwd . "/perl/table-verses");
    # Copia texto para array
    my @verses_ref = <$file_verses>;
    my $verses_ref = "@verses_ref";
    # Se o livro não for encontrado no arquivo de referências, então para a execução
    if (not $verses_ref =~ /$Book_Name/){
      print "Livro não foi encontrado na tabela de referências\n";
      exit;
    }
    # Copia número de versos do capítulo para a variável $verses
    $verses = $1 if $verses_ref =~ /$Book_name\t+$cap\t+(\d+)/;
    # Fecha arquivo de referências
    close $file_verses or die "Erro ao fechar arquivo de referências: $!";
  }

  # Com a quantidade de versos definidos pelo total do capítulo ou pelo usuário, então injeta no início de cada linha do texto
  if(defined $verses){
    my $minIndex = undef;
    my $maxIndex = undef;
    if($verses =~ /(\d+)-(\d+)/){
      $minIndex = $1;
      $maxIndex = $2;
    }elsif($verses =~ /(\d+)/){
      $minIndex = 1;
      $maxIndex = $1;
    }

    # Reserva array para versos
    my @text_verses = ();
    while($verses_text =~ /(.*\n?)/g){
      push @text_verses, $1;
    }

    # Se $minIndex for maior que 1, então adiciona linha vazia até igualar a $minIndex
    if($minIndex > 1){
      for(my $i = 1; $i < $minIndex; $i++){
        unshift @text_verses, "\n";
      }
    }

    # Reserva array para referências
    my @cap_verses_ref = ();
    while($minIndex <= $maxIndex){
      push @cap_verses_ref, "$cap:$minIndex";
      # Coloca ref no final do título, se houver
      if($text_verses[$minIndex-1] =~ m/(<TS.>.*<Ts>)/){
        $text_verses[$minIndex-1] =~ s/(<TS.>.*<Ts>)/$1 $cap:$minIndex /;
      }else{
        $text_verses[$minIndex-1] =~ s/^/$cap:$minIndex /;
      }
      $minIndex++;
    }

    # Verifica se a quantidade de versículos corresponde a quantidade de referências pré-definidas
    if(not ($#text_verses - $minIndex) == $#cap_verses_ref+1){
      print "O número de versículos passado como parâmetro \nnão corresponde ao número de versículos do texto.\n\n";
      exit;
    }

    return "@text_verses";
    
  }

}

1;