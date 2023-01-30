---
title: "Canary Deployments on GCP"
description: How to achieve camnary deployments with multiple apps in a single repo.
date: 2023-01-28T11:58:34+01:00
image: images/riccardo-canary-ravenna.jpeg
#math: 2+2
license:
hidden: false
comments: true
categories:
 - GCP
 - DevOps
 - Software

#draft: true
#https://medium.com/google-cloud/draft-canarying-on-gcp-with-cloud-deploy-91b3e4d0ee9a
---

In the past few months I’ve been working on a somewhat “sophisticated” solution for Canary 🐤 deployment for a multi-app (💎🐍️🧊) repository, trying to answer the question: how do I bring N apps to production through a number of stages and make sure that (oversimplifying) the final user gets a mix of N and N-1 revisions, say 90% production traffic / 10% canary traffic? And how do I make the code DRY so that bringing my next app will be super simple?
