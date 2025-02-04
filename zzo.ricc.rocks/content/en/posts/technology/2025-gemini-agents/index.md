---
# Note this is SUPER weird, I try to make this work for ALL my thingies so there might be some behavioural clatches in the
# initial HEADER :) Lets try to keep it small :)
title: "Using Gemini to write code in 2025.."
date: 2025-02-03T12:17:43+01:00
#draft: false
#image: /gallery/midjourney/PalladiusFigata_a_fantasy_imagination_of_ancient_mayan_city_if__f699b7ca-43d9-4d2a-b2ee-2022a0317e01.png
tags:
- gemini
- generative AI
- agents
categories:
- gemini
- google
- technology
---

I've been discussing with colleagues and friends how Gen AI is able to revolutionize code writing. Some people use embedded coding auxilia (Gemini Code, copilot, Cursor, ..), some use just a browser window to get snippets of code which they cut and paste into the IDE (what can go wrong, right pythonists?).

This article is about sharing lessons learnt in my journey as the **perfect lazy developer** (*minimum effort, maximum rendering* - as we say in Italian).

## Using Gemini to write code

I've been prompting gemini for a while, and started copying my prompts for future reuse

## 🧐 Prompt 1: ???


## 🧐 Prompt 2: code agent

Second prompt. I w anted

```markdown
I would like to create a python agent using gemini (and langchain framework if needed). The code should be modular in implementation (smaller files under lib/, capabilities under lib/capabilities/ ). The agent might inspect code in a local folder and do things given a generic prompt like """identify TODOs , propose code changes based on TODOs and create unit tests""". The agent should have these core capabilities (but also be extensible):

* Capability 1: `code_inspection`. Inspect a folder recursively and take a look at the code, and answer a generic "prompt" passed to it ("find todos", "find snippets of code you suggest to refactor", "does this code work?", ..). This might just be
* Capability 2: `file_inspection`. Given a folder, take a look at files statistics, and output a tree structure with the files last_modified_date. This tool is important to understand if code is still being maintained or passe'
* Capability 3: `git_inspection`. Given a folder, and a prompt, take a look at files vs current git branch - are they modified? Is the new code better than the old one? Should we commit this code or not? What is a good git commit message for this delta? Make sure to ONLY include files diffed under this input folder, not ALL the files in the git repo.

The code should be able to act asynchronously so we can launch different analysis in parallel. Each analysis should be a markdown and in an output folder, (default: 'out/' ) with a subfolder per capability (eg, "out/cap1-code-inspection/README.md"). If a capability needs to output multiple files, it will do so under that deterministic "out/CAPABILITY_FOLDER/", if not it will use `README.md`.
When the code has finished, it will return in stdout.

The code will take in input a YAML file containing an array of capabilities and the parameters (folders, prompts) from me. Please populate a reasonable YAML for me and let's start coding it together.

Can you help me draft it?
```

### Gemini output

I really

## 2 to 3 lesson learnt


I noticed that Gemini doesn't know how to code Gemini (AGI is still a couple of months far, so it's been likely trained on a previous model).

**Problem**. I have Gemini 1.5 and 2.0 available, but Gemini insists to use `gemini-1.0` model as the only prod one (it's actually getting deprecated soon).
How do we solve it? Let's inject our "superior" knowledge (we're just 1 year ahead) into it.

Luckily our [public docs rocks](https://ai.google.dev/gemini-api/docs/sdks), so  better to give it the code from https://ai.google.dev/gemini-api/docs/sdks

## 🧐 2.5 Prompt addon

For Gemini code generation, please use and trust this code snippet:

```
# From https://ai.google.dev/gemini-api/docs/sdks
# Install: pip install google-genai dotenv

from google import genai
client = genai.Client(api_key='GEMINI_API_KEY') # take it from ENV or .env via dotenv
response = client.models.generate_content(
    model='gemini-1.5-flash', contents='How does RLHF work?'
)
print(response.text)
```



# Lessons learnt

* Ask Gemini to break down the mono-file into **smaller pieces**. This will work well with a yet-incredibly high context
  window of 1MB - and when the window fails you, you can still paste the small part of it and gemini will pick it up likely
  from where you left.
