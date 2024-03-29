.SECONDARY:

%.pdf: %.tex
	xelatex $<

%.tex: %.md
	pandoc -so $@ $<

%.lps: %.mcrl2
	mcrl22lps -v $< $@

%.lts: %.lps
	lps2lts -vD $< $@

p.mcrl2: doc.web
	./poorweb.py $< /dev/null $@

doc.md: doc.web
	./poorweb.py $< $@ /dev/null

p.mcrl2.tex: p.mcrl2
	echo '\begin{verbatim}' > $@
	cat $< >> $@
	echo '\end{verbatim}' >> $@

doc.pdf: p.mcrl2.tex

mcfs: doc.web
	./poorweb.py $< /dev/null /dev/null

validate-all: mcfs
	./validate-all

.PHONY: mcfs validate-all
