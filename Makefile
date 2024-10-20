
# run-p1313:
# 	hugo server

# run-p1313-with-drafts:
# 	hugo server --buildDrafts

# commands-sample:
# 	hugo new posts/my-first-post.md

##############################################
# modules: https://gohugo.io/hugo-modules/use-modules/
# https://github.com/adityatelange/hugo-PaperMod/wiki/Installation
modules-update:
	hugo mod get -u
#	cd themes/PaperMod/ && git pull

modules-show:
	hugo mod graph
modules-optimize:
	hugo mod tidy
# /modules
##############################################

hugo-bootstrap:
	git submodule add https://github.com/razonyang/hugo-theme-bootstrap themes/hugo-theme-bootstrap
	git submodule add https://github.com/kakawait/hugo-tranquilpeak-theme.git themes/tranquilpeak
	git submodule add https://github.com/zzossig/hugo-theme-zzo themes/zzo

install:
	sudo apt install hugo
	git submodule update --init --recursive


gemini-cp:
	echo These are manually maintained yet quite easy to redo.
	cp -R gemini/out/zzo/it/ zzo.ricc.rocks/content/it/posts/gemini/
	mkdir -p zzo.ricc.rocks/content/de/posts/gemini/
	cp -R gemini/out/zzo/de/ zzo.ricc.rocks/content/de/posts/gemini/
	rsync -avz gemini/doc/posts/medium/ zzo.ricc.rocks/content/en/posts/medium/
# TODO quando te la senti rwynca TUTTO e poi togli doppioni tipo Musica Famiglia etc..
#rsync -avz gemini/doc/posts/TUTTO zzo.ricc.rocks/content/en/posts/TUTTO/
# Magari prima crea scriptino per togliere chirurgicamente roba copincollata prima che bloati di brutto.
