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
my $file_live_edit = getcwd . "/live-edit.txt";

my $live_edit = undef;

# Abre os arquivo para uso
open(my $input_notes, $file_input_notes) or die "Erro ao abrir arquivo: $!";
open(my $input_verses, $file_input_verses) or die "Erro ao abrir arquivo: $!";
open(my $merged, ">", $file_merged) or die "Erro ao abrir arquivo: $!";

# Executa função de formatação de textos (versos e notas)
my $verses = Format::verses(<$input_verses>);
my $notes = Format::notes(<$input_notes>);

# Se live-edit não existir, então cria e grava
if(! -f $file_live_edit){
    # Caso não exista, cria e abre para gravação.
    open($live_edit, ">", $file_live_edit) or die "Erro ao abrir arquivo: $!";
    print $live_edit $verses;
    # Fecha o arquivo e espera entrada do usuário
    close $live_edit or die "Erro ao fechar arquivo: $!";
}



# Pede uma ação do usuário antes de continuar fluxo de execução
print "\n", RED, "[AVISE] " . "\n* Coloque um asterísco em cada referência de nota; \n* Edite títulos e subtítulos; \n* Depois aperte enter para continuar:", RESET "\n";
my $void = <>;

# Abre arquivo live-edit.txt novamente e resgata texto editado
open(my $live_edit_, $file_live_edit) or die "Erro ao abrir arquivo: $!";

# Merge notas ao texto editado (aos versículos)
my @merge_edit = <$live_edit_>;

my $merged_result = Merge::content("@merge_edit", $notes);

# Copia texto mergeado para o arquivo merged-text.txt
print $merged $merged_result;

# Fecha todos os arquivos abertos anteriormente
close $merged or die "Erro ao fechar arquivo: $!";
close $input_notes or die "Erro ao fechar arquivo: $!";
close $input_verses or die "Erro ao fechar arquivo: $!";
close $live_edit_ or die "Erro ao fechar arquivo: $!";

# Sucesso da operação
print GREEN, "[FINALY] " . BOLD, "Sucess." , RESET . "\n\n";