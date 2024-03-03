HOST=$(shell hostname)

ifeq ($(HOST),LAPTOP-13UEV0F1)
	GDRIVE=gdrive
else
	GDRIVE=gdrive_trevisioltess
endif

libretto.pdf: libretto.tex copertina.pdf copertina-retro.pdf retro-prima.tex struttura.tex
	pdflatex $<

%.pdf: %.svg
	inkscape $< --export-area-page --export-filename=$@

copertina-retro.pdf: immagini/pergamena.jpg
copertina.pdf: immagini/copertina.jpg

clean:
	-rm *pdf *log *aux

upload: libretto.pdf
	rclone copyto --drive-shared-with-me libretto.pdf $(GDRIVE):'Libretti Costruire Comunità/2024-04 Pasqua/Libretto-Pasqua-stato-attuale.pdf'

