---
Harness: Antigravity-cli
Model: Gemini 3.5 Flash (Medium)
Title: "Orchestrating with Antigravity: A Crescendo of Agents (Part 1)"
date: 2026-06-16T12:00:00+02:00
draft: false
User: ricc
Host: derek.zrh.corp.google.com
Bug: b/524911947
Tags: [API, Antigravity, GenAI, Sandbox, Medium, agy, romin]
PublishedURL: ""
Completion: "100"
CTA: https://Antigravity.google/
Status: "draft"
Platform: "Medium, ricc.rocks"
PublishDate: "2026-06-16"
canonicalURL: "https://medium.com/@palladiusbonton/orchestrating-with-antigravity-a-crescendo-of-agents-part-1-b708b132b8a9"
---

I'm a command-line guy. If it doesn't run in a 🖥️ terminal or get driven by a `bash` script, I usually avoid it. For years, my daily workflow revolved around `gemini-cli`, and recently the newer `antigravity-cli` (`agy`). I avoided desktop apps and GUI tools like the plague (with the only exception of `vscode`); a friend call these people *ClickOps*.

But recently, I hit a wall.

<!--more-->

## This article series

As I scaled up my AI agent workflows—managing multiple concurrent coding agents, multi-turn stateful loops, and file changes—babysitting 6 to 12 terminal windows across six virtual desktops became a cognitive nightmare. This is the story of that failure, and the learnings that followed. It is a story in two parts:
1. **Part 1 (This Article)**: Trying to solve agent persistence programmatically via the **Antigravity Managed Agents** and `agy` CLI, and encountering the crescendo of complexity.
2. **Part 2**: Hitting the CLI limit and stepping into the **Antigravity 2.0 UI / Desktop app** to orchestrate parallel local subagents safely with git worktrees.
3. *A part 3 is currently in my brain where I tell the story of how I conceived Ennio Morricone (greatest Italian conductor - see the analogy?) `agy` CLI helper*.

In this first part, we will explore how stateful remote sandboxes work under the hood using the Google GenAI SDK (`antigravity-preview-05-2026`), how to re-attach to container environments, and how to programmatically retrieve your agent workspace.

