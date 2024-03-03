libretto.pdf: libretto.tex copertina.pdf retro-prima.tex struttura.tex
	pdflatex libretto.tex

copertina.pdf: copertina.svg immagini/copertina.jpg
	inkscape copertina.svg --export-area-page --export-filename=copertina.pdf

