 [![hugo + netlify](https://res.cloudinary.com/dzkoxrsdj/image/upload/v1656562989/template_1_edyp8b.png)](https://ntl.fyi/3P9w1mr)

 [![ricc.rocks Netlify Status](https://api.netlify.com/api/v1/badges/444a5ada-1134-4e5c-9691-3a4a33799ab4/deploy-status)](https://app.netlify.com/sites/ricc-zzo/deploys)

Sessionize: https://sessionize.com/riccardo-carlesso

Self: https://github.com/palladius/ricc.rocks/

## Notes from 2024 refurbishing

* Home: https://ricc.rocks/en/ (ZZO).

# Ciao da Riccardo

Self: https://github.com/palladius/ricc.rocks

This my 2023 attempt at an auto-managed Hugo website.
I might be porting soon my [personal website](http://www.palladius.it/) here.
Since I can't decide among a few different modules, I'm testing a number of those in terms of:

* Look and feel
* Functionalities

Current Hugo installations [comparison](https://ricc.rocks/posts/posts-symlink/2023-01-29-symlinked-themes-compared.d/symlinked-themes-compared/).

Still evaulating, hence I've created a RING of many versions, and use symlinks to recycle some articels (although the metadata is sometimes incompatible among them, yielding to unexpected *NxM* errors):

* 😍 ⭐️⭐️⭐️⭐️⭐️ **Boostrap**: https://hugo-bootstrap-ricc-rocks.netlify.app/
* 😍 ⭐️⭐️⭐️⭐️⭐️ **Stack**:    https://hugo-stack.ricc.rocks/
* 😐 ⭐️⭐️⭐️ **Papermod**: https://ricc.rocks/ (a bit simplistic although has some [**amazing functionalities**](https://ricc.rocks/posts/papermod-analysis-page/).
* 😩 ⭐️⭐️ **Ananke**: https://hugo-ananke.netlify.app/ Too simple.
* 😩 ⭐️ **Coder**: Naah, too simple for me.

* 🚧 [WIP] **Tranquilpeak**.  https://tranquilpeak.netlify.app/
* 🚧 [WIP] **ZZO**. https://ricc-zzo.netlify.app/en/ => https://ricc.rocks/

# customization

* following this free course: https://www.youtube.com/watch?v=hjD9jTi_DQ4
* `hugo new posts/first.md`

## PaperMod

* git clone https://github.com/adityatelange/hugo-PaperMod themes/PaperMod --depth=1

## Bootstrap

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

doesnt work -> tried `1. Create a New Site from Scratch` instead.

## Ananke (deprecated)

Abandoned. Moved to .vecchiume/ .
Still populated here: https://hugo-ananke-vecchiume.netlify.app/
[![Netlify Status](https://api.netlify.com/api/v1/badges/9c6fdacc-6b9f-4908-b3e5-57f1dc2b8f50/deploy-status)](https://app.netlify.com/sites/hugo-ananke-vecchiume/deploys)



## Does it compile?

*  [![ZZO ricc.rocks Netlify Status](https://api.netlify.com/api/v1/badges/444a5ada-1134-4e5c-9691-3a4a33799ab4/deploy-status)](https://app.netlify.com/sites/ricc-zzo/deploys)
* [![Hugo Bootstrap Netlify Status](https://api.netlify.com/api/v1/badges/0441c68e-204c-4020-aebf-1a2afa7420e4/deploy-status)](https://app.netlify.com/sites/hugo-bootstrap-ricc-rocks/deploys)
