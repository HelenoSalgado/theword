#!/usr/bin/perl -w 

use v5.30;
use strict;
use warnings;
use diagnostics;
use Cwd;
use FindBin::libs;
use Term::ANSIColor qw(:constants);
use Format;
use Merge;

# Define caminhos de arquivos
my $file_input_notes = getcwd . "/input-notes.txt";
my $file_input_verses = getcwd . "/input-verses.txt";
my $file_merged = getcwd . "/merged.txt";
my $file_edit_verses = getcwd . "/edit-verses.txt";
my $file_edit_notes = getcwd . "/edit-notes.txt";

# Abre os arquivo para uso
open(my $input_notes, $file_input_notes) or die "Erro ao abrir arquivo: $!";
open(my $input_verses, $file_input_verses) or die "Erro ao abrir arquivo: $!";
open(my $merged, ">", $file_merged) or die "Erro ao abrir arquivo: $!";

# Executa função de formatação de textos (versos e notas)
my $verses = Format::verses(<$input_verses>);
my $notes = Format::notes(<$input_notes>);

# Se edit-verses não existir, então cria e grava
if(! -f $file_edit_verses){
    # Caso não exista, cria e abre para gravação.
    open(my $edit_verses, ">", $file_edit_verses) or die "Erro ao abrir arquivo: $!";
    print $edit_verses $verses;
    # Fecha o arquivo e espera entrada do usuário
    close $edit_verses or die "Erro ao fechar arquivo: $!";
}elsif($file_edit_verses){
    open(my $edit_verses, "+<", $file_edit_verses) or die "Erro ao abrir arquivo: $!";
    my @content = <$edit_verses>;
    if(@content eq 0){
        print $edit_verses $verses;
    }
    close $edit_verses or die "Erro ao fechar arquivo: $!";
}

# Se edit-notes não existir, então cria e grava
if(! -f $file_edit_notes){
    # Caso não exista, cria e abre para gravação.
    open(my $edit_notes, ">", $file_edit_notes) or die "Erro ao abrir arquivo: $!";
    print $edit_notes $notes;
    # Fecha o arquivo e espera entrada do usuário
    close $edit_notes or die "Erro ao fechar arquivo: $!";
}elsif(-f $file_edit_notes){
    open(my $edit_notes, "+<", $file_edit_notes) or die "Erro ao abrir arquivo: $!";
    my @content = <$edit_notes>;
    if(@content eq 0){
        print $edit_notes $notes;
    }
    close $edit_notes or die "Erro ao fechar arquivo: $!";
}

# Pede uma ação do usuário antes de continuar fluxo de execução
print "\n", RED, "[AVISE] " . "\n* Coloque um asterísco em cada referência de nota; \n* Edite títulos e subtítulos; \n* Depois aperte enter para continuar:", RESET "\n";

# Trava a execução para que as alterações possam ser feitas, depois enter para continuar.
my $void = <STDIN>;

# Abre arquivo edit-verses.txt novamente e resgata texto editado
open(my $edit_verses, $file_edit_verses) or die "Erro ao abrir arquivo: $!";

# Abre arquivo edit-notes.txt novamente e resgata texto editado
open(my $edit_notes, $file_edit_notes) or die "Erro ao abrir arquivo: $!";

# Merge notas ao texto editado (aos versículos)
my @edit_verses = <$edit_verses>;
my @edit_notes = <$edit_notes>;

my $merged_result = Merge::content("@edit_verses", "@edit_notes");

# Copia texto mergeado para o arquivo merged-text.txt
print $merged $merged_result;

# Fecha todos os arquivos abertos anteriormente
close $input_notes or die "Erro ao fechar arquivo: $!";
close $input_verses or die "Erro ao fechar arquivo: $!";
close $edit_verses or die "Erro ao fechar arquivo: $!";
close $edit_notes or die "Erro ao fechar arquivo: $!";
close $merged or die "Erro ao fechar arquivo: $!";

# Sucesso da operação
print GREEN, "[FINALY] " . BOLD, "Sucess." , RESET . "\n\n";