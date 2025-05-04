#!/usr/bin/perl -w 

package Merge;
use Cwd;

my $Book_Name = $ARGV[0];
# Verifica o nome do livro foi passado
if (not defined $Book_Name) {
  print "Error: é preciso passar o nome do livro para extração do número da última nota.\n";
  exit;
}
# Tranforma caracters para minúsculo
my $book = lc($Book_Name);

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
  my $verses = $_[0];
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

1;