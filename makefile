libretto.pdf: libretto.tex copertina.pdf copertina-retro.pdf retro-prima.tex struttura.tex
	pdflatex $<

%.pdf: %.svg
	inkscape $< --export-area-page --export-filename=$@

copertina-retro.pdf: immagini/pergamena.jpg
copertina.pdf: immagini/copertina.jpg

clean:
	-rm *pdf *log *aux

