#!/usr/bin/perl -w 

package Format;

# Recebe o array de notas a ser formatadas;
sub notes {
    my $notes = "@_";
    my @notes = ();
    # Itera sobre cada bloco de texto, o delimitador de cada bloco é a linha que contém uma única letra
    foreach(split(/\b[a-z]{1}\b\n/, $notes)){
      # Verifica se a nota não está vazia
      if($_){
        my $note = $_;
        # Remove quebras de linhas
        $note =~ s/\n//g;
        # Adiciona ao array de notas
        push @notes, "$note\n";
      }
    }
    $notes = "@notes";
    # Remove espaços no início e no final das linhas
    $notes =~ s/^\s+|\s+$//gm;
    # Retorna buffer de notas
    return $notes;
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
    # Retorna buffer de versículos
    return $verses;
}

1;