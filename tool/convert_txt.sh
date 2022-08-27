#!/bin/bash

[ -f "$1" ] || exit

# precheck
grep '^\s*[，、。；？！]' "$1"

# convert
sed -e 's|%.*$||' \
	-e 's|^\s\+||' \
	-e 's|\s\+$||' \
	-e 's|^\\newsect{\(.*\)}.*|== \1\n|' \
	-e 's|^\\writing{\(.*\)}{\(.*\)}.*|=== \1 (\2)|' \
	-e 's|^\\subpart{\(.*\)}.*|** \1 **|' \
	-e 's|^\\endwriting$||' \
	-e 's|^\\endlongpoem$||' \
	-e 's|^\\vspace{.*}$|\n\n|' \
	-e 's|\\hspace{.*}\s*|\t|' \
	-e 's|\\par$|$|' \
	-e 's|\\\\$|$|' \
	-e 's|\\[[:alnum:]]\+{.*}||g' \
	-e 's|\\[[:alnum:]]\+||g' \
	-e 's|\s\+$||' \
	"$1" | \
	sed '/^$/{:x;N;$d;/^\n\+$/bx; s/^\n\{2,\}/\n\n/}' | \
	sed ':x;/[^$]$/{N; /\n$/b; s/\s*\n\s*//; bx}; s/\$$//' | \
	sed '1,4s/^== .*/花田半亩 (文集整理)/' | \
	awk '/^===/{n++; gsub(/^===/, "第" n "篇"); print $0; next }{print $0;}'

# note: split sed to avoid interference
# . basic convert with some mark: \$$ - no undo-wrap
# . reduce repeate \n
# . undo wrap, remove mark
# . awk for general toc structure
