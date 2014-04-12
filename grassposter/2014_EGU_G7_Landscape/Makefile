FILE=poster
SVGDIR = svg_images
ODPDIR = odp_slides

SVGFILES = $(shell ls $(SVGDIR)/*.svg)
SVGPDF = $(patsubst %.svg, %.pdf, $(SVGFILES))
ODPFILES = $(shell ls $(ODPDIR)/*.odp)
ODPPDF = $(patsubst %.odp, %.pdf, $(ODPFILES))

all: $(FILE).pdf

$(FILE).pdf: *.tex Makefile
	make pdf
	make pdf
	@while grep Rerun $(FILE).log >/dev/null 2>&1 ; do \
		make pdf; \
	done

pdf: fig
	pdflatex $(FILE).tex

fig: $(SVGPDF) $(ODPPDF)

$(SVGPDF): %.pdf: %.svg
	inkscape -z --export-pdf=$@ --export-area-drawing --export-dpi=300 $<

$(ODPPDF): %.pdf: %.odp
	libreoffice --headless --convert-to pdf --outdir $(ODPDIR) $<

clean:
	rm -f *~ *.aux *.log *.out *.toc *.bbl *.blg *-blx.bib *.ps
	rm -f $(SVGPDF) $(ODPPDF)

distclean:
	make clean
	rm -f $(FILE).pdf
