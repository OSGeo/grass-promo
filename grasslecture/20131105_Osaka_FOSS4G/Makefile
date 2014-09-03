# autor: Martin Landa, Vaclav Petras
# do grepu by melo prijit neco jako labes may change (viz doxygen latex makefile)

FILE=OSHW

SVGFILES = $(shell ls *.svg)
SVGPDF = $(patsubst %.svg, %.pdf, $(SVGFILES))

all: $(FILE).pdf

$(FILE).pdf: *.tex Makefile
	make pdf
	@if grep "No file $(FILE).[aux|toc|nav]" $(FILE).log >/dev/null 2>&1 ; then \
		make pdf; \
	fi

pdf: fig
	#sed -i 's/\\notestrue/%\\notestrue/g' $(FILE).tex
	echo "%\\\\notestrue" > tmpnotessettings.tex
	pdflatex $(FILE).tex

notes: fig
	#sed -i 's/%\\notestrue/\\notestrue/g' $(FILE).tex
	echo "\\\\notestrue" > tmpnotessettings.tex
	pdflatex $(FILE).tex
	pdflatex handoutpdfpages.tex

fig: $(SVGPDF)

$(SVGPDF): %.pdf: %.svg
	inkscape -z --export-pdf=$@ --export-area-drawing --export-dpi=300 $<

clean:
	rm -f *~ *.aux *.log *.out *.toc *.nav *.snm *.vrb
	rm -f $(SVGPDF)

distclean:
	make clean
	rm -f $(FILE).pdf
