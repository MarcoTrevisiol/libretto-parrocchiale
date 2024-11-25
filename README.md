# Libretto parrocchiale


## Per realizzare una nuova versione

- aggiornare dentro il makefile la "DRIVE_FOLDER" dove verrà caricato il libretto compilato
- eliminare tutti gli articoli e tutte le immagini precedenti
- aggiornare le pagine di copertina (copertina.svg e copertina-retro.svg)
- inserire un articolo alla volta dentro la cartella articoli (si consiglia di dare nome "X-nome-articolo.tex" dove "X" è un numero progressivo per fissare l'ordine con cui compaiono nel libretto finale)
- eventuali immagini vanno inserite dentro la cartella immagini
- alla fine controllare l'ortografia, caricare su gdrive, aggiungere un tag con la versione corrente e aggiornare il repo su github


## Installazione

Sono necessari i seguenti programmi per far funzionare la compilazione del libretto:

- make
- pdflatex
- inkscape
- pdfbook2
- rclone

Occorre configurare rclone per per puntare alla cartella dove caricare il libretto compilato:

    rclone config

(vedere anche la [documentazione ufficiale](https://rclone.org/drive/)).

Inoltre è consigliato avere a disposizione un editor di latex (come a esempio kile) per scrivere gli articoli.


## Istruzioni per l'uso

Per compilare il libretto, dalla stessa cartella contenente tutto il libretto dare:

    make

Per caricare su gdrive (e compilare anche in formato di stampa):

    make upload
