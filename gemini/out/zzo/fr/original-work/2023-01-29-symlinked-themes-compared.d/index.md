---
# Note this is SUPER weird, I try to make this work for ALL my thingies so there might be some behavioural clatches in the
# initial HEADER :) Lets try to keep it small :)
title: "🇫🇷 ♊ [Geminocks] Thèmes comparés (🏆)"
date: 2023-02-05T21:17:43+01:00
draft: false
tags:
- geminocks
- French
- symlink
- hugo
- WOW
# Categories is feinitely used by STACK framework:
categories:
- hugo
- category
- important
keywords:
- tech
- hugo
- comparative
- theme
- themes
# ANANKE :)
featured_image: clone-mtg-vintage.png # /images/gohugo-default-sample-hero-image.jpg
image: clone-mtg-vintage.png
images:
- tranquilpeak-showcase.png
- clone-mtg-vintage.png
- zzo-screenshot.png
# tranquilpeak-only: https://github.com/kakawait/hugo-tranquilpeak-theme/blob/master/docs/user.md#image
thumbnailImage: https://www.etrurio.com/wp-content/uploads/2019/12/pistacchi-scaled.jpg
---

![image](clone-mtg-vintage.png)



J'ai essayé plusieurs modules ce week-end. Notez que les différents thèmes ont des mots et des paires clé/valeur différents dans la strophe ci-dessus, il vaut donc mieux ne pas les confondre.
Par exemple, cette page a une `featured_image` qui ne fonctionne qu'avec Ananke, et une `image` qui fonctionne probablement avec d'autres thèmes.

Ce que j'ai essayé jusqu'à présent :

## Liaison symbolique sur toutes les pages.

* Jusqu'à présent, je n'en ai essayé qu'un seul - Golang ne remarquera certainement pas le fichier lié symboliquement modifié.
* Notez que STACK est actuellement dans un endroit DIFFÉRENT. Laissez-moi le déplacer pour une seconde.

## Mes sites Web Hugo que j'ai essayés jusqu'à présent

Tout le code se trouve dans différents répertoires de mon référentiel GH : https://github.com/palladius/ricc.rocks/

