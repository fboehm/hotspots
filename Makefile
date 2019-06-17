
PAPER_DIR=analysis/paper

# Tools
LATEXMK = latexmk
RM = rm -f

# Rules

all: $(PAPER_DIR)/paper.pdf

$(PAPER_DIR)/paper.tex: $(PAPER_DIR)/paper.Rnw
	R -e "devtools::install(dep = TRUE)"; cd $(PAPER_DIR); Rscript -e "knitr::knit('paper.Rnw')"

%.pdf: %.tex
	cd $(PAPER_DIR); $(LATEXMK) -pdfps -bibtex paper

mostlyclean:
	cd $(PAPER_DIR); $(LATEXMK) -silent -c
	$(RM) $(PAPER_DIR)/*.bbl

clean: mostlyclean
	cd $(PAPER_DIR); $(LATEXMK) -silent -C
	$(RM) $(PAPER_DIR)/*.run.xml $(PAPER_DIR)/*.synctex.gz
	$(RM) $(PAPER_DIR)/*.d

.PHONY: all clean doc mostlyclean pdf

# Include auto-generated dependencies
#-include *.d


# use latexdiff to get PDF comparing current to an older version
diff:
	latexdiff latexdiff/main_old.tex $(PAPER_DIR)/main.tex > latexdiff/diff.tex
	mv latexdiff/diff.tex $(PAPER_DIR)
	cd $(PAPER_DIR);$(LATEXMK) -pdfps -bibtex diff.tex
	mv $(PAPER_DIR)/diff* latexdiff/

