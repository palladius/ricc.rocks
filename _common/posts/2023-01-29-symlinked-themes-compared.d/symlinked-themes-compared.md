---
# Note this is SUPER weird, I try to make this work for ALL my thingies so there might be some behavioural clatches in the
# initial HEADER :) Lets try to keep it small :)
title: "💦 Symlinked Themes Compared (🏆)"
date: 2023-01-28T21:17:43+01:00
draft: false
tags: 
- symlink
- hugo
# ANANKE :)
featured_image: /images/gohugo-default-sample-hero-image.jpg
image: /images/mtg-clone.jpg
---


I tried many modules this weekend. Note that different themes have different words and key/vals in the above stanza so I better not confuse them.
For instance, this page has a `featured_image` which only works with Ananke, and a `image` which probably works with other themes.

What I've tried so far:

## Symlinking across all pages.

* so far only tried one - definitely golang won't notice the changed symlinked file.
*
## My Hugo websites I've tried so far

All the code is in different directories of my GH repo: https://github.com/palladius/ricc.rocks/

| Theme  | Website     | Stars | Description |
| ----------- | ----------- | ------ | ----------- |
| Ananke      | [hugo-ananke.netlify.app](https://hugo-ananke.netlify.app)   (broken)     | ⭐️⭐️⭐️ | Historically the first ive tried. Havent explored much |
| PaperMod    | [ricc.rocks](https://ricc.rocks/) |⭐️⭐️⭐️⭐️      | Very little effort done here |
| Stack       | [hugo-stack.ricc.rocks](https://hugo-stack.ricc.rocks) |⭐️⭐️⭐️⭐️⭐️ | played A LOT with it |
| Bootstrap   | [hugo-bootstrap-ricc-rocks](https://hugo-bootstrap-ricc-rocks.netlify.app/) | ⭐️⭐️⭐️⭐️⭐️ | played a lot |


* **PaperMod**: it works! https://ricc.rocks/ not explored much yet. Comparison page: https://ricc.rocks/posts/papermod-analysis-page/
* **Stack**: First, has [math](https://dev.stack.jimmycai.com/p/math-typesetting/). https://hugo-stack.ricc.rocks  then I just love it!
* **Bootstrap**: https://hugo-bootstrap-ricc-rocks.netlify.app/
* **Coder**: Naah, too simple for me.

## Photo Albums

* Only XXX seems to have decent photo albums. However, people are saying "i wish your theme was as good as Photoswipe" so I believe I might just get [**PhotoSwipe**](https://photoswipe.com/) to work with anything else: see [HugoPhotoSwipe](https://github.com/GjjvdBurg/HugoPhotoSwipe).
* maybe check https://github.com/liwenyip/hugo-easy-gallery but i dont think its worht it. (505 ⭐️).
* Or just code it (I wish it was Ruby and not Golang): https://hugocodex.org/add-ons/image-gallery/
* or use this [awesome library](https://github.com/mfg92/hugo-shortcode-gallery): demo in https://matze.rocks/images/#gallery-filter=Landscape


## Ananke

GOOD 😍:

* TODO

BAD 😩:

* **too simple**. Eg, contact form is amongst posts (seriously?)

## PaperMod

I spent little time so far - but its just my fault, not his :)

Docs: https://github.com/adityatelange/hugo-PaperMod/

NEUTRAL:

* supports [many icons](https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-icons/#social-icons), but unsure how to use them
* [Supports Maths](https://adityatelange.github.io/hugo-PaperMod/posts/math-typesetting/), but unsure on how to make it work/
* emoji are nice, once enaled you can do 🙈 :see_no_evil: 🙉 :hear_no_evil: 🙊 :speak_no_evil:

BAD 😩:

* too simple. Doesnt have something about me as a blogger, its just a pure (sleek) container for news. Nothing about Riccardo, just my articles.