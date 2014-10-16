.SECONDARY:

%.pdf: %.tex
	xelatex $<

%.tex: %.md
	pandoc -so $@ $<

%.lps: %.mcrl2
	mcrl22lps -lregular2 -v $< $@

%.lts: %.lps
	lps2lts -v $< $@

doc.pdf: p.mcrl2
