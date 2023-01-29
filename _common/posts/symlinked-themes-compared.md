---
# Note this is SUPER weird, I try to make this work for ALL my thingies so there might be some behavioural clatches in the
# initial HEADER :) Lets try to keep it small :)
title: "Symlinked Themes Compared"
date: 2023-01-28T21:17:43+01:00
draft: false
featured_image: /images/gohugo-default-sample-hero-image.jpg
---

I tried many modules this weekend. Let's see how [Ananke](https://github.com/theNewDynamic/gohugo-theme-ananke) goes.

* seems SUPER simple. So featureless wrt to others, but also so easier to use.
* Uses FormSpree for contact form [contact](/posts/contact). Works like a charm.
* images. See [Scuba diving](/posts/first-scuba/) page to see if it works.

What I've tried so far:

## Symlinking across all pages.

* so far only tried one - definitely golang won't notice the changed symlinked file.
*
## My Hugo websites I've tried so far

| Theme  | Website     | Stars | Description |
| ----------- | ----------- | ------ | ----------- |
| Ananke      | [hugo-ananke.netlify.app](https://hugo-ananke.netlify.app)        | ⭐️⭐️⭐️ | Historically the first ive tried. Havent explored much |
| PaperMod    | [ricc.rocks](https://ricc.rocks/) |⭐️⭐️⭐️⭐️⭐️      | Very little effort done here |
| Stack       | [hugo-stack.ricc.rocks](https://hugo-stack.ricc.rocks) |⭐️⭐️⭐️⭐️⭐️ | played A LOT with it |
| Bootstrap   | [hugo-bootstrap-ricc-rocks](https://hugo-bootstrap-ricc-rocks.netlify.app/) | ⭐️⭐️⭐️⭐️⭐️ | played a lot |


* **PaperMod**: https://hugo-stack.ricc.rocks it works!
* **Stack**:
* **Bootstrap**: https://hugo-bootstrap-ricc-rocks.netlify.app/


## Photo Albyums

* Only XXX seems to have decent photo albums. However, people are saying "i wish your theme was as good as Photoswipe" so I believe I might just get [**PhotoSwipe**](https://photoswipe.com/) to work with anything else: see [HugoPhotoSwipe](https://github.com/GjjvdBurg/HugoPhotoSwipe).
* maybe check https://github.com/liwenyip/hugo-easy-gallery but i dont think its worht it. (505 ⭐️).
* Or just code it (I wish it was Ruby and not Golang): https://hugocodex.org/add-ons/image-gallery/
* or use this [awesome library](https://github.com/mfg92/hugo-shortcode-gallery): demo in https://matze.rocks/images/#gallery-filter=Landscape


## Ananke

GOOD:
*
BAD:
* too simple. congtact form is amongst posts (seriously?)
