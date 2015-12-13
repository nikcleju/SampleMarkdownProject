
name=Example # name of DocOnce master document
namemd=$(addsuffix .md, $(name))
namepdf=$(addsuffix .pdf, $(name))
namedocx=$(addsuffix .docx, $(name))
namenative=$(addsuffix .txt, $(name))
nametest=$(addsuffix _test.pdf, $(name))
nametesttex=$(addsuffix _test.tex, $(name))
nametestnative=$(addsuffix _test.txt, $(name))
nametesthtml=$(addsuffix _test.html, $(name))

all: pdf

test:
#	pandoc -s -S $(namemd) -t native -o $(nametestnative) --filter ./TheoremBlock.hs --filter ./WriteTheoremBlock.hs --filter pandoc-crossref --bibliography=Biblio_UTF8.bib --csl=ieee.csl
#	pandoc -s -S $(namemd) -o $(nametesttex) --filter ./TheoremBlock.hs --filter ./WriteTheoremBlock.hs --filter pandoc-crossref --bibliography=Biblio_UTF8.bib --csl=ieee.csl
#	pandoc -s -S $(namemd) -o $(nametest) --filter ./TheoremBlock.hs --filter ./WriteTheoremBlock.hs --filter pandoc-crossref --bibliography=Biblio_UTF8.bib --csl=ieee.csl
#	pandoc -s -S $(namemd) -o $(nametesthtml) --filter ./TheoremBlock.hs --filter ./WriteTheoremBlock.hs --filter pandoc-crossref --bibliography=Biblio_UTF8.bib --csl=ieee.csl
	pandoc -s -S $(namemd) -t native -o $(nametestnative) --filter ./makeDivs.hs --filter pandoc-crossref --bibliography=Biblio_UTF8.bib --csl=ieee.csl
	pandoc -s -S $(namemd) -o $(nametesttex) --filter ./makeDivs.hs --filter pandoc-crossref --bibliography=Biblio_UTF8.bib --csl=ieee.csl
	pandoc -s -S $(namemd) -o $(nametest) --filter ./makeDivs.hs --filter pandoc-crossref --bibliography=Biblio_UTF8.bib --csl=ieee.csl


testpy:
	pandoc -s -S $(namemd) -t native -o $(nametestnative) --filter ./TheoremBlock.py
	pandoc -s -S $(namemd) -o $(nametesttex) --filter ./TheoremBlock.py --filter pandoc-crossref --bibliography=Biblio_UTF8.bib --csl=ieee.csl
	pandoc -s -S $(namemd) -o $(nametest) --filter ./TheoremBlock.py --filter pandoc-crossref --bibliography=Biblio_UTF8.bib --csl=ieee.csl

pdf: 
	pandoc -s -S $(namemd) -o $(namepdf) --filter pandoc-crossref --bibliography=Biblio_UTF8.bib --csl=ieee.csl

beamer:
	doconce format pdflatex $(name) --latex_title_layout=beamer --latex_admon_title_no_period --latex_code_style=pyg SLIDE_TYPE="beamer"
	doconce slides_beamer $(name) --beamer_slide_theme="Madrid"
	pdflatex --shell-escape $(name)


pandocbeamer: md
	pandoc -t beamer $(namemd) -V theme:Madrid -o $(namepdf)

md:
	doconce format pandoc $(name)

mmd:
	doconce format pandoc $(name) --multimarkdown_output

docx:
	doconce format pandoc $(name); 
	pandoc -s -S $(namemd) -o $(namedocx)

native:
	pandoc -s -S $(namemd) -t native -o $(namenative)

clean:
	doconce clean

