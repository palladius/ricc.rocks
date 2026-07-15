---
type: Article
status: wip
priority: P2
title: "How I built a skill to fan out 20 workers to fix my old Rails App on Antigravity (steal my prompt!)"
date: 2026-07-14T09:00:00+02:00
draft: false
image: "/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/assets/hero_image.png"
description: "I wanted to fix an app which had 20 open GH Issues but I didnt want to spin up 20 agents. So I created a single Antigravity prompt to rule them all! The prompt was so good, and ideas came flogging at me, that I constructed a skill for you to re-use! This has been tested on Antigravity, which is free to use for everyone!"
categories: ["Antigravity", Rails ]
tags: ["Google", "Antigravity", Ruby, Rails, Worktree, Agentic, Subagents ]
author: "Riccardo Carlesso"
version: "1.0"
Platform: "Medium and ricc.rocks"
PublishDate: "2026-07-14"
CTA: "https://github.com/palladius/gemini-cli-palladius-public-goodies/tree/main/skills/ghi-fan-out-coding"
published_urls:
- "https://ricc.rocks/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/" 

---

*I hope this article is going to help and inspire thousands of lazy coders with a bunch of open issues in their repos!* Ok, if not 1000s maybe 1 or 2.

> How I tokenmaxxed 20 subagents to solve all of my GH issues at once... and packaged this into a skill, so you don't have to!

