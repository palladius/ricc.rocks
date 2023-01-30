---
title: "202301 Hugo Howto"
description: Tricks and tips on Hugo, related to my STACK module.
date: 2023-01-28T15:54:17+01:00
#slug: hello-world
#image: images/articles
image: images/hugo-cocktail.jpg
#image: "cover.jpg"
#image: yellow-desktop-wallpaper.jpg
#math: true
#license:
hidden: false
comments: true
#draft: true
tags:
- Hugo
- Software
categories:
 - Hugo
 - Software
---

## About Hugo

Some tips using Hugo:

* Hugo Stack: [miniDemo](https://demo.stack.jimmycai.com/), [Awesome Blog+docs](https://stack.jimmycai.com/),
  [github repo](https://github.com/CaiJimmy/hugo-theme-stack), [Maths](https://dev.stack.jimmycai.com/p/math-typesetting/) .
* Hugo howto:

## Assets and image paths


According to [SO](https://stackoverflow.com/questions/71501256/how-to-insert-an-image-in-my-post-on-hugo),
you can pick two paths:

1. Put all of your images in the static/ directory. Then reference the image file with a leading slash, e.g.:

```
hugosite/static/across_column.png
![Scenario 1: Across columns](/across_column.png)
```

2. Option 2. Use sub-directories to hold the markdown file and any related resources.

```
post/creating-a-new-theme/images
![Image alt](images/my-image.jpg)
```

## Test math (not working)

Uses Katex: https://katex.org/
Docs: https://dev.stack.jimmycai.com/p/math-typesetting/

{{ if or .Params.math .Site.Params.math }}
{{ partial "math.html" . }}
{{ end }}

% \f is defined as #1f(#2) using the macro
\f\relax{x} = \int_{-\infty}^\infty
    \f\hat\xi\,e^{2 \pi i \xi x}
    \,d\xi

\tilde{a}
\overline{AB}
