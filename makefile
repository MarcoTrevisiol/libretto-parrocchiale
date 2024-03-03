libretto.pdf: libretto.tex copertina.pdf copertina-retro.pdf retro-prima.tex struttura.tex
	pdflatex libretto.tex

copertina-retro.pdf: copertina-retro.svg immagini/pergamena.jpg
	inkscape copertina-retro.svg --export-area-page --export-filename=copertina-retro.pdf

copertina.pdf: copertina.svg immagini/copertina.jpg
	inkscape copertina.svg --export-area-page --export-filename=copertina.pdf

