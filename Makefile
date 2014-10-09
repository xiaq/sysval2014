.SECONDARY:

%.pdf: %.tex
	xelatex $<

%.tex: %.md
	pandoc -f markdown+definition_lists -so $@ $<

%.lps: %.mcrl2
	mcrl22lps -v $< $@

%.lts: %.lps
	lps2lts -v $< $@

doc.pdf: p.mcrl2
