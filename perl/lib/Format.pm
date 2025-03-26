#!/usr/bin/perl -w 

package Format;

# Recebe dois argumentos: o tipo de regex (separação de versículo ou separação de notas) a ser aplicada e o texto a ser formatado;
sub notes {
    my @notes = ();
    my $note = "";
    my $notes = "";
    foreach my $line (split(/\w+\n/, "@_")){
        $note = $note . $line;
        # Remove quebras de linhas
        chomp $note;
        # Adiciona ao array de notas
        push @notes, $note;
        $note = "";
    }
    $notes = "@notes";
    # Remove espaços no início das linhas
    $notes =~ s/^\s+//gm;
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
    return $verses;
}

1;