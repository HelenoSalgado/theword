#!/usr/bin/perl -w 

use v5.30;
use strict;
use warnings;
use diagnostics;
use Cwd;

# Esse script deve atualizar a versificação de cada capítulo dos livros
# Recebe como argumento o nome do livro ex: Mateus;

my $Book_Name = $ARGV[0];
my $dir_base_books = getcwd . "/books/";
my $dir_base_books_modules = getcwd . "/modules/bible/f35/";

# Verifica o nome do livro foi passado
if (not defined $Book_Name) {
  print "Error: é preciso passar o nome do livro.\n";
  exit;
}

my $file_verses_ref_name = getcwd . "/perl/table-verses";
my $file_book_name = $dir_base_books . lc($Book_Name) . ".nt";

# Abre arquivo com o número de versos em cada capítulo
open (my $file_verses_ref, $file_verses_ref_name);
# Copia texto para array
my @verses_ref = <$file_verses_ref>;
# Abre livro de bíblia
open (my $file_book, $file_book_name);

my $verses_ref = "@verses_ref";

# Fecha arquivo de referências
close $file_verses_ref or die "Erro ao fechar arquivo de referências: $!";

# Inicia array de capitulos e versículos do livro
my @verses_book_ref = ();

# Se o livro não for encontrado no arquivo de referências, então para execução
if (not $verses_ref =~ /$Book_Name/){
   print "Livro não foi encontrado na tabela de referências\n";
   exit;
}

# Soma a quantidade de versículos do livro que foi passado como argumento
while($verses_ref =~ /($Book_Name\t+(\d+)\t+(\d+))/g){
   for(my $i = 1; $i <= $3; $i++){
     push @verses_book_ref, "$2:$i ";
   }
}

# Cria novo livro com nomenclatura abreviada
my $abrev = lc($Book_Name);
if($abrev eq "mateus"){
   $abrev = "Mt";
}elsif($abrev eq "marcos"){
   $abrev = "Mc";
}elsif($abrev eq "lucas"){
   $abrev = "Lc";
}
elsif($abrev eq "joão"){
   $abrev = "Jo";
}

open (my $abrev_book, ">", "$dir_base_books_modules$abrev.nt");

# Para cada linha do livro uma referência de capitulo/versículo será adicionada no início da linha
# Conta index do verso no array
my $index = 0;
while(<$file_book>){
   my $line = $_;
   # Verifica se já existe referência, se sim, pula a linha
   if(not $line =~ /\w{2}-\d+:\d+/){
       # Adiciona ref no início da linha
       $line =~ s/^/$verses_book_ref[$index] /;
   }
   print $abrev_book $line;
   $index++;
}

# Fecha livro
close $abrev_book or die "Erro ao fechar livro";