| Thème + PermaCompare | Site Web     | Étoiles |  Description |
| ----------- | ----------- | ------ | ---- |
| Bootstrap   | [hugo-bootstrap-ricc-rocks](https://hugo-bootstrap-ricc-rocks.netlify.app/) | ⭐️⭐️⭐️⭐️⭐️ | Tout simplement incroyable |
| Stack       | [hugo-stack.ricc.rocks](https://hugo-stack.ricc.rocks) |⭐️⭐️⭐️⭐️⭐️ | J'ai beaucoup joué avec. Notez qu'il se trouve dans un référentiel différent |
| ----------- | ----------- | ------ | ----  |
| [🙉](https://ricc-zzo.netlify.app/en/posts/riccardo/prova-zzo/) ZZO         | [ricc-zzo.netlify.app)](https://ricc-zzo.netlify.app/en/) | ⭐️⭐️⭐️⭐️⭐️ | Il a les icônes comme je les aime, très ludique, mais plein de fonctionnalités splendides. J'aime beaucoup !  |

(*) Permacompare : permalien en production vers la page de comparaison :)

* **PaperMod** : ça marche ! https://papermod.ricc.rocks	 pas encore beaucoup exploré. Page de comparaison : https://papermod.ricc.rocks/posts/papermod-analysis-page/  [🙉](https://ricc.rocks/posts/papermod-analysis-page/) PaperMod |⭐️⭐️⭐️⭐️   | Super élégant. Essentiel mais bon sang, tellement bon dans son essence ! |
* **Stack** : Tout d'abord, il a des [mathématiques](https://dev.stack.jimmycai.com/p/math-typesetting/). https://hugo-stack.ricc.rocks  ensuite, je l'adore !
* **Bootstrap** : https://hugo-bootstrap-ricc-rocks.netlify.app/
* 🚧 [WIP] **Tranquilpeak**.  https://tranquilpeak.netlify.app/ A des mathématiques
* 🚧 [WIP] **ZZO**. https://ricc-zzo.netlify.app/en/

Batailles perdues :

* **Coder** : Non, trop simple pour moi.
* Ananke. Trop simple - https://hugo-ananke.netlify.app/

## Albums photos

* Seul XXX semble avoir des albums photos décents. Cependant, les gens disent "j'aimerais que votre thème soit aussi bon que Photoswipe", donc je pense que je pourrais juste faire fonctionner [**PhotoSwipe**](https://photoswipe.com/) avec n'importe quoi d'autre : voir [HugoPhotoSwipe](https://github.com/GjjvdBurg/HugoPhotoSwipe).
* Peut-être vérifier https://github.com/liwenyip/hugo-easy-gallery mais je ne pense pas que cela en vaille la peine. (505 ⭐️).
* Ou simplement le coder (j'aimerais que ce soit en Ruby et non en Golang) : https://hugocodex.org/add-ons/image-gallery/
* Ou utiliser cette [bibliothèque géniale](https://github.com/mfg92/hugo-shortcode-gallery) : démo dans https://matze.rocks/images/#gallery-filter=Landscape



## ZZO

![Redimensionner](zzo-screenshot.png?width=300px)

* **Page de comparaison** : https://ricc-zzo.netlify.app/en/posts/riccardo/prova-zzo/
* Installer : https://zzo-docs.vercel.app/
* Thème GH : https://github.com/zzossig/hugo-theme-zzo
* Version Ricc : https://ricc-zzo.netlify.app/

Fonctionnalités :

```
Plusieurs apparences (sombre, clair, solarisé, ...)
Menu mobile
Recherche
Optimisation pour les moteurs de recherche (SEO)
Multilingue (i18n)
Design réactif
Interface utilisateur personnalisable
RSS
Galerie
Surlignage de code rapide
Page de conférences
Page de présentation
Page de publication
Page de CV
Page de présentation
```




## Bootstrap

* Documentation sur les images : https://hbs.razonyang.com/v1/en/docs/image-processing/#resizing-images Plein de bonnes choses ici, j'ai aussi trouvé un bug et le gars l'a corrigé en 24h - INCROYABLE.
* Documentation sur la galerie : https://hbs.razonyang.com/v1/en/docs/shortcodes/gallery/




# Vieilles choses

## PaperMod

J'ai passé peu de temps jusqu'à présent - mais c'est de ma faute, pas de la sienne :)

Documentation : https://github.com/adityatelange/hugo-PaperMod/

NEUTRE :

* Prend en charge [de nombreuses icônes](https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-icons/#social-icons), mais je ne sais pas comment les utiliser
* [Prend en charge les mathématiques](https://adityatelange.github.io/hugo-PaperMod/posts/math-typesetting/), mais je ne sais pas comment le faire fonctionner/
* Les emojis sont sympas, une fois activés, vous pouvez faire 🙈 :see_no_evil: 🙉 :hear_no_evil: 🙊 :speak_no_evil:

MAUVAIS 😩 :

* Trop simple. Il n'y a rien sur moi en tant que blogueur, c'est juste un pur (et élégant) conteneur pour les nouvelles. Rien sur Riccardo, juste mes articles.


## Ananke ⭐️⭐️

Statut : [![Statut Netlify](https://api.netlify.com/api/v1/badges/9c6fdacc-6b9f-4908-b3e5-57f1dc2b8f50/deploy-status)](https://app.netlify.com/sites/hugo-ananke/deploys)
Ancien :
* [hugo-ananke.netlify.app](https://hugo-ananke.netlify.app)
* Historiquement le premier que j'ai essayé. Je n'ai pas beaucoup exploré

BON 😍 :

* À FAIRE

MAUVAIS 😩 :

* **Trop simple**. Par exemple, le formulaire de contact est parmi les articles (sérieusement ?)
* Pas de galerie d'images, j'ai peur


## TranquilPeak

![image](tranquilpeak-showcase.png)

* GH : https://github.com/kakawait/hugo-tranquilpeak-theme
* 861 étoiles / 515 fourchettes
* Site de démonstration :
* Licence : GPL
* Installer : https://github.com/kakawait/hugo-tranquilpeak-theme/blob/master/docs/user.md

Comment utiliser la balise d'image (enfin !) : https://github.com/kakawait/hugo-tranquilpeak-theme/blob/master/docs/user.md#image


PLUS

* Beaux graphismes
* Galeries intégrées

MOINS

* Dit que FS ne prend pas en charge les liens symboliques pour les images. Mais il les prend en charge pour les articles
* Louche dans l'organisation du contenu/des articles. Si je déplace du contenu dans ou hors des répertoires, il disparaît. Bizarre. (Il y a peut-être une bonne raison à cela, mais cela ressemble à un bug par rapport à d'autres thèmes où vous pouvez tout déplacer dans le contenu/)






*(Generated by Geminocks: https://github.com/palladius/ricc.rocks/tree/main/gemini prompt_version=1.4)*