---
type: Article
status: wip
priority: P2
title: "How I built a skill to fan out 20 workers to fix my old Rails App (steal my prompt!)"
date: 2026-07-14T09:00:00+02:00
draft: false
image: assets/hero_image.png
description: "I wanted to fix an app which had 20 open GHI but I didnt want to spin up 20 agents. So I created a single prom pt to rule them all!"
categories: ["Antigravity", Rails ]
tags: ["Google", "Antigravity", Ruby, Rails, Worktree, Agentic, Subagents ]
author: "Riccardo Carlesso"
version: "1.0"
Platform: "Medium and ricc.rocks"
PublishDate: "2026-07-14"
CTA: "https://github.com/palladius/gemini-cli-palladius-public-goodies/tree/main/skills/ghi-fan-out-coding"
---

*I hope this article is going to help and inspire thousands of lazy coders with a bunch of open issues in their repos!*

<!-- would be nice to have a BIG FONT impact thingy which is not an H2 i think medium supports it. -->
> How I tokenmaxxed 20 subagents to solve all of my GH issues at once... and packaged this into a skill!

Yesterday I was talking to my buddy [Emiliano](https://www.linkedin.com/in/emilianodellacasa) about a [Rails 8 App](https://rubyonrails.org) we built last year (ie, two *geological eras* ago in AI terms) and we decided to rebuild something new from scratch. I've also noticed the app had plenty of open issues on GitHub and I thought: lets fix them lightheartedly with Worktrees and agents and ZERO effort on my side; wait, is this even possible? And if it is, should I blog about it?

---

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/assets/hero_image.png" caption="An old 2025 Rails app with plenty of open issues... nightmare!" alt="An old 2025 Rails app with plenty of open issues... nightmare!" position="center" >}}


**YES**, it is possible, and [Antigravity](https://github.com/google/antigravity) makes it easy! You just need a few guardrails and some **smart prompt** which you're welcome to **steal** (just scroll 2 paragraphs down)!

But let's not get ahead of ourselves.


## Riccardo, what problem are you trying to solve?

If you maintain an old project, you know the drill: you check the repository after a few months and find 20 open issues, dependabot alerts, and minor feature requests piling up. The thought of manually branching, fixing, testing, and opening PRs for each one is exhausting. 

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/screenshots/image.png" caption="A bunch of open GitHub Issues for my old Rails8 app" alt="A bunch of open GitHub Issues for my old Rails8 app" position="center" >}}

I didn't want to spin up 20 separate agents manually, so I had an idea: what if I wrote **a single prompt to rule them all**? A prompt that would fetch all open issues, spawn a dedicated worker for each, evaluate whether it could be solved autonomously, and then do the work in parallel worktrees!

## My first solution

 Actually, I've done better: I've packaged all in a skill so you can just say "Use Riccardo skill at [ghi-fan-out-coding](https://github.com/palladius/gemini-cli-palladius-public-goodies/tree/main/skills/ghi-fan-out-coding) to start an autofix bonanza for this repo". Boom!

So I started typing this fan-out prompt:

```markdown
For every open GH issue, open a subagent for that issue. That subagent shall:
1. identify if that is doable without human intervention. Does it have all it takes for independently drive to resolution?
2. If no, update that asking questions which can be answered by human to answer yes at a next pass.
3. If yes, then create a new worktree, read the conductor + worktree skill, and implement it independently. Add meaningful failing tests and implement your way to make them not fail anymore (TDD). Tests need to fail first and then not anymore! 
4. When done, create a PR with the branch and: (a)  update GHI with what has been done, choices that have been taken, .. (b) a message for the user in the PR. 
```

Some important notes:

* Use a **SMART, thoughtful model**. Today I've used Gemini 3.1 pro in high thinking mode for the main agent. You can spare a few pennies for this as it needs to set it up correctly.
{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/screenshots/gemini31pro-thinking.png" caption="Use a Gemini PRo high-thinking mode for the main agent" alt="Use a Gemini PRo high-thinking mode for the main agent" position="center" >}}
* **Enable Turbo mode**. What's the worst that can happen in your GH repo?

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/screenshots/turbo-mode.png" caption="Enable Turbo mode: fewer questions and more risk. This is how Proper Unresponsible Vibecoding is done" alt="Enable Turbo mode: fewer questions and more risk. This is how Proper Unresponsible Vibecoding is done" position="center" >}}

But then I thought: this is so amazing, this is gonna change the world, this should be MORE than just a prompt. How do I maintain it? To quote Ali G, *"The world is bigger than Staines, and me gotta build a skill for it!"*

## Let's make it more complex

Who knows me call me "The Master in overcomplication", which is not a compliment. Since the [first version (commit `39f9f19`)](https://github.com/palladius/gemini-cli-palladius-public-goodies/commit/39f9f19) I"ve added a bit of script to bring main and subagents "on rails" and add some forensics analysis with timestamps so we can bettere identify what went worng.

To achieve this, I packaged the logic into a new skill: `ghi-fan-out-coding`. The workflow is simple:
1. **Analyze and Filter:** The orchestrator agent reads the GitHub issues and filters out ones that explicitly require human knowledge (or tags them for clarification).
2. **Fan Out:** It invokes subagents, handing each one an issue.
3. **Isolated Worktrees:** Each subagent creates a git worktree to avoid stepping on the others' toes, uses TDD to write failing tests, and then implements the fix.
4. **Pull Requests:** When the tests pass, the subagent pushes the branch and creates a PR with a summary of its choices.

### Chatting with Antigravity on Specs

Spec Driven Development (SDD) couldn't be funnier and more productive! I love how Antigravity makes it easy for you to comment on an Implementation plan:

![alt text](<screenshots/ricc commenting on implementation plan.png>)

To prove me right, my friend Andrea is not a coder and *yet* is building Finance and Hermes stuff every day with Antigravity 2.0 (and speaking Italian on his mike - guess who's learnt from!).

## We're ready, let's start!

### A small diary

* **09:41**: It all started.
* **10:04**: 23 minutes later, all subagents but one have finished! Look:

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/screenshots/1004-all-subagents-but-one-are-done.png" caption="10:04 all subagents but one are done" alt="10:04 all subagents but one are done" position="center" >}}

* **15:15**. Some missing JSON fields, update skill, rinse and repeat.

## Additional iterations

CLI observation.
```markdown
3. Does the skill support some sort of CLI to get script status?
I would love to see sth like `14 issues faced, 11 faced 3 skipped, 8 PR pendings, ..` 
hopefully by just checking JSON in local and 
sip caipirinha while observing "watch just cool-jsons"
```

A few minutes later, `scripts/dashboard.sh` (commit hash of skill) is ready and integrated in my repo's Justfile ([#4b08376](https://github.com/palladius/rails8-turbo-chat/commit/4b08376c0f34b49e70505e14f192255ec2c34f58)):

```bash
 just show-fanout-execution AC67EF98-9364-407A-A497-FD7DDD01EF98                                                                           ricc-mac.roam.internal: Wed Jul 15 10:56:48 2026
                                                                                                                                                                                         in 0.917s (0)
=====================================================
🚀 GHI Fan-Out Bonanza Dashboard | UUID: AC67EF98-9364-407A-A497-FD7DDD01EF98
=====================================================
Total Issue Folders Created: 14
Subagents Completed: 11 / 14
PRs Created: 2
Problem Reports (JSON): 2
=====================================================
📊 Agent Status:
  - 🤷 ghi-10: NOOP (Already fixed/closed)
  - ✅ ghi-12: Completed (Work finished (no explicit PR link))
  - 🛑 ghi-18: Aborted (Requires human intervention)
  - ⏳ ghi-23: In Progress / Interrupted
  - ✅ ghi-24: Completed (Work finished (no explicit PR link))
  - ⏳ ghi-25: In Progress / Interrupted
  - ✅ ghi-26: Completed (Pending push approval)
  - ⏳ ghi-27: In Progress / Interrupted
  - 🛑 ghi-34: Aborted (Requires human intervention)
  - ✅ ghi-38: Completed (Pending push approval)
  - ✅ ghi-40: Completed (Work finished (no explicit PR link))
  - ✅ ghi-41: Completed (Created PR #69)
  - 🛑 ghi-42: Aborted (Requires human intervention)
  - ✅ ghi-44: Completed (Created PR #66)
⚠️ Problems Found:
  - ghi-42:  missing_context
  - ghi-34:  app_not_running, missing_playwright
=====================================================
```

### Review is missing

I'm currently working on part 2 of the skill where automated review is happening sequentially.





## Conclusion

What used to take an entire weekend of context-switching and tedious git commands now takes 90 seconds of orchestrating. The agents handle the boilerplate, the tests, and the PR creation, leaving me with the fun part: reviewing code and hitting "Merge". 

If you want to try it out yourself, check out the `ghi-fan-out-coding` skill!

---

<sub style="font-size: 0.7em; opacity: 0.6;">*Drafted with Antigravity, article v1.0*</sub>

*📝 This article will also be published on Medium — link coming soon.*
