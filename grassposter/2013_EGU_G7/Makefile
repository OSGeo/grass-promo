FILE=poster
DIADIR = diagram

DIAFILES = $(shell ls $(DIADIR)/*.tex)
DIAPDF = $(patsubst %.tex, %.pdf, $(DIAFILES))

all: $(FILE).pdf

$(FILE).pdf: *.tex Makefile
	make pdf
	make pdf
	@while grep Rerun $(FILE).log >/dev/null 2>&1 ; do \
		make pdf; \
	done

pdf:
	pdflatex $(FILE).tex

$(SVGPDF): %.tex: %.pdf
	pdflatex $<
	pdfcrop $@

clean:
	rm -f *~ *.aux *.log *.out *.toc *.bbl *.blg *-blx.bib
	rm -f $(DIAPDF)

distclean:
	make clean
	rm -f $(FILE).pdf
