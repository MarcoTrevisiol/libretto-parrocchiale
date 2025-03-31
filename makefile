HOST=$(shell hostname)
DRIVE_FOLDER='Libretti Costruire Comunità/2024-12 Natale/'
ARTICOLI=$(wildcard articoli/*.tex)
IMMAGINI=$(wildcard immagini/*)
STRUTTURA=$(patsubst %,\\input{%},$(ARTICOLI))
ANNO=$(shell date '+%Y')
ANNO_PROSSIMO=$(shell date --date='1 year' '+%Y')

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

copertina-retro.pdf: immagini/retro.jpg
copertina.pdf: immagini/copertina.jpg

upload: libretto.pdf libretto-book.pdf
	rclone copyto --drive-shared-with-me libretto.pdf $(GDRIVE):$(DRIVE_FOLDER)'Libretto-stato-attuale.pdf'
	rclone copyto --drive-shared-with-me libretto-book.pdf $(GDRIVE):$(DRIVE_FOLDER)'Libretto-versione-stampa.pdf'

define AUGURI
\\section{Auguri di don Federico}

Cari parrocchiani,


\\firma{Il vostro parroco \\\\ Don Federico}
endef
export AUGURI

nuovo_libretto: clean
	-rm articoli/*tex
	printf "$$AUGURI" >articoli/0-auguri-Don-Federico.tex
	mkdir _immagini
	cp immagini/angolo.png immagini/copertina.jpg immagini/logo.jpg immagini/retro.jpg _immagini
	rm -r immagini
	mv _immagini immagini
	cp modelli/$(modello)/celebrazioni.tex celebrazioni.tex
	cp modelli/$(modello)/copertina.svg copertina.svg
	cp modelli/$(modello)/copertina-retro.svg copertina-retro.svg
	sed -i 's/2020/$(ANNO)/g' celebrazioni.tex copertina.svg copertina-retro.svg
	sed -i 's/2021/$(ANNO_PROSSIMO)/g' celebrazioni.tex copertina.svg copertina-retro.svg

natale: nuovo_libretto
natale: modello=natale
pasqua: nuovo_libretto
pasqua: modello=pasqua
sagra: nuovo_libretto
sagra: modello=sagra

clean:
	-rm *pdf *log *aux struttura.tex