Yesterday I was talking to my buddy [Emiliano](https://www.linkedin.com/in/emilianodellacasa) about a [Rails 8 App](https://rubyonrails.org) we built last year (ie, two *geological eras* ago in AI terms) and we decided to rebuild something new from scratch. I've also noticed the app had plenty of open issues on GitHub and I thought: lets fix them lightheartedly with Worktrees and agents and ZERO effort on my side; wait, is this even possible? And if it is, should I blog about it?

---

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/assets/hero_image.png" caption="An old 2025 Rails app with plenty of open issues... nightmare! Can my agents fix it while I read the news?" alt="An old 2025 Rails app with plenty of open issues... nightmare! Can my agents fix it while I read the news?" position="center" >}}


**YES**, it is possible, and [🛸 Antigravity](https://antigravity.google/) makes it easy! You just need a few guardrails and some **smart prompt** which you're welcome to **steal** (just scroll 2 paragraphs down)!

But let's not get ahead of ourselves.


## Riccardo, what problem are you trying to solve?

If you maintain an old project, you know the drill: you check the repository after a few months and find 20 open issues, dependabot alerts, and minor feature requests piling up. The thought of manually branching, fixing, testing, and opening PRs for each one is exhausting. 

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/screenshots/image.png" caption="A bunch of open GitHub Issues for my old Rails8 app" alt="A bunch of open GitHub Issues for my old Rails8 app" position="center" >}}

I didn't want to spin up 20 separate agents manually, so I had an idea: what if I wrote **a single prompt to rule them all**? A prompt that would fetch all open issues, spawn a dedicated worker for each, evaluate whether it could be solved autonomously, and then do the work in parallel worktrees! This is a breeze with Antigravity 2.0 as you can read in [Richard Seroter's article](https://seroter.com/2026/06/01/one-prompt-four-subagents-and-ninety-seconds-to-get-a-working-app/).

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/screenshots/pr-boxers.jpg" caption="A chaotic boxing ring with 5 boxers fighting over PRs, representing the violence of reconciling 20 worktrees into a single main branch. Riccardo stands happily in a yellow Google t-shirt saying 'I was lucky - I was first'." alt="A chaotic boxing ring with 5 boxers fighting over PRs, representing the violence of reconciling 20 worktrees into a single main branch. Riccardo stands happily in a yellow Google t-shirt saying 'I was lucky - I was first'." position="center" >}}

If you're a follower of mine, this might ring a bell! I just posted another Worktree + Conductor article here: 

* [🪨 Orchestrating with Antigravity: A Crescendo of Agents - Part 1](/en/posts/technology/2026-06-16-crescendo-of-agents-part-1/)
* [🪨 Orchestrating with Antigravity: A Crescendo of Agents - Part 2](/en/posts/technology/2026-07-03-crescendo-of-agents-part-2/)

This article differs in the sense that it's LESS Conductor/Spec-Driven and so it's less guided and more "trying to get things done without bothering the user". For a very serious project, I encourage you to use [🪨 HITL+Conductor skill as in article 2](/en/posts/technology/2026-07-03-crescendo-of-agents-part-2/) instead.

<!-- Maybe do a graph of article2 vs this one with how agents interact and when to choose one or the other.-->
## 1. My first solution: a prompt

So I started typing this fan-out prompt:

```markdown
For every open GH issue, open a subagent for that issue. That subagent shall:
1. identify if that is doable without human intervention.
   Does it have all it takes for independently drive to resolution?
2. If no, update that asking questions which can be answered by human
   to answer yes at a next pass.
3. If yes, then create a new worktree, read the conductor + worktree skill, 
   and implement it independently. Add meaningful failing tests and implement
   your way to make them not fail anymore (TDD). Tests need to fail first and
   then not anymore! 
4. When done, create a PR with the branch and: (a)  update GHI with what has been
   done, choices that have been taken, .. (b) a message for the user in the PR. 
```

Some important notes:

* Use a **SMART, thoughtful model**. Today I've used Gemini 3.1 pro in high thinking mode for the main agent. You can spare a few pennies for this as it needs to set it up correctly.
{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/screenshots/gemini31pro-thinking.png" caption="Use a Gemini PRo high-thinking mode for the main agent" alt="Use a Gemini PRo high-thinking mode for the main agent" position="center" >}}
* **Enable Turbo mode**. What's the worst that can happen in your GH repo? After all, it's committed and revertable!

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/screenshots/turbo-mode.png" caption="Enable Turbo mode: fewer questions and more risk. This is how Proper Unresponsible Vibecoding is done" alt="Enable Turbo mode: fewer questions and more risk. This is how Proper Unresponsible Vibecoding is done" position="center" >}}

We're off to a great start! But...

Then I thought: this is so amazing, this is gonna change the world, this should be MORE than just a prompt. How do I maintain it? To quote Ali G, *"The world is bigger than Staines, and me gotta build a skill for it!"*

In 🇮🇹 Italy we say that [*appetite comes with eating*](https://appetitomagazine.com/features/lappetito-vien-mangiando-why-appetite-comes-with-eating) and so why don't we raise the bar a bit?

<!-- 
Actually, I've done better: I've packaged all in a skill so you can just say "Use Riccardo skill at [ghi-fan-out-coding](https://github.com/palladius/gemini-cli-palladius-public-goodies/tree/main/skills/ghi-fan-out-coding) to start an autofix bonanza for this repo". Boom!
-->

## 2. Let's make it a SKILL

Who knows me call me "The Master in overcomplication", which is not a compliment. Since the first version ([#39f9f19](https://github.com/palladius/gemini-cli-palladius-public-goodies/commit/39f9f19)) I"ve added a bit of script to bring main and subagents "on rails" and add some forensics analysis with timestamps so we can bettere identify what went worng.

To achieve this, I packaged the logic into a [new skill](https://github.com/palladius/gemini-cli-palladius-public-goodies/tree/main/skills/ghi-fan-out-coding): [`ghi-fan-out-coding`](https://github.com/palladius/gemini-cli-palladius-public-goodies/tree/main/skills/ghi-fan-out-coding). The workflow is simple:
1. **Analyze and Filter:** The orchestrator agent reads the GitHub issues and filters out ones that explicitly require human knowledge (or tags them for clarification).
2. **Fan Out:** It invokes subagents, handing each one an issue.
3. **Isolated Worktrees:** Each subagent creates a `git worktree` to avoid stepping on the others' toes, uses TDD to write failing tests, and then implements the fix. This is a lesson I learnt in the past month and you can read in [🪨 Part 2](/en/posts/technology/2026-07-03-crescendo-of-agents-part-2/).
4. **Pull Requests:** When the tests pass, the subagent pushes the branch and creates a PR with a summary of its choices.

### Chatting with Antigravity on Skill Specs

[Spec Driven Development](https://en.wikipedia.org/wiki/Specification-driven_development) (SDD, not to be confused with SSD) couldn't be funnier and more productive! I love how Antigravity makes it easy for you to comment on an Implementation plan:

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/screenshots/ricc-commenting-on-implementation-plan.png" caption="Riccardo commenting on implementation plan" alt="Riccardo commenting on implementation plan" position="center" >}}

Think about this: my best friend 🇮🇹 Andrea is not a coder and *yet* he's building Finance and Hermes stuff every day with Antigravity 2.0 (and speaking Italian on his mike - guess who's learnt from!).

## We're ready, let's start!

I'm at Lido degli Estensi, 🇮🇹, coding with A/C on, and having a blast. Here's what happened, Jack Bower style:

🪵 `09:41` It all started. Here is a quick video of the agents working in parallel:

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/screenshots/subagents-working.gif" caption="Subagents in action" alt="Subagents in action" position="center" >}}

🪵 `10:04` 23 minutes later, all subagents but one have finished! Look:

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/screenshots/subagents-done.png" caption="10:04 all subagents but one are done" alt="10:04 all subagents but one are done" position="center" >}}

Don't believe me? Results are visible here: https://github.com/palladius/rails8-turbo-chat/issues/71

🪵 `10:15` Some missing JSON fields, update skill, rinse and repeat. 
  * I should probably write an article about `SKILL.md` meta-feedback loop and Skill lifecycle. Ping me if this interesting to you.

🪵 `11:30` We're ready to execute the newer version, shiny skill `v1.5`! ([View on GitHub](https://github.com/palladius/gemini-cli-palladius-public-goodies/tree/main/skills/ghi-fan-out-coding))
🪵 `12:14` I've updated this article for you guys - so now I'm ready for the second pass


## Additional iterations

### No CLI, no party!

I love having 20 `.JSON` in my local computer, but I don't enjoy reading them manually (as a rubyist, I write poems in YAML - not JSON!) that means you can create a UI or a CLI to show you a synoptic. Let's do it!

```markdown
Does the skill support some sort of CLI to get script status?
I would love to see sth like: 
`14 issues faced, 11 faced 3 skipped, 8 PR pendings, ..` 
hopefully by just checking JSON in local and 
sip caipirinha while observing "watch just cool-jsons"
```

A few minutes later, `scripts/dashboard.sh` is ready and integrated in my repo's  ([Justfile](https://github.com/palladius/rails8-turbo-chat/commit/4b08376c0f34b49e70505e14f192255ec2c34f58#diff-deb9bb56fb122db0b605aa5b63f95a4665c905b18dd670e1fa6c877576a94ff1)):

```bash
# Launching with skill v1.4
$ just show-fanout-execution AC67EF98-9364-407A-A497-FD7DDD01EF98
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

### Riccardo, what about Code Review?

Apparently, Gemini was listening to my `GEMINI.md` which said "do not push" so I found myself with this issue... 20 PRs and the temptation to tell those agents to stop slacking off and just push to main already! I mean, what can possibly go wrong?

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/assets/boxeurs-candidates/boxers_pr_conflict_3_1784109131568.jpg" caption="Too many conflicts, too many PRs fighting for prime time" alt="Too many conflicts, too many PRs fighting for prime time" position="center" >}}

Sounds familiar? It's a FIFO world where the first wins and all the others end with blood on their hands.

So I've worked on version `1.5` of the skill where **automated review** is happening *sequentially* (yes Im not convinced parallelism would help here - plus reviewing should be faste rthan coding - hopefully).


## Skill Second pass: automated review (v1.5)

🪵 `12:21` I start this second prompt v1.5.1:

```markdown
Read the `ghi-fan-out-coding` skill, then execute both phases:
• Phase 1: Follow `MAIN_AGENT_CHECKLIST.md` to fan-out parallel subagents.
• Phase 2: Follow `REVIEW_AGENT_CHECKLIST.md` to sequentially review all PRs.
Settings:
• Harness: antigravity
• HITL threshold: 80
After Phase 2, create the [META] retrospective issue and call main_end with --retro-ghi.

```
{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/image-1.png" caption="prompt verbatim" alt="prompt verbatim" position="center" >}}

What changed:
1. We have a **sequential review** phase following the main/subagent phase (not parallel to minimize merge/rebase pain).
2. We have a few parameters:
  1. a **HITL threshold** to tell it "bother me only for important questions" and do 80% by yourself.
  2. *(minor)* A harness name to be put in the GHI signature.

### .. and it works!

Look how my 15 subagents are tokenmaxxing my Antigravity without breaking a sweat, and nicely populating 15 JSON files I can then review later:

<video controls src="assets/videos/Screen Recording 2026-07-15 at 12.26.01.mov" title="21 subagents! Wooooot!!! Capturing this video was hard but totally worth it!"></video>

Let's check my second execution `uuid=D70F962C-9A6E-47E7-B3ED-118F450ABF0C`:

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/image-4.png" caption="Work in progress, 3 done and 13 still to go!" alt="Work in progress, 3 done and 13 still to go!" position="center" >}}

### Wait, who deleted my status folder?

Woops - some overly diligent agent decided to wipe out the whole status folder. Damn it!

1. Fix the skill to say don't do it again, naughty boy!
2. Rinse and repeat: 
 
🪵 `12:52` Exec v3  `uid=471A394C-0CC3-413B-9457-26318ECAE38B`

Now the skill updated to `v1.5.4`.

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/image-5.png" caption="Prompt for second version, launching on Antigravity!" alt="Prompt for second version, launching on Antigravity!" position="center" >}}

🪵 `12:54` Start with empty slate, third folder:

```
📊 Agent Status:
  - ⏳ ghi-12: Pending
  - ⏳ ghi-18: Pending
  - ⏳ ghi-23: Pending
  - ⏳ ghi-24: Pending
[..]
```


<!--  seems pretty boting, skipping 
```
$ just show-fanout-execution 471A394C-0CC3-413B-9457-26318ECAE38B 
=====================================================
🚀 GHI Fan-Out Bonanza Dashboard | UUID: 471A394C-0CC3-413B-9457-26318ECAE38B
   Skill: v1.5.4  #bac8f95
   https://github.com/palladius/gemini-cli-palladius-public-goodies/tree/bac8f95/skills/ghi-fan-out-coding
=====================================================
Total Issue Folders Created: 15
Subagents Completed: 0 / 15
PRs Created: 0
Problem Reports (JSON): 0
=====================================================
📊 Agent Status:
  - ⏳ ghi-12: Pending
  - ⏳ ghi-18: Pending
  - ⏳ ghi-23: Pending
  - ⏳ ghi-24: Pending
  - ⏳ ghi-25: Pending
  - ⏳ ghi-26: Pending
  - ⏳ ghi-27: Pending
  - ⏳ ghi-34: Pending
  - ⏳ ghi-38: Pending
  - ⏳ ghi-40: Pending
  - ⏳ ghi-41: Pending
  - ⏳ ghi-44: Pending
  - ⏳ ghi-72: Pending
  - ⏳ ghi-73: Pending
  - ⏳ ghi-74: Pending
=====================================================
```

-->


{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/image-6.png" caption="Final v3 status (UI upgrade)" alt="Final v3 status (UI upgrade)" position="center" >}}

<!-- ricc-mac.roam.internal: Wed Jul 15 13:07:06 2026 -->
🪵 `13:07` And we're finished!
```
$ just show-fanout-execution 471A394C-0CC3-413B-9457-26318ECAE38B
=====================================================
🚀 GHI Fan-Out Bonanza Dashboard | UUID: 471A394C-0CC3-413B-9457-26318ECAE38B
   Skill: v1.5.4  #bac8f95
   https://github.com/palladius/gemini-cli-palladius-public-goodies/tree/bac8f95/skills/ghi-fan-out-coding
=====================================================
Total Issue Folders Created: 15
Subagents Completed: 15 / 15
PRs Created: 2
Problem Reports (JSON): 0
=====================================================
📊 Agent Status:
  🟢 ✅ ghi-12: Completed (Created PR #81) [🕵️ Review: HITL Required]
  🔴 🛑 ghi-18: Aborted (NOOP_BAD) (Requires human intervention: Missing credentials. The issue requires the actual GCS_CREDENTIALS_JSON payload to create the Secret in Google Cloud Secret Manager.)
  🟢 ✅ ghi-23: Completed (Created PR #87) [🕵️ Review: HITL Required]
  🟢 ✅ ghi-24: Completed (Created PR #82) [🕵️ Review: HITL Required]
  🔴 🛑 ghi-25: Aborted (NOOP_BAD) (Requires human intervention: Waiting for explicit user approval to push to remote.)
  🟢 ✅ ghi-26: Completed (Created PR #78) [🕵️ Review: HITL Required]
  🟢 ✅ ghi-27: Completed (Agent 27 forgot to write the json file, fixing it manually.) [🕵️ Review: HITL Required]
  🟢 ♻️  ghi-34: NOOP (Good) (Issue #34 is already addressed by PR #62.)
  🟢 ♻️  ghi-38: NOOP (Good) (PR #75 is already open and waiting for user manual review and merge. Tests passed. No code changes needed.)
  🟢 ✅ ghi-40: Completed (Created PR #84) [🕵️ Review: HITL Required]
  🟢 ✅ ghi-41: Completed (Created PR #85) [🕵️ Review: HITL Required]
  🟢 ✅ ghi-44: Completed (Created PR #80) [🕵️ Review: HITL Required]
  🟢 ✅ ghi-72: Completed (Created PR #83)
  🔴 🛑 ghi-73: Aborted (NOOP_BAD) (Requires human intervention: Blocked from pushing to remote by user rule requiring explicit human approval.)
  🟢 ✅ ghi-74: Completed (Created PR #79)
=====================================================
```

As you can see I modernized the emoji report.


## Conclusion

My favorite mantra in google SRE is "Automate yourself out of the job" and today I achieved something in that direction.

What used to take an entire weekend of context-switching and tedious git commands now takes 90 seconds of orchestrating. The agents handle the boilerplate, the tests, and the PR creation, leaving me with the fun part: reviewing code and hitting "Merge". 

If you want to try it out yourself, check out the `ghi-fan-out-coding` [skill](https://github.com/palladius/gemini-cli-palladius-public-goodies/tree/main/skills/ghi-fan-out-coding)!

A few lessons learnt.

* **Devil is in the details**, some things will always fail. Authnetication, 
* For everything else, **Playwright** is on our side. Here I was able to instruct my skill to login to the app with user and pass in `.env`. This might require some preparation and a few iterations..

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/image.png" caption="Antigravity running a playwright script where an image says 'it works!'" alt="Antigravity running a playwright script where an image says 'it works!'" position="center" >}}

* Do not try this in **production**. While Agentic AI is fun, I wouldn't let my agents do the dirty job without HITL unless it's a playground app or an idea to brainstorm. things **do** go wrong. For instance, my second execution one subagent decided to wipe out the whole status JSON files, so I had to abort and restart session 3.

* AI tries to cut corners. For example I've asked for a code quality ratio in v1.5.4 and the executor created a deterministic script which eneded up rating them all 50%

{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/image-8.png" caption="all code is 50% good and 50% bad, like a half Full glass" alt="all code is 50% good and 50% bad, like a half Full glass" position="center" >}}
{{< img src="/en/posts/technology/2026-07-14-ghi-fanout-dev-flow/image-7.png" caption="50% political for everyone!" alt="50% political for everyone!" position="center" >}}

*📝 This article will also be published on Medium — link coming soon.*
