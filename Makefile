.SECONDARY:

%.pdf: %.tex
	xelatex $<

%.tex: %.md
	pandoc -so $@ $<

%.lps: %.mcrl2
	mcrl22lps -lregular2 -v $< $@

%.lts: %.lps
	lps2lts -vD $< $@

p.mcrl2: p.web
	./poorweb.py $< /dev/null $@

p.md: p.web
	./poorweb.py $< $@ /dev/null

p.tex: p.md
	pandoc -o $@ $<

p.mcrl2.tex: p.mcrl2
	echo '\begin{verbatim}' > $@
	cat $< >> $@
	echo '\end{verbatim}' >> $@

doc.pdf: p.mcrl2.tex p.tex