This first part builds on the foundation laid out in Romin Irani's excellent [Antigravity Managed Agents Tutorial](https://medium.com/google-cloud/antigravity-managed-agents-tutorial-ship-production-ai-agents-b5917844932b) and Phil Schmid's deep dive into [how Managed Agents work under the hood](https://www.philschmid.de/how-managed-agents-work). I spent a day playing around with Romin's article code ideas, customizing them to my own setups, and this article is the output of those experiments. While their articles focus on the architectural and hosted aspects of managed agents, we will look at how a developer can drive stateful remote sandboxes programmatically to build automation loops directly from a local terminal shell.


{{< img src="/en/posts/technology/2026-06-16-crescendo-of-agents-part-1/hero_image.png" caption="Riccardo playing with Stateful Remote Sandboxes" alt="Riccardo playing with Stateful Remote Sandboxes" position="center" >}}

---

## Antigravity Agents: a Stateful delight

In a traditional agent API interaction, each call is stateless. You send a prompt, the agent responds, and the workspace disappears. If you want the agent to edit a file it created in a previous turn, you have to pass the entire file content back and forth in the prompt context. This consumes tokens, increases latency, and makes multi-turn code generation slow and expensive.

The Google Antigravity SDK solves this with **Stateful Remote Sandboxes**. When you run an agent with the environment parameter set to `"remote"`, the SDK:
1. Provisions a private, secure Ubuntu container (sandbox) on Google Cloud.
2. Runs the agent inside that container.
3. Keeps the container alive and returns an `environment_id`.
4. Allows subsequent API calls to re-attach to the same container, inheriting the exact filesystem state.

You don't believe me? Let me show you the code (heavily inspired by [Romin's article](https://medium.com/google-cloud/antigravity-managed-agents-tutorial-ship-production-ai-agents-b5917844932b)).

## The SpaceX IPO Analyzer: Python Orchestration

To demonstrate this capability, let's write a Python script that orchestrates a stateful, multi-turn agent session.

A few days back, SpaceX made the news as the biggest IPO in history, making Elon Musk the first Trillionaire in
history ([Reuters, June 2026](https://www.reuters.com/business/media-telecom/spacex-ipo-makes-elon-musk-worlds-first-trillionaire-2026-06-11/)). Everyone is thinking: should I buy? Should I not? Let's put Gemini to the test.

Our agent acts as a **SpaceX IPO Analyzer**. In the first turn, it researches the SpaceX IPO and generates a Markdown report. In the second turn, it re-attaches to the same container, reads the Markdown report, converts it into a styled HTML dashboard (with custom CSS), and generates a space-themed image asset. Finally, in the third turn, it programmatically downloads the entire workspace container snapshot.

> 💡 *Note: The Antigravity stateful features are accessed using the standard Google GenAI Python SDK by calling the preview agent model (`antigravity-preview-05-2026`) with `environment="remote"`.*

Here is the complete python script:

```python
import os
import requests
import tarfile
from google import genai

client = genai.Client()

print("🚀 Turn 1: Launching SRE/Financial Agent in remote Ubuntu Sandbox...")
# Turn 1: Launch agent to research and write a report in a remote sandbox
interaction_1 = client.interactions.create(
    agent="antigravity-preview-05-2026",
    input="Research SpaceX IPO and save report as spacex-report.md.",
    environment="remote"  # Launches a remote Ubuntu sandbox
)
env_id = interaction_1.environment_id
print(f"✅ Turn 1 Complete. Container Environment ID: {env_id}")


print("\n🔄 Turn 2: Re-attaching to same container and converting to HTML...")
# Turn 2: Re-attach to the SAME sandbox and preserve conversation memory
interaction_2 = client.interactions.create(
    agent="antigravity-preview-05-2026",
    environment=env_id,                              # ← Re-attaches to same sandbox
    previous_interaction_id=interaction_1.id,       # ← Preserves conversation memory
    input="Convert that spacex-report.md file into a clean index.html webpage" +
          " with styling and generate a custom nanobanana image."
)
print("✅ Turn 2 Complete.")


print("\n📦 Turn 3: Downloading the entire container snapshot (.tar) locally...")
# Turn 3: Download the entire sandbox environment state (.tar) locally
api_key = os.environ.get("GEMINI_API_KEY")

response = requests.get(
    f"https://generativelanguage.googleapis.com/v1beta/files/environment-{env_id}:download",
    params={"alt": "media"},
    headers={"x-goog-api-key": api_key},
)

tar_path = "snapshot_env.tar"
with open(tar_path, "wb") as f:
    f.write(response.content)

print(f"✅ Snapshot downloaded to {tar_path}. Extracting...")
with tarfile.open(tar_path) as tar:
    tar.extractall(path="./workspace_extract")
# Wow! We've dumped the remote agent workspace locally!
print("🎉 Workspace extracted successfully! Check ./workspace_extract/")
```

Let's unpack what just happened in this code:

1. **Spin up: Investigation**. Google creates a docker container on a Ubuntu machine somewhere, and this instance *with REAL disk* starts    doing some research on SpaceX IPO.
2. **Continuation: format Conversion**. Convert MD to HTML. This is silly - we could have done an HTML in iteration 1 of course - but it serves the purpose to demonstrate you can park your calculation today and come back tomorrow and **continue the session** and iterate over it, maybe with a chat over Telegram ;)
3. **Pull results locally** This is the magical part: `git pull remote-workspace`. This is where we know it's REAL. There's a real workspace
   there, maybe with some remote github repo pulled and some added Unit Tests. In our case, it contains  **`spacex-report.md`** (created in turn 1),  **`index.html`** and **`nanobanana.jpg`** (The space-themed HTML dashboard created in Turn 2), finally a CSS to make all very nice and space-themed.

This is what I see opening **`index.html`** with my browser:

{{< img src="/en/posts/technology/2026-06-16-crescendo-of-agents-part-1/image-spacex-ipo-report-page1.png" caption="Page 1 of the generated SpaceX IPO analysis dashboard." alt="Page 1 of the generated SpaceX IPO analysis dashboard." position="center" >}}

{{< img src="/en/posts/technology/2026-06-16-crescendo-of-agents-part-1/image-spacex-ipo-report-page2.png" caption="Page 2 of the generated financial dashboard, displaying the bull/bear investment case." alt="Page 2 of the generated financial dashboard, displaying the bull/bear investment case." position="center" >}}

<!--
## TODO(ricc) Scaling Up: The Multi-Agent Complexity Wall [todo move this title to the conlciiosons.]
-->

## Experiment 2: watch me coding (pun intended!)

My son is great at Math. Nearly as good as *papino*. However, he struggles with watches.

After watching *Heroes*, I've always been a bit wary of watchmakers (especially [Sylar](https://www.youtube.com/watch?v=MqIf3ysYPmg)). But recently, I spent a whole day helping my 8-year-old son struggle to map an analog clock pointing at 19:45 to its digital string representation. It was frustrating because he is actually fantastic at math—once he can work with digital time strings, he can calculate time differences like `08:45 +/- 20 minutes` in seconds. The blocker was entirely visual.

So, I decided to build a game to help kids bridge this gap. The goal was to build `orologia.io`—a cross-platform mobile game built in Flutter.
This is because we travel a lot, and I need apps working on my Android on a plane.

A catchy name, that's the easy part! [`orologia.io`](https://github.com/palladius/orologia.io)

{{< img src="/en/posts/technology/2026-06-16-crescendo-of-agents-part-1/image-orologia-ui.png" caption="since the '.com' era is so 2000s, and the Sardinian '.io' era is now!" alt="since the '.com' era is so 2000s, and the Sardinian '.io' era is now!" position="center" >}}

Here is how we used a single stateful agent script to build the initial prototype. We passed a detailed multi-step prompt to the agent — asking it to read `docs/PRD.md`, implement the game, run a local server, take a screenshot, and file a GitHub PR.

Here is the core logic we used to run this stateful agent loop. It uses the `google-genai` SDK to provision the remote sandbox, mounts the `orologia.io` git repository, and downloads/extracts the final workspace snapshot.

You can view the complete, self-contained execution script at [solutions/20260615-antigravity-managed-agents/run-agent-prototype.py](https://github.com/palladius/orologia.io/blob/main/solutions/20260615-antigravity-managed-agents/run-agent-prototype.py).

Here is the core API setup, repository mounting, and snapshot download sequence:

```python
from google import genai
import requests, os

client = genai.Client()
api_key    = os.environ["GEMINI_API_KEY"]
gh_token   = os.environ.get("GITHUB_TOKEN")  # optional: enables the agent to push a PR

# Mount the git repo AND inject the GitHub token as a file into the sandbox
sources = [
    {"type": "repository",
     "source": "https://github.com/palladius/orologia.io",
     "target": "/workspace"},
    {"type": "inline",
     "target": "/workspace/.github_token",
     "content": gh_token},  # ← secret injection!
]

# The prompt tells the agent exactly what to build
prompt = """
You are an expert full-stack developer agent.
The repo `orologia.io` is mounted at `/workspace`.

1. Read `docs/PRD.md` and implement a beautiful clock-learning game (index.html + CSS + JS).
2. Make it stunning: analog clock with rotating hands, digital display, scoring, BCD visualization.
3. Optionally screenshot it, then commit and open a PR using the token at `/workspace/.github_token`.
"""  # Full prompt: https://github.com/palladius/orologia.io/blob/main/solutions/20260615-antigravity-managed-agents/run-agent-prototype.py

# Launch remote stateful sandbox agent
interaction = client.interactions.create(
    agent="antigravity-preview-05-2026",
    input=prompt,
    environment={"type": "remote", "sources": sources}
)

# Download final snapshot locally
url = f"https://generativelanguage.googleapis.com/v1beta/files/environment-{interaction.environment_id}:download"
response = requests.get(url, headers={"x-goog-api-key": api_key}, params={"alt": "media"})
```


Rather than jumping straight into a complex Flutter mobile app, we had the agent create a rapid "vibe-coded" prototype in plain HTML, CSS, and JavaScript. By describing the clock mechanics and visual feedback loop in a single turn, the agent generated a responsive clock app in one minute.

*   **Vibe-Coded Prototype Code**: [solutions/20260615-antigravity-managed-agents/](https://github.com/palladius/orologia.io/tree/main/solutions/20260615-antigravity-managed-agents)
*   **Clock UI Draft**: The agent designed interactive options, matching analog times to multiple digital buttons (you can view early drafts like [orologia_ui_one_clock_four_bcds.png](https://github.com/palladius/orologia.io/blob/main/docs/ricc_draft.jpg)).
*   You can play the final game yourself here: [palladius.github.io/orologia.io](https://palladius.github.io/orologia.io/)
{{< img src="/en/posts/technology/2026-06-16-crescendo-of-agents-part-1/image.png" caption="You can play the game under https://palladius.github.io/orologia.io/ !" alt="You can play the game under https://palladius.github.io/orologia.io/ !" position="center" >}}

{{< img src="/en/posts/technology/2026-06-16-crescendo-of-agents-part-1/image-1.png" caption="And here is Alessandro winning the game!" alt="And here is Alessandro winning the game!" position="center" >}}

This proved the value of single-agent rapid prototyping. But what happens when you try to scale past a single prototype and orchestrate multiple subagents concurrently to implement the full-blown cross-platform Flutter mobile game?

{{< img src="/en/posts/technology/2026-06-16-crescendo-of-agents-part-1/image-cooking-agents-mess.png" caption="Riccardo surrounded by a million agents and being desperate" alt="Riccardo surrounded by a million agents and being desperate" position="center" >}}

**This** is where I hit the wall and resolved to invent a Worktree + Conductor Carlessian-customized workflow.... but this is for another article... 🚀  [Orchestrating with Antigravity: A Crescendo of Agents (Part 2)](https://ricc.rocks/en/posts/technology/2026-06-16-crescendo-of-agents-part-2/)

---

## Key Takeaways (Gemini)

1.  **`environment_id` Isolation**: Container preservation keeps your agent workspace hot. You don't need to rebuild context or transfer files over network sockets.
2.  **Environment Download API**: Bridge the cloud container to local storage. By downloading the workspace state directly, you can easily integrate AI agent builders into your CI/CD pipelines, local editors, or backup routines.
3.  **True Multi-Turn Autonomy**: The combination of stateful sandboxes and local workspace downloads allows developers to build complex, multi-agent compilers that perform heavy lifting entirely in the cloud, while delivering clean, completed output artifacts to the host system.
4.  **The Visual Feedback Loop**: Multi-agent systems building frontend components cannot rely on text logs alone. A visual interface and quick prototyping (vibe coding) are essential to guide agents toward high-quality UX.
5.  **CLI Orchestration Limits**: While the terminal is great for single-agent automation, coordinating parallel developer subagents with visual handoffs pushes CLI to its limits. This is where visual IDEs and desktop thread managers become necessary.

## What are these Remote Agents good for?

So the big question is: **What are these Remote Agents good for?**. You could argue that *everything is more comfortable in localhost*,
but I see this as a pioneering of the "agents `Dockerfile`s" where you start playing with something locally, then a piece at a time you
start building your own "agent container" with `bin/custom-script` and `.gemini/my-smart-config` and maybe a `gcloud` ServiceAccount `sa.json` and
boom! You have a repeatable, secure, self-contained sendbox where you can interact with the Internet with the power of Gemini! Remember, `git clone` and `API_KEYS` are a powerfule combination!

My personal **Key Takeaways**:

* Do NOT use for a one-off investigation. Use Web or local CLI instead, it's much faster.
* Use for repeatable workflows where the config takes a lot more than the final prompt. In other words, anything where you have 5 prompts of which 1-2-3-4 are the same, and 5 always changes. This is IMHO the sweet spot where these excel.


Example: I'm currently working on containerizing a travel planner for my family where I just say the trip I want to plan, when and the constraints. Yes, it feels like a fine-tuned model, but fully FS observable!

{{< img src="/en/posts/technology/2026-06-16-crescendo-of-agents-part-1/image-sardinia-travel-agent.png" caption="The agent built a full Sardinia travel plan — with a flight proof and an itinerary map — from a three prompts (1 and 2 are constant), and with provable flight booking links." alt="The agent built a full Sardinia travel plan — with a flight proof and an itinerary map — from a three prompts (1 and 2 are constant), and with provable flight booking links." position="center" >}}


---

🚀 **Ready for Part 2?** Read [Orchestrating with Antigravity: A Crescendo of Agents (Part 2)](https://ricc.rocks/en/posts/technology/2026-06-16-crescendo-of-agents-part-2/) to see how we scale this local development flow using git worktrees, Conductor++, and parallel subagents under Agostina.


<!--

TODO(gemini): This developer note should NOT be in the article, but should be ADDED to the out/ricc.rocks/XX article created programmatically.

⚠️ DEVELOPER NOTE (DO NOT EDIT THIS GENERATED FILE DIRECTLY IN RICC.ROCKS):
This post is compiled and synced from the private source repository.
Source path: ~/git/ricclife-with-gemini-pvt/work/articles/20260605-worktree-multiagent-dev-flow/articles/01-crescendo-of-agents-part-1/
To redeploy / sync updates, run:
cd /usr/local/google/home/ricc/git/ricclife-with-gemini-pvt/work/articles/20260605-worktree-multiagent-dev-flow/ && just build && just copy-to-ricc-rocks
-->

*Read this article on Medium: <https://medium.com/@palladiusbonton/orchestrating-with-antigravity-a-crescendo-of-agents-part-1-b708b132b8a9>.*
