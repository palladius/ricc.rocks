
run-p1313-prod:
	HUGO_ENV=production hugo server

run-p1313-dev:
	HUGO_RICCARDO_HOSTING='RiccardoMakefile' hugo server --disableFastRender

run-p1313-with-drafts:
	hugo server --buildDrafts

commands-sample:
	hugo new posts/my-first-post.md
	hugo new --kind post 2023-01-28-prova123.md

clean:
	rm -rf resources/_gen/