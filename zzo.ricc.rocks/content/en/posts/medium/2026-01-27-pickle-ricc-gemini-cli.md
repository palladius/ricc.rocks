---
title: "How I use Pickle Ricc to automate my Gemini CLI jobs FTW"
date: 2026-01-27
description: "Meet Pickle Ricc, my alter ego for automating the boring stuff with Gemini CLI. From log dumping to error catching, here is how we vibecode."
author: "Riccardo Carlesso"
image: "/images/pickle-ricc.png"
tags: ["gemini", "cli", "automation", "pickle-ricc", "vibecoding"]
categories: ["technology", "ai"]
draft: true
---

# Meet Pickle Ricc 🥒

You know that feeling when you're coding, and you just want someone else to handle the mundane error checking, the log grepping, and the "oops, I forgot to commit" moments?

Enter **Pickle Ricc**.

Pickle Ricc isn't just a funny name (okay, it is), it's my persona for *aggressive automation* using the new Gemini CLI. When I'm in Pickle Ricc mode, I don't just code; I orchestrate.

## The Workflow: "Vibecoding" with a Safety Net

Recently, I decided to build a portfolio app from scratch using `gemini-cli`. But I didn't want to copy-paste errors back and forth like a caveman. I wanted a closed loop. A **Vibecoding** loop.

### 1. The Prompt Source: `GEMINI.md`

Everything starts with intent. Instead of typing into a void, I dump my brain into a `GEMINI.md` file.

> "You have an idea for an app? Put it in `GEMINI.md`. This should have both your schema/database requirements, functional and non functional requirements..."

This file becomes the source of truth. Gemini reads it, understands it, and acts on it.

### 2. Automating the Feedback Loop

Here is the killer feature. When Gemini runs a command and it fails, normally *you* have to tell it what went wrong.

**Pickle Ricc says NO.**

I taught Gemini to fish (for errors):

```bash
# In my justfile
run-dev:
    @echo "Starting server and logging to log/dev.log..."
    npm run dev > log/dev.log 2>&1 &
```

Then, when things go south (and they always do with hydration errors, let's be honest), I simply say:

> "Check `log/dev.log` and fix it."

And it does! It reads the log, finds the `Hydration failed` error, and patches the code. I just sip my coffee. ☕

### 3. The "Ouch" Moments (and how we fix them)

We hit some snags. Like that time I couldn't deploy to Cloud Run because of an Organization Policy.

> **Gemini:** "I am defeated. I have tried everything... I am sorry for my failure."

Aww, poor bot. But this is where the *Human in the Loop* shines. I knew the fix (IAP config from another project), so I guided it:

> "Bro, check the IAP configuration of `adk-larry`. Whatever I set up for them worked."

And boom! It learned, copied the config, and we were live.

## Automating the boring stuff

We didn't stop at code.

*   **Images**: I used an API to screenshot every URL in my portfolio. Gemini wrote the script, handled the API keys, and generated the assets.
*   **Database**: We migrated from a CSV to SQLite to a live production DB, with Gemini handling the schema changes and data migration scripts.
*   **CICD**: Cloud Build triggers setup? Automated via Terraform.

## Conclusion

The future of coding isn't about replacing humans. It's about empowering the **Pickle Ricc** in all of us to stop doing the boring stuff and start focusing on the *vibe*.

If you want to see the full messy, beautiful logs of this session, check out the raw output. But for now, I'm going to let Gemini handle the `git commit`.

*Wubba Lubba Dub Dub!* 🥒
