#!/usr/bin/perl -w 

package Merge;
use Cwd;

my $file_module_f35 = getcwd . "/modules/bible/f35/F35.nt";
my $count = undef;

# Abre o arquivo de módulo principal (f35.nt) e recupera numeração atual de notas
open(my $module_f35, $file_module_f35) or die "Erro ao abrir módulo principal: $!";
# Copia linhas para array
my @module_f35 = <$module_f35>;
# Pega número de nota a partir do final do texto que foi invertido
my $number_note = $1 if reverse("@module_f35") =~ />(\d+)=q FR</;
# Inverte número para a ordem normal e copia-o para o contador
$count = reverse($number_note);
# Fecha módulo principal
close $module_f35 or die "Erro ao fechar arquivo: $!";

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