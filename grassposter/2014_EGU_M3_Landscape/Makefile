FILE=poster
SVGDIR = svg_images
CODEDIR = code

SVGFILES = $(shell ls $(SVGDIR)/*.svg)
SVGPDF = $(patsubst %.svg, %.pdf, $(SVGFILES))
CODEFILES = $(shell ls $(CODEDIR)/*.tex)
CODEPDF = $(patsubst %.tex, %.pdf, $(CODEFILES))


all: $(FILE).pdf

$(FILE).pdf: *.tex Makefile
	make pdf
	make pdf
	@while grep 'Rerun to get' $(FILE).log >/dev/null 2>&1 ; do \
		make pdf; \
	done

pdf: fig code
	pdflatex $(FILE).tex
	bibtex $(FILE)

fig: $(SVGPDF)

$(SVGPDF): %.pdf: %.svg
	inkscape -z --export-pdf=$@ --export-area-drawing --export-dpi=300 $<

code: $(CODEPDF)

$(CODEPDF): %.pdf: %.tex
	pdflatex -shell-escape -output-directory=$(CODEDIR) $< 

clean:
	rm -f *~ *.aux *.log *.out *.toc *.bbl *.blg *-blx.bib *.ps
	rm -f $(SVGPDF) $(CODEPDF)

distclean:
	make clean
	rm -f $(FILE).pdf
