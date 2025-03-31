# cancella spazi ripetuti
s/\(.\) \+/\1 /g
# cancella spazi a fine riga
s/ \+$//
# cancella spazi a inizio riga
s/ \+\([^0-9A-Za-zèÈ`\\( -]\)/\1/g
# raddrizza vari tipi di virgolette
s/[’‘]/'/g
s/“/``/g
s/”/''/g
s/"\([^"]*\)"/``\1''/g
# standardizza i puntini di sospensione
s/…/\\dots/g
s/\.\.\./\\dots/g
# standardizza e accentata maiuscola
s/E'/È/g
