
e2e:
	echo Il sogno e di dfare tutto end2end cominciando da un sotto-paragrafo o per PATH o per REGEX. Cominciamo da PATH.
	#RESTRICTED_PATH='src/posts/original-work/life/learning-german-in-zurich'
	OVERWRITE_EXISTING_OUT_FILES=TRUE INPUT_SUBFOLDER='original-work/life/learning-german-in-zurich' LANGUAGES=jp ruby bin/build-all.rb

build-all-cached:
	MAX_ARTICLES='500' ruby bin/build-all.rb

build-all:
#	echo Rebuild ing safely...
	OVERWRITE_EXISTING_OUT_FILES=False ruby bin/build-all.rb
#make push-to-local-code

remake-all:
	make cleanup-local-output-cache
	make build-all
jp:
#	LANGUAGES=jp OVERWRITE_EXISTING_OUT_FILES=TrUe ruby bin/build-all.rb
	LANGUAGES=jp ruby bin/build-all.rb
it:
#	LANGUAGES=it OVERWRITE_EXISTING_OUT_FILES=TrUe ruby bin/build-all.rb
	LANGUAGES=it ruby bin/build-all.rb
fr:
	LANGUAGES=fr ruby bin/build-all.rb
#	LANGUAGES=fr OVERWRITE_EXISTING_OUT_FILES=TrUe ruby bin/build-all.rb
de:
	LANGUAGES=de ruby bin/build-all.rb

all-langs-rewriting:
	LANGUAGES=it,jp,de,fr OVERWRITE_EXISTING_OUT_FILES=TrUe ruby bin/build-all.rb

rebuild-madeira:
#	echo Rebuild ing safely... TODO(implement me)
	OVERWRITE_EXISTING_OUT_FILES=TrUe ruby bin/build-all.rb --file-regex '20230210-madeira'

########################################################
# Force rebuild tests - this is for Dev FB Loop
########################################################
force-rebuild:
	OVERWRITE_EXISTING_OUT_FILES=true MAX_ARTICLES='3000000' ruby bin/build-all.rb
	make push-to-local-code

force-rebuild-three:
	OVERWRITE_EXISTING_OUT_FILES=true MAX_ARTICLES='3' ruby bin/build-all.rb
	yellow Not pushing.. For that do a:  make push-to-local-code
#	make push-to-local-code

force-rebuild-locally:
	OVERWRITE_EXISTING_OUT_FILES=true MAX_ARTICLES='2' ruby bin/build-all.rb
	yellow Not pushing.. For that do a:  make push-to-local-code

force-rebuild-5-with-pro:
	GEMINI_MODEL='gemini-1.5-pro' 	OVERWRITE_EXISTING_OUT_FILES=true MAX_ARTICLES='5' ruby bin/build-all.rb
	echo no push then..


########################################################
# Push ALL when done
########################################################
push-to-local-code:
	echo OBSOLETE now the ruby code does this automagically.
#	echo Copying all my files to the proper local folder for ZZO..
#	cd .. && make gemini-cp

cleanup-local-output-cache:
# rm -rf out/zzo/de/
# rm -rf out/zzo/fr/
# rm -rf out/zzo/it/
# rm -rf out/zzo/jp/
	rm -rf out/zzo/*/

test:
	ruby tests/test_all_headers_are_correct_yaml.rb
	ruby tests/find-bad-headers.rb
