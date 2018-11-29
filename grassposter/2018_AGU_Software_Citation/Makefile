FILE=poster

TEXDIR = code
TEXFILES = $(shell ls $(TEXDIR)/*.tex)
TEXPDF = $(patsubst %.tex, %.pdf, $(TEXFILES))

all: $(FILE).pdf

$(FILE).pdf: *.tex Makefile poster.bib
	make pdf
	make pdf
	@while grep ''Rerun to get' to get' $(FILE).log >/dev/null 2>&1 ; do \
		make pdf; \
	done

pdf:
	# using - to ignore error from the first latex
	# the error is caused by something related to hyperref and
	# second compilation gets through (this is an workaround)
	-pdflatex -interaction=nonstopmode $(FILE).tex
	pdflatex -interaction=nonstopmode $(FILE).tex

fig: $(TEXPDF)

$(TEXPDF): %.pdf: %.tex
	pdflatex -interaction=nonstopmode -shell-escape -output-directory=$(TEXDIR) $<

clean:
	rm -f *~ *.aux *.log *.out *.toc *.bbl *.blg *-blx.bib *.ps *.pyg
	rm -f $(TEXPDF) $(TEXDIR)/*.aux $(TEXDIR)/*.log

distclean:
	make clean
	rm -f $(FILE).pdf

rasterized:
	gs -sDEVICE=png16m -r400 -o poster.png poster.pdf
	convert poster.png -rotate 90 poster_rasterized.pdf
