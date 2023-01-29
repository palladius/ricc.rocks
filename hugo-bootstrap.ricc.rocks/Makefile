

run-p1313-prod:
	HUGO_ENV=production hugo server

run-p1313-dev:
	HUGO_RICCARDO_HOSTING='RiccardoMakefile' hugo server --disableFastRender

npm-fix:
	npm audit fix --force

install:
	hugo mod npm pack
	npm install
# from style page; https://hbs.razonyang.com/v1/en/docs/look-and-feel/#add-icons
	hugo gen chromastyles --style=solarized-dark > assets/main/scss/_highlight.scss
