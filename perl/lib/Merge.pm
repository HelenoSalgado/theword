#!/usr/bin/perl -w 

package Merge;
use Cwd;

my $file_number_note = getcwd . "/perl/lib/number-note.log";
my $count = undef;

# Abre o arquivo de log e recupera numeração atual de notas
open(my $number_note, $file_number_note) or die "Erro ao abrir log: $!";

# Copia número para o contador
$count = <$number_note>;

# Fecha log
close $number_note or die "Erro ao fechar arquivo: $!";

sub content {
  my $verses = $_[0];
  my $notes = $_[1];
  foreach my $line (split('\n', $notes)){
    # Insere linha de nota no lugar do primeiro (*) encontrado
    $verses =~ s/\*/<RF q=$count>$line<Rf>/s;
    # Intera o número de notas
    $count++;
  }
  # Abre o arquivo de log para gravar numeração atual de notas
  open(my $number_note, ">", $file_number_note) or die "Erro ao abrir log: $!";
  # Grava numeração atual de notas no log
  print $number_note $count;
  # Fecha log
  close $number_note or die "Erro ao fechar arquivo: $!";
  # Remove espaços no início das linhas
  $verses =~ s/^\s+//gm;
  return $verses;
}

1;