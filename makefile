HOST=$(shell hostname)
DRIVE_FOLDER='Libretti Costruire Comunità/2024-06 Sagra/'
ARTICOLI=$(wildcard articoli/*.tex)
IMMAGINI=$(wildcard immagini/*)
STRUTTURA=$(patsubst %,\\input{%},$(ARTICOLI))

ifeq ($(HOST),LAPTOP-13UEV0F1)
	GDRIVE=gdrive
else
	GDRIVE=gdrive_trevisioltess
endif

libretto.pdf: libretto.tex copertina.pdf copertina-retro.pdf celebrazioni.tex struttura.tex $(ARTICOLI) $(IMMAGINI)
	pdflatex $<
	pdflatex $<

struttura.tex: $(ARTICOLI)
	echo $(STRUTTURA) >$@

libretto-book.pdf: libretto.pdf
	pdfbook2 --paper=a4paper -s -n --resolution 300 $<

%.pdf: %.svg
	inkscape $< --export-area-page --export-filename=$@

copertina-retro.pdf: immagini/pergamena.jpg
copertina.pdf: immagini/copertina.jpg

upload: libretto.pdf libretto-book.pdf
	rclone copyto --drive-shared-with-me libretto.pdf $(GDRIVE):$(DRIVE_FOLDER)'Libretto-stato-attuale.pdf'
	rclone copyto --drive-shared-with-me libretto-book.pdf $(GDRIVE):$(DRIVE_FOLDER)'Libretto-versione-stampa.pdf'

clean:
	-rm *pdf *log *aux struttura.tex

