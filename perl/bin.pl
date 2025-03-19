#!/usr/bin/perl -w 

use v5.30;
use strict;
use warnings;
use diagnostics;
use Cwd;

# Resgata caminho do diretório atual
my $dir = getcwd;

# Abre o arquivo original
open(FILE, "$dir/input.txt") or die "Erro ao abrir o arquivo: $!";

# Copia todas as linhas para um array de conteúdo
my @content = <FILE>;

# Adiciona array de conteúdo à variável $text
my $text = "@content";

# Remove quebras de linhas
$text =~ s/\n//gms;

# Coloca o texto de cada versículo numa nova linha
$text =~ s/\d/\n/gms;

# Remove linhas vazias
$text =~ s/^\s+//gms;

# Abre o arquivo destino
open(OUTFILE, ">$dir/live-edite.txt") or die "Erro ao criar o arquivo de destino: $!";

# Escreve o conteúdo formatado no arquivo de destino
print OUTFILE $text;

# Fecha os arquivos
close(FILE);
close(OUTFILE);