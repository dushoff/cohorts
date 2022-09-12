## This is cohorts, created 2022 Sep 01 (Thu)

current: target
-include target.mk
Ignore = target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

Sources += *.md
Ignore += $(mdpdf_f)

Ignore += notes.pdf
notes.pdf: notes.md
	$(xelex_r)

bb_notes.pdf: bb_notes.md
	$(xelex_r)

sw_notes.pdf: sw_notes.md
	$(xelex_r)

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/00.stamp
makestuff/%.stamp:
	- $(RM) makestuff/*.stamp
	(cd makestuff && $(MAKE) pull) || git clone $(msrepo)/makestuff
	touch $@

-include makestuff/os.mk

-include makestuff/pandoc.mk

-include makestuff/git.mk
-include makestuff/visual.mk
