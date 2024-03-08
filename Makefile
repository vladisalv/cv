################################################################
# Compile it with docker:
# docker run -ti --rm -v /etc/localtime:/etc/localtime:ro -v /usr/share/fonts:/usr/share/fonts:ro -v $(pwd):/cv:ro -v $(pwd)/output:/cv/output --workdir /cv --name cv texlive/texlive:latest make
#
# Compiled files are in `output` dir.
# I prefer use mupdf for view (r key reload):
# $ mupdf output/file.pdf
#
# Options of makefile:
#   - make eng/rus/compact/detailed
#   - make diff_styles
#   - make diff_colors
#   - make diff_fonts

# I used Constantia font and classic blue theme.
# Also, i liked Garamond, Georgia and Helvetica fonts.
#
# Workflow:
# 1. edit cv.tex, compile using docker, view via mupdf reloader
# 2. pdffonts output/your.pdf (check emb column yes)
# 3. mv output/your.pdf TOIGILDIN_VLADISLAV_dev.pdf
# 4. create git tag
################################################################

TEX_DOC = cv.tex
OUTPUT_DIR = output
OUTPUT = --output-directory=$(OUTPUT_DIR)
NAME = TOIGILDIN_VLADISLAV_dev
JOBNAME = --jobname=$(NAME)

.PHONY: all clean diff_styles diff_colors diff_fonts

all: eng_compact

eng: eng_compact eng_detailed

rus: rus_compact rus_detailed

compact: eng_compact rus_compact

detailed: eng_detailed rus_detailed

XELATEX = xelatex $(OUTPUT) $(JOBNAME)_$@ $(TEX_DOC)

eng_compact: $(mkdir_output) $(TEX_DOC)
	$(XELATEX)

eng_detailed: $(mkdir_output) $(TEX_DOC)
	$(XELATEX)
	$(XELATEX)

rus_compact: $(mkdir_output) $(TEX_DOC)
	$(XELATEX)

rus_detailed: $(mkdir_output) $(TEX_DOC)
	$(XELATEX)
	$(XELATEX)

clean:
	rm -f $(OUTPUT_DIR)/*
	rm -f *.pdf

mkdir_output:
	mkdir -p $(OUTPUT_DIR)

######## DIFFERENT THEME ###########################

COMMAND = echo '\moderncvtheme[$(2)]{$(1)}\n\
                \\toggletrue{langRussian}\n\
                \\togglefalse{langEnglish}\n\
                \\toggletrue{detailed}\n\
                \\togglefalse{compact}' > style.tex && \
          xelatex $(OUTPUT) $(JOBNAME)_diff $(TEX_DOC) && \
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
          xelatex $(OUTPUT) $(JOBNAME)_diff $(TEX_DOC) && \
          mv $(OUTPUT_DIR)/$(NAME)_diff.pdf $(OUTPUT_DIR)/cv_$(1).pdf

diff_fonts:
	$(call FONTS,Constantia)
	$(call FONTS,Garamond)
	$(call FONTS,Georgia)
	$(call FONTS,Helvetica)
	$(call FONTS,Calibri)
	$(call FONTS,FreeSans)
