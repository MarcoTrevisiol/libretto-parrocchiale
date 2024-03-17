HOST=$(shell hostname)
DRIVE_FOLDER='Libretti Costruire Comunità/2024-04 Pasqua/'

ifeq ($(HOST),LAPTOP-13UEV0F1)
	GDRIVE=gdrive
else
	GDRIVE=gdrive_trevisioltess
endif

libretto.pdf: libretto.tex copertina.pdf copertina-retro.pdf celebrazioni.tex struttura.tex
	pdflatex $<
	pdflatex $<

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
	-rm *pdf *log *aux

