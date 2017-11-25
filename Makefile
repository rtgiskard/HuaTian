#!/usr/bin/make -nf
# xetex

src ?= 花田半亩.tex
circle ?= 2
oft ?= pdf
src_misc := $(wildcard *.tex *.sty *.bib *.bst)
src_misc := $(subst ${src},,${src_misc})
src_misc += Makefile tex.vim
src_more := ${src_misc}
out_dir := ./out
out := ${out_dir}/$(subst .tex,.${oft},${src})
backup_dir := ../backup
backup_file := ${backup_dir}/$(subst .tex,_tex,${src})-$(shell date +%Y%m%d_%H%M%S).txz

TEX := $(shell which xetex)
BIBTEX ?= $(shell which bibtex)
BIB_CIRCLE ?= 0
SAGE := $(shell which sage)
SAGE_FILE := $(subst .tex,.sagetex.sage,${src})
opts := -fmt=xelatex -interaction=nonstopmode -output-directory=${out_dir}
sfx_quiet :=
sfx ?=
apdx :=

ifeq (${oft},pdf)
	VIEWER := $(shell which evince)
else
	VIEWER := $(shell which eog)
endif

# %-pattern, to consider more 'tex' to be \input
${out}: ${src} ${src_more}
	@ [ -d ${out_dir} ] || mkdir -p ${out_dir}
	@ for(( i=${circle}; i>0; i-- )); do \
		printf "\n\n\033[01;35m>>: running circle: $$((${circle} - i + 1)) ..\033[00m\n\n" ;\
		if (( ${circle} -i +1 == ${BIB_CIRCLE} )); then \
			${BIBTEX} ${out_dir}/$(subst .tex,,${src}) || break ;\
			if [ -f "${out_dir}/${SAGE_FILE}" ]; then \
				printf "\ncalling sage ..\n"; cd ${out_dir} ;\
				${SAGE} ${SAGE_FILE} || break ; cd .. ;\
			fi ;\
		else \
			${TEX} ${opts} $< ;\
		fi ;\
	done ${sfx_quiet} ${sfx}


.PHONY: view quiet refresh latexmk clean clobber backup backup_more
view: ${out}
	@ ${VIEWER} ${out} >/dev/null 2>&1 &

quiet: override sfx_quiet := >/dev/null
quiet: ${out}

refresh:
	@ touch ${src} && make ${sfx}

latexmk:
	@ [ -d ${out_dir} ] || mkdir -p ${out_dir}
	@ latexmk -xelatex -time -outdir=${out_dir} ${src}

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

backup: ${src} ${src_misc}
	@ printf "\n"
	@ [ -d ${backup_dir} ] || mkdir -p ${backup_dir}
	@ tar --xz -vcf ${backup_file} $(sort $^ ${apdx})
	@ printf "\nthey're compressed to ${backup_file}\n"

backup_more: override apdx := ${src_more}
backup_more: override backup_file := $(subst .txz,-more.txz,${backup_file})
backup_more: backup

# ?= it only has an effect if the variable is not yet defined
# := IMMEDIATE, in case of recursion call
# '$@' variable is set to the name of the target
# '$<' is just the first prerequisite
# '$^' a list of all the prerequisites, including the names of the directories in which they were found
# '$?' is used to print only those files that have changed
# '@' at the beginning of the line suppress the echoing of that line
# '-' at the beginning of the line's text (after the initial tab) ignore errors in a recipe line
# 'override' = := += override variable set with a command argument
# '$$' get a dollar sign to appear in your recipe, $$(date .*) -> $(date .*) to shell
# backup_dir is in the parent directory for the consideration of safety
# the automatic variable seems to be assigned only for the first time it's scaned
# $(sort ) removes duplicate words

# vi: set ts=4 noexpandtab readonly :

