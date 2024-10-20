---
title: "♊ [Geminocks] Level Up Your Rails Game with Cloud Run: A Qwiklabs Deep Dive"
date: 2024-10-19  # Today's date
layout: single  # Assuming single.html for blog posts in ZZO theme
# Optional fields (change as needed)
author: Riccardo Carlesso
read_time: 3  # Minutes
# categories: Add categories if applicable (e.g., ruby, rails, gcp)
# tags: Add tags if applicable (e.g., qwiklabs, cloudrun)
Tags: [qwiklabs, cloudrun, rubyonrails, devops, gcp, googlecloud, toolchain]
canonicalURL: https://medium.com/@palladiusbonton/ruby-on-rails-with-postgresql-on-cloud-run-bdaaf0b26e0b
---
([Original article on Medium](https://medium.com/@palladiusbonton/ruby-on-rails-with-postgresql-on-cloud-run-bdaaf0b26e0b))

Are you familiar with Cloud Skills Boost (formerly known as Qwiklabs)?

![Riccardo Video on Youtube](<ricc qwiklab video.png>)

In this video, I walk you through me executing the steps described in Ruby on Rails with PostgreSQL on Cloud Run on cloudskillsboost website, encountering a few bumps along the road, and fixing them.

Plus, I’m going to demonstrate my particular and personal ToolChain, as a former bash/perl dev, so it might look peculiar to you.

If you’re eager to start, here are my final Code on GitHub [link to code](https://github.com/palladius/20240809-qwiklab-rails-on-gcp) and the RoR Codelab [link to codelab](https://www.cloudskillsboost.google/focuses/20047).

Here’s my Rails video!

## **About Skillsboost**

Skillsboost (formerly known as Qwiklabs) is a way to train yourself to Google Cloud by executing “labs”. These labs are time constrained, Google creates all the resouerces for you, and deletes them at the end of the lab.

To do the labs, you have a credits-based system. You can pay $$ to get them, or you can get some for free by just subscribing to our Innovator Champion program (yup, all free!). This should allow you to do ~10 labs for free, also with Gemini (I’ve tried them, they’re a lot of fun!).

Our Codelab is here: https://www.cloudskillsboost.google/focuses/20047

## **Riccardo’s approach to Skillsboost**

There are a number of ways to execute a Lab, but I see mostly two:

1. You execute code in the Cloud. This is the simplest, what everybody does. You use a combination of Cloud Shell and Cloud Editor (if vim doesn’t cut it).
2. You execute code locally. This is a bit harder to set up, but then you get to keep all your useful code locally for future use/hacking. I’ve spent a few years writing a toolchain for this, using codelabba and proceed_if_error_matches and others. As you can imagine, I believe I’m the only earthling to persist my codelab scripts somewhere locally. Am I in good company? Please connect with me and tell me what you do differently!

As you can see in my video, I do both to show you both approaches, and good and bads.

## **What’s a friction log?**

A Friction Log is a Google Doc where you describe in text your experience, your emotions, and even your level of anger (using color codes) to the developer of some code/resources. The idea is to then share your doc with the implementor, tracking code and doc bugs in it. My crazy idea is to make a video out of it!

## **My “codelabba” ToolChain**

The time has come to explain my personal toolchain. Usually I have a number of git repos under `~/git/`, one of them being Open Source. Of course I’m talking about palladius/sakura.

* `00-init.sh`: The initialization script, common to all my codelabba projects, it refers to ENV variables like PROJECT_ID, REGION and so on.

* `.envrc`: This is powered by `direnv`, tool suggested to me by Rob Edwards and it contains all my ENV vars. You can think of it as the hydration part of the 00-init and everything else, thanks to Ruby/Python libraries to manage .env* files. I’ve also made an effort to make this file work out of the box with Pulumi (adopting Pulumi standard ENV names) and to be as compatible as possible with Google Cloud codelabs.

* `proceed_if_error_matches`: This is the simplest smartest script I’ve ever written. It transforms sequential bash scripts with `set -euo pipefail` into bash terraform-looking scripts. Imagine you need to: (1) create a bucket (2) set an ACL on it (3) upload files onto it. It’s reasonable to think you have three sequential scripts, which might fail from time to time and it takes time for you to fix each line. Once you do you want to proceed to the next, but guess what? you cant work on (2) because (1) will start failing with something annoying like “bucket already exists”. So I thought — what if I could filter ONLY certain error messages, which I capture as strings? Here’s the reason for this file.

* `codelabba.rb` (proprietary) This is a ruby script which I’ve never released publicly. But ask me in the comments, and I might take some time to clean it up and open source it. It basically creates a skeleton for my codelabs, and I invented it the 2nd or 3rd time I was doing a Qwiklab codelab, exactly for the reasons i’ve written above.

* `XX-blah-blah.sh` ([example](https://github.com/palladius/20240809-qwiklab-rails-on-gcp)) These are scripts to be executed in order: 01, 02, 03, … so they tell you a story. Think of it as a “Bash python notebook”. I know, this is the most profound sentence you’re gonna read today :)

Code: https://github.com/palladius/20240809-qwiklab-rails-on-gcp

## Conclusions

This is a big experiment for me! Was it a good idea? A terrible idea? Let me know in the comments!


