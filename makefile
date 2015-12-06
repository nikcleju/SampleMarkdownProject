
name=Example # name of DocOnce master document
namemd=$(addsuffix .md, $(name))
namepdf=$(addsuffix .pdf, $(name))
namedocx=$(addsuffix .docx, $(name))

all: pdf

pdf: 
	echo $(PATH)
	pandoc -s -S $(namemd) -o $(namepdf)  --filter pandoc-crossref --bibliography=Biblio_UTF8.bib --csl=ieee.csl

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

clean:
	doconce clean

