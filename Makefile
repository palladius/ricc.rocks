
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


gemini-feedback-loop:
	echo '1. Create content'
	cd gemini && make
	echo '2. copy to ZZO'
	make gemini-cp

gemini-cp: clean
	echo These are manually maintained yet quite easy to redo.
#	cp -R gemini/out/zzo/it/ zzo.ricc.rocks/content/it/posts/gemini/
	echo '1. Copia originali in inglese 🏴󠁧󠁢󠁥󠁮󠁧󠁿'
	rsync -avz gemini/doc/posts/medium/ zzo.ricc.rocks/content/en/posts/medium/
# TODO quando te la senti rsynca TUTTO e poi togli doppioni tipo Musica Famiglia etc..
	#rsync -avz gemini/doc/posts/TUTTO zzo.ricc.rocks/content/en/posts/TUTTO/
# Magari prima crea scriptino per togliere chirurgicamente roba copincollata prima che bloati di brutto.

# Copy German too..
	echo 'Now 🇩🇪 German stuff'
	# Cleanup first
	cp -R gemini/out/zzo/de/ zzo.ricc.rocks/content/de/posts/gemini/ || true
#	rsync -avz gemini/out/zzo/de/medium/ zzo.ricc.rocks/content/de/posts/medium/ || true
# Copy French too.. TODO to script..
	echo 'Now 🇫🇷 French stuff'
	cp -R gemini/out/zzo/fr/ zzo.ricc.rocks/content/fr/posts/gemini/ || true
#	rsync -avz gemini/out/zzo/fr/medium/ zzo.ricc.rocks/content/fr/posts/medium/ || true
# Copy French too.. TODO to script..
	echo 'Now 🇮🇹 Italian stuff'
	cp -R gemini/out/zzo/it/ zzo.ricc.rocks/content/it/posts/gemini/ || true
#	rsync -avz gemini/out/zzo/it/medium/ zzo.ricc.rocks/content/it/posts/medium/ || true
	echo 'Now 🇯🇵 Japanese stuff - tsugoi!'
	cp -R gemini/out/zzo/jp/ zzo.ricc.rocks/content/jp/posts/gemini/  || true
#	rsync -avz gemini/out/zzo/jp/medium/ zzo.ricc.rocks/content/jp/posts/medium/ || true

	@echo '🍀 We made it to the end!'

clean:
	rm -rf zzo.ricc.rocks/content/de/posts/gemini/
	rm -rf zzo.ricc.rocks/content/fr/posts/gemini/
	rm -rf zzo.ricc.rocks/content/it/posts/gemini/
	rm -rf zzo.ricc.rocks/content/jp/posts/gemini/
	gemini/bin/cleanup-for-language.rb de
	gemini/bin/cleanup-for-language.rb fr
	gemini/bin/cleanup-for-language.rb it
	mkdir -p zzo.ricc.rocks/content/de/posts/gemini/
	mkdir -p zzo.ricc.rocks/content/fr/posts/gemini/
	mkdir -p zzo.ricc.rocks/content/it/posts/gemini/
	mkdir -p zzo.ricc.rocks/content/jp/posts/gemini/


hugo-install:
	echo 'on Debian: sudo snap install hugo'

test-tranquilpeak:
	cd tranquilpeak.ricc.rocks/ && hugo
	echo '✅ tranquilpeak: Everything ok'

test-bootstrap:
	cd hugo-bootstrap.ricc.rocks/ && hugo
	echo '✅ bootstrap: Everything ok'


test-zzo:
	cd zzo.ricc.rocks && make test
	echo '✅ ZZO: Everything ok with zzo'

test: test-zzo test-bootstrap test-tranquilpeak
	echo Delegating tests to Gemini and ZZO...
#hugo --minify
	cd gemini && make test
#	find zzo.ricc.rocks/ -name \*.md | xargs head -1 | grep --  '!--'
