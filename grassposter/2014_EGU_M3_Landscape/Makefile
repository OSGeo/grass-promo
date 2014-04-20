FILE=poster
SVGDIR = svg_images
CODE = code

SVGFILES = $(shell ls $(SVGDIR)/*.svg)
SVGPDF = $(patsubst %.svg, %.pdf, $(SVGFILES))
CODE = $(shell ls $(CODE)/*.tex)
CODEPDF = $(patsubst %.tex, %.pdf, $(CODE))


all: $(FILE).pdf

$(FILE).pdf: *.tex Makefile
	make pdf
	make pdf
	@while grep Rerun $(FILE).log >/dev/null 2>&1 ; do \
		make pdf; \
	done

pdf: fig
	pdflatex $(FILE).tex

fig: $(SVGPDF)

$(SVGPDF): %.pdf: %.svg
	inkscape -z --export-pdf=$@ --export-area-drawing --export-dpi=300 $<

$(CODEPDF): %.pdf: %.tex
	pdflatex -shell-escape -output-directory=$(CODE) $< 

clean:
	rm -f *~ *.aux *.log *.out *.toc *.bbl *.blg *-blx.bib *.ps
	rm -f $(SVGPDF) $(CODEPDF)

distclean:
	make clean
	rm -f $(FILE).pdf
