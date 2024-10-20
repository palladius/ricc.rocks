
build-all:
	echo Rebuild ing safely...
	OVERWRITE_FILES=False ruby bin/build-all.rb
	make push-to-local-code

force-rebuild:
	OVERWRITE_FILES=true ruby bin/build-all.rb
	make push-to-local-code

push-to-local-code:
	cd .. && make gemini-cp
