# raddrizza vari tipi di virgolette
s/``/<</g
s/[’‘]/'/g
s/''/>>/g
s/“/<</g
s/”/>>/g
s/"\([^"]*\)"/<<\1>>/g
s/«/<</g
s/»/>>/g
# sistemare le citazioni dentro le citazioni
s/\(<<[^>]*\)<<\(.*\)>>\([^<]*>>\)/\1``\2''\3/
# standardizza i puntini di sospensione
s/…/\\ldots/g
s/\.\.\./\\ldots/g
s/\\ldots /\\ldots\ /g
# standardizza e accentata maiuscola
s/E'/È/g
# cancella spazi ripetuti
s/\(.\) \+/\1 /g
# cancella spazi a fine riga
s/ \+$//
# cancella spazi a inizio riga
s/^ \+\([^0-9A-Za-zèÈ`'<\\( -]\)/\1/g
