TEX = cv.tex
OUTPUT_DIR=output
OUTPUT = --output-directory=$(OUTPUT_DIR)
NAME = cv_TOIGILDIN_VLADISLAV
JOBNAME = --jobname=$(NAME)

.PHONY: all clean view copy diff_styles diff_colors

#all: mkdir_output clean eng_short rus_short view
all: mkdir_output eng rus view

eng: eng_short eng_long

rus: rus_short rus_long

XELATEX = xelatex $(OUTPUT) $(JOBNAME)_$@ $(TEX)

eng_short: $(TEX)
	$(XELATEX)

eng_long: $(TEX)
	$(XELATEX)
	$(XELATEX)

rus_short: $(TEX)
	$(XELATEX)

rus_long: $(TEX)
	$(XELATEX)
	$(XELATEX)

clean:
	rm -f $(OUTPUT_DIR)/*
	rm -f *.pdf

move:
	cp $(OUTPUT_DIR)/*.pdf .

view: move
	evince *.pdf

mkdir_output:
	mkdir -p output

COMMAND = echo "\moderncvtheme[$(2)]{$(1)}" > style.tex && \
          xelatex $(OUTPUT) $(JOBNAME)_diff $(TEX) && \
          mv $(OUTPUT_DIR)/$(NAME)_diff.pdf $(OUTPUT_DIR)/$(2)_$(1).pdf

STYLE   = classic
COLOR   = blue

diff_styles:
	$(call COMMAND,classic,$(COLOR))
	$(call COMMAND,casual,$(COLOR))
	$(call COMMAND,fancy,$(COLOR))
	$(call COMMAND,oldstyle,$(COLOR))
	$(call COMMAND,banking,$(COLOR))

diff_colors:
	$(call COMMAND,$(STYLE),red)
	$(call COMMAND,$(STYLE),orange)
	$(call COMMAND,$(STYLE),green)
	$(call COMMAND,$(STYLE),blue)
	$(call COMMAND,$(STYLE),grey)
	$(call COMMAND,$(STYLE),black)
	$(call COMMAND,$(STYLE),burgundy)
	$(call COMMAND,$(STYLE),purple)
