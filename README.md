 [![hugo + netlify](https://res.cloudinary.com/dzkoxrsdj/image/upload/v1656562989/template_1_edyp8b.png)](https://ntl.fyi/3P9w1mr)

# Ciao da Riccardo

This my 2023 attempt at an auto-managed Hugo website.
I might be porting soon my [personal website](http://www.palladius.it/) here.


* changed module part in `config.toml`.

## customization

* following this free course: https://www.youtube.com/watch?v=hjD9jTi_DQ4
* `hugo new posts/first.md`

## moving to PaperMod

* git clone https://github.com/adityatelange/hugo-PaperMod themes/PaperMod --depth=1

## Creating a Bootstrap one

$ git submodule add https://github.com/razonyang/hugo-theme-bootstrap themes/hugo-theme-bootstrap
$ mkdir hugo-bootstrap.ricc.rocks
 follow https://hbs.razonyang.com/v1/en/docs/getting-started/installation/git-submodule/

```
mkdir config content archetypes static assets
cp -a /tmp/hbs-skeleton/config/* ./config
cp -r /tmp/hbs-skeleton/content/* ./content
cp -r /tmp/hbs-skeleton/archetypes/* ./archetypes
cp -r /tmp/hbs-skeleton/static/* ./static
cp -r /tmp/hbs-skeleton/assets/* ./assets
sed -i "s/theme:.*/theme: hugo-theme-bootstrap/g" config/_default/config.yaml
hugo mod npm pack
npm install
hugo server

```
