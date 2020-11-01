TEX = cv.tex
PDF_VIEWER=mupdf
OUTPUT_DIR=output
OUTPUT = --output-directory=$(OUTPUT_DIR)
NAME = TOIGILDIN_VLADISLAV_dev
JOBNAME = --jobname=$(NAME)

.PHONY: all clean view move diff_styles diff_colors diff_fonts

all: mkdir_output eng rus view

eng: eng_compact eng_detailed

rus: rus_compact rus_detailed

compact: eng_compact rus_compact

detailed: eng_detailed rus_detailed

XELATEX = xelatex $(OUTPUT) $(JOBNAME)_$@ $(TEX)

eng_compact: $(TEX)
	$(XELATEX)

eng_detailed: $(TEX)
	$(XELATEX)
	$(XELATEX)

rus_compact: $(TEX)
	$(XELATEX)

rus_detailed: $(TEX)
	$(XELATEX)
	$(XELATEX)

clean:
	rm -f $(OUTPUT_DIR)/*
	rm -f *.pdf

move:
	cp $(OUTPUT_DIR)/*.pdf .

view: move
	$(PDF_VIEWER) *.pdf

mkdir_output:
	mkdir -p $(OUTPUT_DIR)

######## DIFFERENT THEME ###########################

COMMAND = echo '\moderncvtheme[$(2)]{$(1)}\n\
                \\toggletrue{langRussian}\n\
                \\togglefalse{langEnglish}\n\
                \\toggletrue{detailed}\n\
                \\togglefalse{compact}' > style.tex && \
          xelatex $(OUTPUT) $(JOBNAME)_diff $(TEX) && \
          mv $(OUTPUT_DIR)/$(NAME)_diff.pdf $(OUTPUT_DIR)/$(2)_$(1).pdf

STYLE   = classic
COLOR   = red

diff_styles:
	$(call COMMAND,classic,$(COLOR))
	$(call COMMAND,casual,$(COLOR))
	$(call COMMAND,banking,$(COLOR))
	$(call COMMAND,oldstyle,$(COLOR))
	$(call COMMAND,fancy,$(COLOR))

diff_colors:
	$(call COMMAND,$(STYLE),red)
	$(call COMMAND,$(STYLE),orange)
	$(call COMMAND,$(STYLE),green)
	$(call COMMAND,$(STYLE),blue)
	$(call COMMAND,$(STYLE),grey)
	$(call COMMAND,$(STYLE),black)
	$(call COMMAND,$(STYLE),burgundy)
	$(call COMMAND,$(STYLE),purple)

######## DIFFERENT FONTS ###########################

FONTS  =  echo '\def\myfont{$(1)}\n\
                \\toggletrue{langRussian}\n\
                \\togglefalse{langEnglish}\n\
                \\toggletrue{detailed}\n\
                \\togglefalse{compact}' > style.tex && \
          xelatex $(OUTPUT) $(JOBNAME)_diff $(TEX) && \
          mv $(OUTPUT_DIR)/$(NAME)_diff.pdf $(OUTPUT_DIR)/cv_$(1).pdf

diff_fonts:
	$(call FONTS,Constantia)
	$(call FONTS,Garamond)
	$(call FONTS,Georgia)
	$(call FONTS,Helvetica)
	$(call FONTS,Calibri)
	$(call FONTS,FreeSans)
