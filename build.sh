#!/bin/bash

LATEX_BIN=/Library/TeX/texbin/lualatex
METAFILE_DIR=meta

function clean {
	printf "Cleaning... ";
	find ${METAFILE_DIR} -name "*.aux" | xargs rm -f;
	find ${METAFILE_DIR} -name "*.log" | xargs rm -f;
	find ${METAFILE_DIR} -name "*.out" | xargs rm -f;
	find ${METAFILE_DIR} -name "*.toc" | xargs rm -f;
	printf "OK\n";
}

if [[ $1 == "clean" ]]; then
	clean

elif [[ $1 == "cleanall" ]]; then
	clean
	find . -name "*.pdf" | xargs rm -f;

elif [[ -f "$1" ]]; then
	extension="${1##*.}"
	FNAME=`echo $1 | cut -d. -f1`
	
	if [[ $extension == "tex" ]]; then
		printf "Compiling TeX document $1\n"
		$LATEX_BIN -output-directory="${METAFILE_DIR}" -no-file-line-error -no-file-line-error-style -shell-escape -8bit $1
		$LATEX_BIN -output-directory="${METAFILE_DIR}" -no-file-line-error -no-file-line-error-style -shell-escape -8bit $1
	fi
	mv ${METAFILE_DIR}/${FNAME}.pdf pdf
else
	printf "Usage:\n"
	printf "\t $0 clean - will clear all garbage (logs and other files).\n"
	printf "\t $0 cleanall - will clear all garbage AND the pdf file.\n"
	printf "\t $0 filename.tex - will compile tex file to pdf.\n"
fi

