#!/usr/bin/make -nf

name := 花田半亩
src_main ?= 00_main.tex
src_all := $(wildcard *.tex *.sty *.bib *.bst)
src_all += Makefile tex.vim

out_dir := ./out
out := ${out_dir}/${name}.pdf

VIEWER := $(shell which evince)

${out}: ${src} ${src_all}
	@ [ -d ${out_dir} ] || mkdir -p ${out_dir}
	@ latexmk -xelatex -time -outdir=${out_dir} -jobname=${name} ${src_main}

.PHONY: view clean clobber
view: ${out}
	@ ${VIEWER} ${out} >/dev/null 2>&1 &

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
