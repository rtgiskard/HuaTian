#!/usr/bin/make -nf

name := 花田半亩
src_main ?= main.tex
src_misc := $(wildcard src/*.tex src/*.sty)

src_text := src/01_writing.tex
txt_tool := tool/convert_txt.sh

out_dir := ./out
out_pdf := ${out_dir}/${name}.pdf
out_txt := ${out_dir}/${name}.txt

VIEWER := $(shell which evince)

pdf: ${out_pdf}
txt: ${out_txt}

${out_pdf}: ${src_main} ${src_misc}
	@ [ -d ${out_dir} ] || mkdir -p ${out_dir}
	@ latexmk -xelatex -time -outdir=${out_dir} -jobname=${name} "$<"

${out_txt}: ${src_text} ${txt_tool}
	@ [ -d ${out_dir} ] || mkdir -p ${out_dir}
	@ ${txt_tool} "$<" > "$@" && echo "-> $@"

.PHONY: view clean clobber
view: ${out_pdf}
	@ ${VIEWER} ${out_pdf} >/dev/null 2>&1 &

clean:
	@- rm -fv ${out_dir}/*.aux
	@- rm -fv ${out_dir}/*.?o?			# toc,lof,lot,log
	@- rm -fv ${out_dir}/*.i??			# idx,ind,ilg
	@- rm -fv ${out_dir}/*.[bo]??		# bbl,blg,out
	@- rm -fv ${out_dir}/*.sagetex.*	# usepackage sagetex
	@- rm -fv ${out_dir}/*.fls			# latexmk
	@- rm -fv ${out_dir}/*.*_latexmk	# latexmk
	@- rm -fv ./missfont.log

clobber: clean
	@- rm -rfv ${out_dir}

# vi: set ts=4 noexpandtab readonly :
