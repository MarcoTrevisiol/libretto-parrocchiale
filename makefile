ARTICOLI=$(wildcard articoli/*.tex)
IMMAGINI_BASE=$(wildcard immagini/*)
IMMAGINI=$(patsubst immagini/%.svg,immagini/%.pdf,$(IMMAGINI_BASE))
STRUTTURA=$(patsubst %,\\input{%},$(ARTICOLI))
ANNO=$(shell date '+%Y')
ANNO_PROSSIMO=$(shell date --date='1 year' '+%Y')

# Raccolta automatica da google drive
RCLONE_TARGET := rclone-target.txt
RCLONE_FLAGS  := --drive-shared-with-me --drive-export-formats docx

DL             := grezzi
LISTA_DIR      := $(DL)/0-lista
SCARICATI_DIR  := $(DL)/1-scaricati
TESTI_G_DIR    := $(DL)/2-testi-g
IMMAGINI_G_DIR := $(DL)/3-immagini
TESTI_F_DIR    := $(DL)/4-testi-f
TESTI_A_DIR    := $(DL)/6-testi-a

MARCATORI   := $(wildcard $(LISTA_DIR)/*.docx)
SCARICABILI := $(patsubst $(LISTA_DIR)/%.docx,$(SCARICATI_DIR)/%.docx,$(MARCATORI))
TESTI_G     := $(patsubst $(LISTA_DIR)/%.docx,$(TESTI_G_DIR)/%.txt,$(MARCATORI))
IMMAGINI_G  := $(patsubst $(LISTA_DIR)/%.docx,$(IMMAGINI_G_DIR)/%.done/,$(MARCATORI))
TESTI_F     := $(patsubst $(LISTA_DIR)/%.docx,$(TESTI_F_DIR)/%.txt,$(MARCATORI))
TESTI_A     := $(patsubst $(LISTA_DIR)/%.docx,$(TESTI_A_DIR)/%.txt,$(MARCATORI))

libretto.pdf: libretto.tex copertina.pdf copertina-retro.pdf celebrazioni.tex struttura.tex $(ARTICOLI) $(IMMAGINI)
	pdflatex $<
	pdflatex $<

struttura.tex: articoli
	echo $(STRUTTURA) >$@

libretto-book.pdf: libretto.pdf
	pdfbook2 --paper=a4paper -s -n --resolution 300 $<

%.pdf: %.svg
	inkscape $< --export-area-page --export-filename=$@

copertina-retro.pdf: immagini/retro.jpg
copertina.pdf: immagini/copertina.jpg

upload: libretto.pdf libretto-book.pdf | $(RCLONE_TARGET)
	TARGET=$$(cat $(RCLONE_TARGET)); \
	rclone copyto --drive-shared-with-me libretto.pdf "$${TARGET}/Libretto-stato-attuale.pdf" && \
	rclone copyto --drive-shared-with-me libretto-book.pdf "$${TARGET}/Libretto-versione-stampa.pdf"

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
	cp immagini/copertina.jpg immagini/logo.jpg immagini/retro.jpg _immagini
	rm -r immagini
	mv _immagini immagini
	-cp modelli/$(modello)/angolo.png immagini/angolo.png
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
	-rm -rf "$(DL)"


.PHONY: tutto lista scaricabili testi_g immagini_g clean
#.SECONDARY: $(TESTI_G_DIR)/%.txt $(TESTI_F_DIR)/%.txt $(TESTI_A_DIR)/%.txt
.PRECIOUS: $(TESTI_G_DIR)/%.txt $(TESTI_F_DIR)/%.txt $(TESTI_A_DIR)/%.txt


tutto: lista
	$(MAKE) testi_g immagini_g

lista: $(RCLONE_TARGET)
	rm -rf "$(LISTA_DIR)" && mkdir -p "$(LISTA_DIR)"

	rclone lsf $(RCLONE_FLAGS) --files-only "$$(cat $<)" \
	  | grep -E '\.docx$$' \
	  | while IFS= read -r name; do \
	      slug="$$(printf '%s' "$$name" \
	        | tr '[:upper:]' '[:lower:]' \
	        | tr ' ' '-' \
	        | sed -E 's/[^.a-z0-9-]+//g; s/-+/-/g; s/^-+//; s/-+$$//')"; \
	      printf '%s\n' "$$name" > "$(LISTA_DIR)/$${slug}"; \
	    done

# Convenience: fetch everything currently listed
scaricabili: $(SCARICABILI)
testi_g: $(TESTI_G)
immagini_g: $(IMMAGINI_G)
testi_a: $(TESTI_A)

$(SCARICATI_DIR)/%.docx: $(LISTA_DIR)/%.docx | $(SCARICATI_DIR) $(RCLONE_TARGET)
	rclone copyto $(RCLONE_FLAGS) "$$(cat $(RCLONE_TARGET))$$(cat $<)" "$@"
	touch "$@"

$(TESTI_G_DIR)/%.txt: $(SCARICATI_DIR)/%.docx | $(TESTI_G_DIR)
	docx2txt "$<" "$@"

$(TESTI_F_DIR)/%.txt: $(TESTI_G_DIR)/%.txt | $(TESTI_F_DIR)
	sed -f ./testo-std.sed <"$<" >"$@"

$(TESTI_A_DIR)/%.txt: $(TESTI_F_DIR)/%.txt | $(TESTI_A_DIR)
	sed '1{s/^.*$$/\\section{&}/}; $${s/^.*$$/\\firma{&}/}' "$<" > "$@"

$(IMMAGINI_G_DIR)/%.done/: $(SCARICATI_DIR)/%.docx | $(IMMAGINI_G_DIR)
	mkdir -p "$@tmp"
	unzip -q "$<" -d "$@tmp"
	[ -d "$@tmp/word/media" ] && cp -a "$@tmp/word/media/." "$@" || true
	rm -rf "$@tmp"

$(LISTA_DIR) $(SCARICATI_DIR) $(TESTI_G_DIR) $(TESTI_F_DIR) $(TESTI_A_DIR) $(IMMAGINI_G_DIR):
	mkdir -p "$@"


