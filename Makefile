#!/usr/bin/make -nf

name := 花田半亩

src_main ?= src/main.tex
src_text := src/01_writing.tex
txt_tool := tool/convert_txt.sh

out_dir := ./out
out_pdf := ${out_dir}/${name}.pdf
out_txt := ${out_dir}/${name}.txt

VIEWER := $(shell which evince)

pdf: ${out_pdf}
txt: ${out_txt}

${out_pdf}: $(wildcard src/*)
	@ [ -d ${out_dir} ] || mkdir -p ${out_dir}
	@ latexmk -cd -xelatex -time -outdir="$(abspath ${out_dir})" \
		--jobname="${name}" "${src_main}"

${out_txt}: ${src_text} ${txt_tool}
	@ [ -d ${out_dir} ] || mkdir -p ${out_dir}
	@ ${txt_tool} "$<" > "$@" && echo "-> $@"

.PHONY: view clean clobber
view: ${out_pdf}
	@ ${VIEWER} ${out_pdf} >/dev/null 2>&1 &

clean:
	@- rm -fv ${out_dir}/*.[^pt]*	# keep: pdf, txt
	@- rm -fv ${out_dir}/*.toc
	@- rm -fv ./missfont.log

clobber: clean
	@- rm -rfv ${out_dir}
