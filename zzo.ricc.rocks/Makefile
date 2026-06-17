
run:
	@which hugo >/dev/null 2>&1 && hugo server --disableFastRender || npx -y hugo-extended server --disableFastRender

build:
	echo "Riccardo JFYI questo e' quel che Netlify runna.."
	@which hugo >/dev/null 2>&1 && hugo --minify || npx -y hugo-extended --minify

help:
	echo Read the docs for Hugo and recipe for cocktail.



new-post:
	@which hugo >/dev/null 2>&1 && hugo new posts/my-first-post.md || npx -y hugo-extended new posts/my-first-post.md

clean:
	rm -rf resources/_gen/ public/

midjourney-move:
	bin/move-midjourney-pics-to-here.sh

test:
	@which hugo >/dev/null 2>&1 && hugo --minify || npx -y hugo-extended --minify
