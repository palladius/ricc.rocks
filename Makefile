
run-p1313:
	hugo server

run-p1313-with-drafts:
	hugo server --buildDrafts

commands-sample:
	hugo new posts/my-first-post.md

##############################################
# modules: https://gohugo.io/hugo-modules/use-modules/
# https://github.com/adityatelange/hugo-PaperMod/wiki/Installation
modules-update:
	hugo mod get -u
	cd themes/PaperMod/ && git pull

modules-show:
	hugo mod graph
modules-optimize:
	hugo mod tidy
# /modules
##############################################
