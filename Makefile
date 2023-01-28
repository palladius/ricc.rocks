
run-p1313:
	hugo server

run-p1313-with-drafts:
	hugo server --buildDrafts

commands-sample:
	hugo new posts/my-first-post.md

##############################################
# modules: https://gohugo.io/hugo-modules/use-modules/
modules-update:
	hugo mod get -u
modules-show:
	hugo mod graph
modules-optimize:
	hugo mod tidy
# /modules
##############################################
