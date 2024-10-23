---
# Note this is SUPER weird, I try to make this work for ALL my thingies so there might be some behavioural clatches in the
# initial HEADER :) Lets try to keep it small :)
title: "💦♊ [Geminocks] テーマ比較 (🏆) 🇯🇵"
date: 2023-02-05T21:17:43+01:00
draft: false
tags:
- symlink
- hugo
- WOW
- geminocks
- Japanese
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



今週末はたくさんのモジュールを試しました。上記のスタンザでは、テーマによって単語やキー/値が異なるため、混同しないように注意する必要があります。
例えば、このページにはAnankeでのみ機能する`featured_image`と、おそらく他のテーマでも機能する`image`があります。

これまでに試したこと。

## 全ページでシンボリックリンクする。

* これまで試したのは1つだけ - golangは変更されたシンボリックリンクファイルを認識しないでしょう。
* STACKは現在、別の場所にあることに注意してください。ちょっと移動させてください。

## これまでに試したHugoのウェブサイト

すべてのコードは、私のGHリポジトリの異なるディレクトリにあります: https://github.com/palladius/ricc.rocks/

| テーマ + PermaCompare | ウェブサイト     | スター |  説明 |
| ----------- | ----------- | ------ | ---- |
| Bootstrap   | [hugo-bootstrap-ricc-rocks](https://hugo-bootstrap-ricc-rocks.netlify.app/) | ⭐️⭐️⭐️⭐️⭐️ | 素晴らしい |
| Stack       | [hugo-stack.ricc.rocks](https://hugo-stack.ricc.rocks) |⭐️⭐️⭐️⭐️⭐️ | たくさんいじりました。別のリポジトリにあることに注意してください |
| ----------- | ----------- | ------ | ----  |
| [🙉](https://ricc-zzo.netlify.app/en/posts/riccardo/prova-zzo/) ZZO         | [ricc-zzo.netlify.app)](https://ricc-zzo.netlify.app/en/) | ⭐️⭐️⭐️⭐️⭐️ | 私が望むようなアイコンがあり、とても遊び心がありますが、素晴らしい機能が満載です。とても気に入っています！  |

(*) Permacompare: 本番環境の比較ページへのパーマリンク :)

* **PaperMod**: うまくいきます！ https://papermod.ricc.rocks	 まだあまり調べていません。比較ページ: https://papermod.ricc.rocks/posts/papermod-analysis-page/  [🙉](https://ricc.rocks/posts/papermod-analysis-page/) PaperMod |⭐️⭐️⭐️⭐️   | 超スタイリッシュ。必要最低限でありながら、その本質において非常に優れています！ |
* **Stack**: まず、[数学](https://dev.stack.jimmycai.com/p/math-typesetting/)があります。 https://hugo-stack.ricc.rocks  そして、私はそれが大好きです！
* **Bootstrap**: https://hugo-bootstrap-ricc-rocks.netlify.app/
* 🚧 [WIP] **Tranquilpeak**.  https://tranquilpeak.netlify.app/ 数学に対応しています
* 🚧 [WIP] **ZZO**. https://ricc-zzo.netlify.app/en/

敗北:

* **Coder**: いやあ、私にはシンプルすぎます。
* Ananke。シンプルすぎる - https://hugo-ananke.netlify.app/

## フォトアルバム

* きちんとしたフォトアルバムがあるのはXXXだけのようです。しかし、「Photoswipeのようにテーマが良ければいいのに」と言う人もいるので、[**PhotoSwipe**](https://photoswipe.com/)を他のものと連携させることができるかもしれません: [HugoPhotoSwipe](https://github.com/GjjvdBurg/HugoPhotoSwipe)を参照してください。
* https://github.com/liwenyip/hugo-easy-galleryもチェックしてみてもいいかもしれませんが、価値があるとは思えません。(505 ⭐️)。
* あるいは、コードを書くだけです（RubyではなくGolangだったらいいのに）: https://hugocodex.org/add-ons/image-gallery/
* あるいは、この[素晴らしいライブラリ](https://github.com/mfg92/hugo-shortcode-gallery)を使用します: https://matze.rocks/images/#gallery-filter=Landscapeでデモをご覧ください。



## ZZO

![Resize](zzo-screenshot.png?width=300px)

* **比較ページ**: https://ricc-zzo.netlify.app/en/posts/riccardo/prova-zzo/
* インストール: https://zzo-docs.vercel.app/
* GHテーマ: https://github.com/zzossig/hugo-theme-zzo
* Riccバージョン: https://ricc-zzo.netlify.app/

特徴:

```
複数のスキン（ダーク、ライト、ソーラライズドなど）
モバイルメニュー
検索
検索エンジン最適化（SEO）
多言語対応（i18n）
レスポンシブデザイン
カスタマイズ可能なUI
RSS
ギャラリー
高速コードハイライト
トークページ
ショーケースページ
出版ページ
履歴書ページ
プレゼンテーションページ
```




## Bootstrap

* 画像ドキュメント: https://hbs.razonyang.com/v1/en/docs/image-processing/#resizing-images 良いものがたくさんあります。また、バグを見つけたのですが、開発者が24時間で修正してくれました - 素晴らしい。
* ギャラリードキュメント: https://hbs.razonyang.com/v1/en/docs/shortcodes/gallery/




# 過去の情報

## PaperMod

まだ少ししか触っていませんが、それは私の責任であって、彼の責任ではありません :)

ドキュメント: https://github.com/adityatelange/hugo-PaperMod/

ニュートラル:

* [多くのアイコン](https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-icons/#social-icons)をサポートしていますが、使い方がわかりません。
* [数学をサポート](https://adityatelange.github.io/hugo-PaperMod/posts/math-typesetting/)していますが、動作させる方法がわかりません。
* 絵文字はいい感じです。有効にすると、🙈 :see_no_evil: 🙉 :hear_no_evil: 🙊 :speak_no_evil: のようにできます。

悪い 😩:

* シンプルすぎる。ブロガーとしての私のことを何も表現していません。単なるニュースの（スタイリッシュな）コンテナです。リッカルドのことではなく、私の記事だけです。


## Ananke ⭐️⭐️

ステータス: [![Netlify Status](https://api.netlify.com/api/v1/badges/9c6fdacc-6b9f-4908-b3e5-57f1dc2b8f50/deploy-status)](https://app.netlify.com/sites/hugo-ananke/deploys)
古い:
* [hugo-ananke.netlify.app](https://hugo-ananke.netlify.app)
* 歴史的に最初に試したもの。あまり深く掘り下げていません。

良い 😍:

* TODO

悪い 😩:

* **シンプルすぎる**。例えば、お問い合わせフォームが投稿の中にあります（本当に？）。
* 画像ギャラリーがないのではないかと思います。


## TranquilPeak

![image](tranquilpeak-showcase.png)

* GH: https://github.com/kakawait/hugo-tranquilpeak-theme
* 861スター / 515フォーク
* デモサイト:
* ライセンス: GPL
* インストール: https://github.com/kakawait/hugo-tranquilpeak-theme/blob/master/docs/user.md

画像btagの使用方法（ついに！）: https://github.com/kakawait/hugo-tranquilpeak-theme/blob/master/docs/user.md#image


プラス

* きれいなグラフィック
* 組み込みのギャラリー

マイナス

* FSは画像のシンボリックリンクをサポートしていないとのこと。しかし、投稿のシンボリックリンクはサポートしています。
* content/posts/の構成が怪しい。ディレクトリ内外のコンテンツを移動すると、表示されなくなります。奇妙です。(もっともな理由があるのかもしれませんが、content/内のすべてを移動できる他のテーマと比較すると、バグのように思えます)






*(Generated by Geminocks: https://github.com/palladius/ricc.rocks/tree/main/gemini prompt_version=1.4)*