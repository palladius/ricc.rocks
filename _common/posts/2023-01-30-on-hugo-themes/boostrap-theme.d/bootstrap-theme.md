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
<i class="fas fa-clock"></i>
<i class="far fa-address-book"></i>
<i class="fab fa-amazon"></i>
<i class="fab fa-google"></i>

Icon colors (non va 😭):

<i class="fab fa-clock text-success"></i>
<i class="fab fa-clock text-danger"></i>
<i class="fab fa-clock" style="color: blue"></i>
<i class="fas fa-clock" style="color: pink"></i>
<i class="far fa-clock text-success"></i>
<i class="fa fa-clock text-danger"></i>

<i class="fab fa-google"  style="color: #4285F4"></i>
<i class="fab fa-google"  style="color: #DB4437"></i>
<i class="fab fa-google"  style="color: #F4B400"></i>
<i class="fab fa-google"  style="color: #0F9D58"></i>

it works! I just had to enable unsafe thingy in config :)

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

Docs in here: https://hbs.razonyang.com/v1/en/docs/shortcodes/gallery/

Files: <i class="fab fa-google"></i>

```
RiccardoGoogleyBike.png           riccardo-giallo-raja-ampat.jpeg   riccardo-raja-ampat.jpeg
riccardo-2022.png                 riccardo-jogging-telaviv.jpeg     riccardo-rajaampat.png
riccardo-bicicletta-gugol.jpg     riccardo-jump-ironman.jpeg        riccardo-scuba-in-google.jpeg
riccardo-canary-ravenna.jpeg      riccardo-kids-christmas.jpeg      riccardo-smiles-swim-ironman.jpeg
```

{{< gallery images="images/riccardo/RiccardoGoogleyBike.png,images/riccardo/riccardo-giallo-raja-ampat.jpeg,/images/riccardo/riccardo-2022.png,/images/riccardo/riccardo-jogging-telaviv.jpeg,/images/riccardo/riccardo-rajaampat.png,/images/riccardo/riccardo-bicicletta-gugol.jpg,/images/riccardo/riccardo-jump-ironman.jpeg,/images/riccardo/riccardo-scuba-in-google.jpeg,/images/riccardo/riccardo-canary-ravenna.jpeg,/images/riccardo/riccardo-kids-christmas.jpeg,/images/riccardo/riccardo-smiles-swim-ironman.jpeg" >}}

## Videos and Colorful Alerts



{{% alert warning %}}
[WARNING] Doesn’t support Youtube embedding amongst [Media shortcodes](https://hbs.razonyang.com/v1/en/docs/shortcodes/media/) 🤦🏻 : Only Bilibili
Tencent
Youku
iQiyi
Netease Music
asciinema
{{% /alert %}}

<!-- {{% alert warning %}}
Alert Shortcode with Markdown Syntax:
```bash
$ echo 'An example of alert shortcode with the Markdown syntax'
```
{{% /alert %}} -->

{{% alert danger %}}
[danger] This is danger
{{% /alert %}}

{{% alert info %}}
[info] This is info
{{% /alert %}}

{{% alert success %}}
[success] This is ok
{{% /alert %}}

{{% alert cazzibuffi %}}
[cazzibuffi] This is cazzibuffi
{{% /alert %}}



{{< alert success >}}
{{< alert-heading >}}Well Done!{{< /alert-heading >}}
ALERT MESSAGE with heading
{{< /alert >}}

### Toggle

{{< toggle myToggleName >}}
Sobenme:
  {{< toggle-item Ruby >}}
    CONTENT HERE, MARKDOWN and SHORTCODE are support.
  {{< /toggle-item >}}
  {{< toggle-item SQL >}}
    SELECT "hello world"
  {{< /toggle-item >}}
  {{< toggle-item More.. >}}
    <tt>Toggle Shortcode</tt> is documented here:   https://hbs.razonyang.com/v1/en/docs/shortcodes/toggle/
  {{< /toggle-item >}}

  ...
{{< /toggle >}}

## Iframe

Iframe for youtube doesnt work, but YT provides a nice embed buridone which you paste and works beautifully.

<!-- Got the embed copy and paste form Youtube :) -->
<iframe width="560" height="315" src="https://www.youtube.com/embed/E3ReKuJ8ewA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<!-- This doesnt work:
{{< iframe "[URL](https://www.youtube.com/embed/E3ReKuJ8ewA)" >}} -->
