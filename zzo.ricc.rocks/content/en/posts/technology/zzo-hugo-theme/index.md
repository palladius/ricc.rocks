---
# Note this is SUPER weird, I try to make this work for ALL my thingies so there might be some behavioural clatches in the
# initial HEADER :) Lets try to keep it small :)
title: "About ⬢ Hugo ZZO theme"
date: 2023-01-31T21:17:43+01:00
draft: false
pinned: false # (ZZO) lo voglio in cima
tags:
- symlink
- hugo
# Categories is feinitely used by STACK framework:
categories:
- hugo
- zzo
keywords:
- hugo
- zzo
#image: /images/clone-mtg-vintage.png
image: /gallery/midjourney/PalladiusPacans_hugo_github_theme_abstract_logo_website_logo_co_cec2f356-2b55-4ef0-be71-b3bdccde2f0f.png
pinned: true
#math: true
# enables Maths on ZZO
libraries:
- mathjax
images:
- zzo-screenshot.png
- st-oca-zzo.jpeg
author: Pinco Pallino Joe # author name
authorEmoji: 🤖 # emoji for subtitle, summary meta data
authorImage: "/images/whoami/avatar.jpg" # image path in the static folder
authorImageUrl: "/gallery/riccardo-at-once/pinco-pallino-joe.png"
#  your image url. We use `authorImageUrl` first. If not set, we use `authorImage`.
authorDesc: an average writer # author description
socialOptions: # override params.toml file socialOptions
  email: ""
  facebook: ""
---


I'm playing around with ZZO here. And this is my ZZO-only page test.

* 👍👍: [at-once pictures](https://zzo-docs.vercel.app/zzo/pages/gallery/) for easy peasy album
* 👍 pinned pages on top
* 👍 features below: tabs, markdown, ... lot of goodies
* 👍 mulltilanguage support for IT.
* 👍 Supports Author metadayta, wow
* 👍 Supports Maths
* 👎🏾: font seems a bit ugly. Too playful, not serious.


## img

From https://zzo-docs.vercel.app/zzo/shortcodes/img/ :

{{< img src="/images/header/background.jpg" title="Sample Image" caption="This was in the sample site" alt="image alt" width="700px" position="center" >}}

{{< img src="/images/header/background2.jpeg" title="Sample Image" caption="This I took from docs" alt="image alt" width="700px" position="center" >}}

## colorful Notices

https://zzo-docs.vercel.app/zzo/shortcodes/notice/

{{< notice success "This is a success type of notice" >}}
success text
{{< /notice >}}

{{< notice info "This is a info type of notice" >}}
info text
{{< /notice >}}

{{< notice warning "This is a warning type of notice" >}}
warning text
{{< /notice >}}

{{< notice error "This is a error type of notice" >}}
error text
{{< /notice >}}

## Math

### MathJax

By enabling mathjax in libraries on front matter, you get this!!!

When $a \ne 0$, there are two solutions to $\(ax^2 + bx + c = 0\)\$ and they are
$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$

## Tabs

see https://zzo-docs.vercel.app/zzo/shortcodes/tab/

{{< tabs Italian UK US >}}
  {{< tab >}}

  ### Mafia section

  ```javascript
  console.log('Tagliatelle Bolognese 🇮🇹!');
  ```

  {{< /tab >}}
  {{< tab >}}

  ### UK section

  🇬🇧 Hello Fish and Chips!
  {{< /tab >}}
  {{< tab >}}

  ### US section

  🇺🇸 Let's shoot at it if it moves!
  {{< /tab >}}
{{< /tabs >}}

also expand:

{{< expand "Expand me" >}}Some Markdown Contents{{< /expand >}}

## featured image

documented in https://zzo-docs.vercel.app/zzo/shortcodes/featuredimage/

{{< featuredImage >}}

## buttons

documented here: https://zzo-docs.vercel.app/zzo/shortcodes/button/

{{< button href="https://zzo-docs.vercel.app/zzo/shortcodes/button/" width="200px" >}}button docs{{< /button >}}
{{< button href="https://..." width="100px" height="36px" >}}button{{< /button >}}
{{< button href="https://..." width="100px" height="36px" color="primary" >}}button{{< /button >}}


## Images

![Image](/st-oca-zzo.jpeg)


## Twitter Youtuibe

See rich content page but anyway:

YouTube Aos Ricc

{{< youtube E3ReKuJ8ewA >}}

<br>

---

Twitter Simple Shortcode

{{< twitter_simple user="palladius" id="1617900746967773190" >}}

Riccardo tweet: https://twitter.com/palladius/status/1617900746967773190

<br>

