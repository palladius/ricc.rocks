---
title: "🏆 PaperMod comparative analysis"
date: 2020-09-15T11:30:03+00:00
weight: 1
aliases: ["/first"]
tags: [test, paperMod, image]
author: "Me"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "Just a sample page on PaperMod"
# awesome!
#canonicalURL: "https://canonical.url/to/page"
disableHLJS: false # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
searchHidden: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
#math: true
cover:
    image: /imagez/riccardo-turtle.jpg
#    image: /riccardo-turtle.jpg
    #image: https://nationaltoday.com/wp-content/uploads/2021/05/Paperclip-1.jpg
    # papermod.ricc.rocks/static/images/riccardo-simpson-black.jpg
    #image: "<image path/url>" # image path/url
    #alt: "<alt text>" # alt text
    #caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: false # only hide on current single page
# Works thanks to config.yaml - ignore here its just automagical.
editPost:
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link
cover:
  #image: /riccardo-turtle.jpg
  #image: /images/yellow-desktop-wallpaper.jpg
  #image: /imagez/riccardo-turtle.jpg
  #image: riccardo-giallo-raja-ampat.jpg
  image: images/riccardo-giallo-raja-ampat.jpg
  image: /images/riccardo-simpson-black.jpg
---
Very complex page

## Suggest Changes

It works! Try it here on top! Goes directly to github! (https://github.com/palladius/ricc.rocks/tree/main/papermod.ricc.rocks/content/posts/papermod-analysis-page.md in this case). Just fails with symilnks, but you cant have it all :P

## test emoji (failed)

testing emojis: :see_no_evil:
:hear_no_evil: :speak_no_evil:

## Test Math

Math poorly documented here: https://github.com/adityatelange/hugo-PaperMod/blob/exampleSite/content/posts/math-typesetting.md
Finally this site fixed it for me: https://discourse.gohugo.io/t/how-to-render-math-equations-properly-with-katex/40998

See inline:

 $$\int_{-\infty}^{\infty} e^{-x^2} dx$$  <!-- works -->

Inline math:

$$\(\varphi = \dfrac{1+\sqrt5}{2}= 1.6180339887…\)$$


<!-- this does NOT work.
{ { < math.inline > } }
{ { } }
-->

$${a}^{b} - \overbrace{c}^{d}$$  <!-- works-->

$$\underbrace{a}_{b} - \underbrace{c}_{d}$$  <!--does not work -->


Finish inline.


## test Youtube (ok)

Piaynemo:
{{< youtube QW4XBtibFnk >}}

Firth of fifth on piano:

{{< youtube 4VBxd9n1dSU >}}

## test images (ok)

A few images in /images/ mode.

![Scenario 2: Across columns](/images/riccardo-giallo-raja-ampat.jpg)
![Riccardo Simpson](/images/riccardo-simpson-black.jpg)
![Scenario 1: Across columns](/images/cloud-connect.png)
