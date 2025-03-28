#!/usr/bin/perl -w 

package Format;

# Recebe dois argumentos: o tipo de regex (separação de versículo ou separação de notas) a ser aplicada e o texto a ser formatado;
sub notes {
    my $note = "";
    my @notes = ();
    for my $line(@_){
       # Remove quebra de linha
       $line =~ s/\n$//;
       # Deixa passar todas as linhas que não são uma referência (a, b, c etc..)
       if($line =~ /[^\^\w+\$].*\n?.*\n?$/){
         # Concatena na variável $note as linhas selecionadas
         $note = $note . " $line";
       }else{
         # Se a linha contiver um único caracter, então a variável $note deve ser adicionada ao array de notas @notes
         if($note ne ""){
            # Remove espaço do início das linhas
            $note =~ s/^\s{1,}//g;
            push @notes, "$note\n";
            # Esvazia $note
            $note = "";
         }
       }
    }
    return "@notes";
}

sub verses {
    my $verses = "@_";
    # Remove quebras de linhas
    $verses =~ s/\n//g;
    # Remove espaço duplo por um
    $verses =~ s/\s{2}/ /g;
    # Coloca cada versículo numa linha
    $verses =~ s/\d/\n/gm;
    # Remove linhas vazias
    $verses =~ s/^\s//gm;
    return $verses;
}

1;