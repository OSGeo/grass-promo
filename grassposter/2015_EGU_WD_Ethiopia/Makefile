FILE=poster
SVGDIR = $(shell pwd)/svg_images

SVGFILES = $(shell ls $(SVGDIR)/*.svg)
SVGPDF = $(patsubst %.svg, %.pdf, $(SVGFILES))

all: $(FILE).pdf

$(FILE).pdf: *.tex Makefile
	make pdf 
	make pdf 
	@while grep Rerun $(FILE).log >/dev/null 2>&1 ; do \
		make pdf; \
	done

pdf: fig
	pdflatex -shell-escape $(FILE).tex 

fig: $(SVGPDF)

$(SVGPDF): %.pdf: %.svg
	inkscape -z --export-pdf=$@ --export-area-drawing --export-dpi=300 $<

clean:
	rm -f *~ *.aux *.log *.out *.toc *.bbl *.blg *-blx.bib *.ps
	rm -f $(SVGPDF)

distclean:
	make clean
	rm -f $(FILE).pdf
