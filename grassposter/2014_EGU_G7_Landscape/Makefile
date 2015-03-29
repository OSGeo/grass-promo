FILE=poster
SVGDIR = svg_images
ODPDIR = odp_slides
TEXDIR = texpdfs

SVGFILES = $(shell ls $(SVGDIR)/*.svg)
SVGPDF = $(patsubst %.svg, %.pdf, $(SVGFILES))
ODPFILES = $(shell ls $(ODPDIR)/*.odp)
ODPPDF = $(patsubst %.odp, %.pdf, $(ODPFILES))
TEXFILES = $(shell ls $(TEXDIR)/*.tex)
TEXPDF = $(patsubst %.tex, %.pdf, $(TEXFILES))

all: $(FILE).pdf

$(FILE).pdf: *.tex Makefile
	make pdf
	make pdf
	@while grep 'Rerun to get' $(FILE).log >/dev/null 2>&1 ; do \
		make pdf; \
	done

pdf: fig
	pdflatex $(FILE).tex

fig: $(SVGPDF) $(ODPPDF) $(TEXPDF)

$(SVGPDF): %.pdf: %.svg
	inkscape -z --export-pdf=$@ --export-area-drawing --export-dpi=300 $<

$(ODPPDF): %.pdf: %.odp
	libreoffice --headless --convert-to pdf --outdir $(ODPDIR) $<

$(TEXPDF): %.pdf: %.tex
	pdflatex -shell-escape -output-directory=$(TEXDIR) $< 

clean:
	rm -f *~ *.aux *.log *.out *.toc *.bbl *.blg *-blx.bib *.ps
	rm -f $(SVGPDF) $(ODPPDF) $(TEXPDF)

distclean:
	make clean
	rm -f $(FILE).pdf
