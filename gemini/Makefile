
build-all:
#	echo Rebuild ing safely...
	OVERWRITE_FILES=False ruby bin/build-all.rb
	make push-to-local-code

force-rebuild:
	OVERWRITE_FILES=true ruby bin/build-all.rb
	make push-to-local-code

push-to-local-code:
	echo Copying all my files to the proper local folder for ZZO..
	cd .. && make gemini-cp
