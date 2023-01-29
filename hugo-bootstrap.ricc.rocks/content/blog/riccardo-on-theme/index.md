---
title: "Riccardo: what I learnt on HBS"
date: 2023-01-17T16:35:29+08:00
draft: false
tags:
  - README
  - Riccardo
#images:
#- /images/riccardo/riccardo-smiles-swim-ironman.jpeg
images:
- /images/riccardo/riccardo-2022.png
- /images/riccardo/riccardo-jogging-telaviv.jpeg
- /images/riccardo/riccardo-rajaampat.png- /images/riccardo/riccardo-bicicletta-gugol.jpg
- /images/riccardo/riccardo-jump-ironman.jpeg
- /images/riccardo/riccardo-scuba-in-google.jpeg- /images/riccardo/riccardo-canary-ravenna.jpeg
- /images/riccardo/riccardo-kids-christmas.jpeg
- /images/riccardo/riccardo-smiles-swim-ironman.jpeg
---
<!-- ![boh](/images/riccardo/riccardo-smiles-swim-ironman.jpeg) -->

See also [README.md](https://github.com/razonyang/hugo-theme-bootstrap-skeleton/blob/main/README.md).

<!--more-->

## Useful links

* Base Markdown HBS info: https://hbs.razonyang.com/v1/en/posts/markdown-syntax
* [Image processing](https://hbs.razonyang.com/v1/en/docs/image-processing/#resizing-images) (only when you got images to work :P)

## Images tests

I was unable to import images from Local folder, unless its called `featured-sample.jpg` or `featured-sample.webp`,
then it picks it up automagically. Pretty neat.

It tells you how to put images left, right, up, down, but not to fit with text which is my fav features. Dammit.

![Float End](/images/riccardo/riccardo-smiles-swim-ironman.jpeg?width=300px#float-end). lorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsum
lorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsum
lorem ipsum

Yes, exactly.

![Resize](/images/riccardo/riccardo-smiles-swim-ironman.jpeg?width=300px) lorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsum lorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsum

anche la float end spinge. Boh I'm unable


## test CSS / JS


Riccardo trying out icons as per [LookNFeel](https://hbs.razonyang.com/v1/en/docs/look-and-feel) docs:
<i class="fas fa-clock">aa</i>
<i class="far fa-address-book">AB</i>
<i class="fab fa-amazon">a</i>
<i class="fab fa-google">G</i>
and again Gugol
<i class="fab fa-google"></i>

icon colors (non va 😭):
<i class="fas fa-clock text-success">ok</i>
<i class="fas fa-clock text-danger">dang</i>
<i class="far fa-clock" style="color: blue">blue</i>
<i class="far fa-clock" style="color: pink">pink</i>
<i class="fa fa-clock text-success">ok2</i>
<i class="far far-clock text-danger">dang2</i>

## Code tests

{{< code-toggle >}}
{
    "logo": "/images/logo.png",
    "customCSS": ["foo.css", "bar.css"],
    "codeBlock": {
        "maxLines": 10
    }
}{{</ code-toggle >}}

## Test Gallery
RiccardoGoogleyBike.png           riccardo-giallo-raja-ampat.jpeg   riccardo-raja-ampat.jpeg
riccardo-2022.png                 riccardo-jogging-telaviv.jpeg     riccardo-rajaampat.png
riccardo-bicicletta-gugol.jpg     riccardo-jump-ironman.jpeg        riccardo-scuba-in-google.jpeg
riccardo-canary-ravenna.jpeg      riccardo-kids-christmas.jpeg      riccardo-smiles-swim-ironman.jpeg

{{< gallery images="images/riccardo/RiccardoGoogleyBike.png,images/riccardo/riccardo-giallo-raja-ampat.jpeg,/images/riccardo/riccardo-2022.png,/images/riccardo/riccardo-jogging-telaviv.jpeg,/images/riccardo/riccardo-rajaampat.png,/images/riccardo/riccardo-bicicletta-gugol.jpg,/images/riccardo/riccardo-jump-ironman.jpeg,/images/riccardo/riccardo-scuba-in-google.jpeg,/images/riccardo/riccardo-canary-ravenna.jpeg,/images/riccardo/riccardo-kids-christmas.jpeg,/images/riccardo/riccardo-smiles-swim-ironman.jpeg" >}}
