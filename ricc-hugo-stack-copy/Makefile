
dev: run-dev

run-dev:
	hugo server --disableFastRender
run-prod:
	hugo server

modules-blah:
	hugo mod get -u github.com/CaiJimmy/hugo-theme-stack/v3
	hugo mod tidy

hugo-theme-stack-removeme:
	git clone https://github.com/CaiJimmy/hugo-theme-stack hugo-theme-stack-removeme

submodules:
# from https://stack.jimmycai.com/guide/getting-started
	git submodule add https://github.com/CaiJimmy/hugo-theme-stack/ themes/hugo-theme-stack

#test:
install:
#	hugo version || gem install hugo
	hugo version || brew install hugo
