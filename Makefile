PROJECT_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

OUTPUT_DIR := $(PROJECT_DIR)/out
SRC_DIR := $(PROJECT_DIR)/src

MAINFILE := cv

TEX_FILES = $(find . -type f -name '*.tex')
EXTRA_FILES = $(shell echo "$(SRC_DIR)/graphics/*")

.PHONY: fmt fmt-nix default clean out-dir

default: out-dir $(OUTPUT_DIR)/$(MAINFILE).pdf

fmt: fmt-nix

fmt-nix:
	nixfmt $$(find ${PROJECT_DIR} -name '*.nix')

clean:
	fd --full-path $(SRC_DIR) -I -t f \
		-e aux \
		-e bbl \
		-e blg \
		-e brf \
		-e dvi \
		-e fdb_latexmk \
		-e fls \
		-e idx \
		-e ilg \
		-e ind \
		-e lof \
		-e log \
		-e lot \
		-e out \
		-e pdf \
		-e toc \
		-e url \
		-e gz \
		-x rm {}
	rm -rf $(OUTPUT_DIR)
	rm -rf $(SRC_DIR)/_minted-*

out-dir:
	@printf 'Creating output directory: $(OUTPUT_DIR)\n'
	mkdir -p $(OUTPUT_DIR)

$(OUTPUT_DIR)/$(MAINFILE).pdf: out-dir $(TEX_FILES) $(EXTRA_FILES)
	cd $(SRC_DIR) &&\
	latexmk -shell-escape -interaction=nonstopmode -halt-on-error -norc -jobname=$(MAINFILE) -pdf &&\
	cp $(MAINFILE).pdf $(OUTPUT_DIR)
