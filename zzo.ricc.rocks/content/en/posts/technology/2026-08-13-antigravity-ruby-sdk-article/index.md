---
type: Article
status: done
priority: P1
title: "Building an Agentic Telegram Bot in Ruby with Google's Antigravity SDK"
date: 2026-08-13T15:45:00+02:00
draft: false
image: "/en/posts/technology/2026-08-13-antigravity-ruby-sdk-article/images/hero.jpg"
description: "What if your Ruby app could think, learn new skills at runtime, and tell you exactly what it is doing in real-time? Introducing the Antigravity Ruby SDK for Google's agentic harness."
categories: ["Antigravity", "Ruby"]
tags: ["Google", "Antigravity", "Ruby", "Gemini", "Telegram", "Agentic", "SDK"]
author: "Riccardo Carlesso"
version: "0.4.2"
Platform: "Medium and ricc.rocks"
PublishDate: "2026-08-13"
bug: "b545986615"
# canonicalURL: (pending Medium publication)
ricc_signoff: "true"
CTA: "https://github.com/palladius/antigravity-ruby-sdk"
gunningFog: 11.16
slopScore: 28.5
valescore: 45
---

*What if your Ruby app could think, learn new skills at runtime, and tell you exactly what it's doing -- all in a single terminal line?*

{{< img src="/en/posts/technology/2026-08-13-antigravity-ruby-sdk-article/images/hero.jpg" caption="Hero: Ruby gemstone connected to Telegram and a terminal" alt="Hero: Ruby gemstone connected to Telegram and a terminal" position="center" >}}

## Introduction

When Guillaume Laforge built the [unofficial Antigravity SDK for ☕️ Java](https://github.com/glaforge/antigravity-java-sdk) (and documented it in [his article](https://glaforge.dev/posts/unofficial-antigravity-sdk-for-java/)) back in July, I thought: *"If ☕️ Java gets one, [🪨 Ruby](https://www.ruby-lang.org/) deserves one too."* So I built one. And then I built a [Telegram](https://telegram.org/) bot on top of it. And then the bot learned to discover and load skills at runtime. And then I needed to debug why the model kept going silent after exactly 7 WebSocket messages.

This is that story.

The [Antigravity Ruby SDK](https://github.com/palladius/antigravity-ruby-sdk) is an unofficial Ruby wrapper around Google's [Antigravity](https://antigravity.google/download) harness -- the same engine that powers Gemini CLI, Antigravity IDE, and Antigravity 2.0. By connecting it to [Telegram](https://telegram.org/) and the Telegram Bot API, it gives your code access to Gemini's full agentic capabilities: tool calling, skill loading, streaming responses, and now, a generic event system for real-time observability right inside your chat window.

## How It Works

The architecture is deliberately simple. Your Ruby process talks to a local Go binary (the "harness") over WebSocket. The harness handles the heavy lifting: authentication, model communication, tool execution, and safety policies. Your SDK just needs to speak JSON.

{{< img src="/en/posts/technology/2026-08-13-antigravity-ruby-sdk-article/images/architecture.jpg" caption="Architecture: User -> Telegram -> Ruby Bot -> SDK -> WebSocket -> Harness -> Gemini" alt="Architecture: User -> Telegram -> Ruby Bot -> SDK -> WebSocket -> Harness -> Gemini" position="center" >}}

```text
+------------------------------------------------------------+
|                    Telegram Application                    |
|                                                            |
|  Telegram User <-> Telegram API <-> Ruby Bot (ChatSession) |
+------------------------------+-----------------------------+
                               |
                               v
+------------------------------------------------------------+
|           Antigravity Ruby SDK (`antigravity-sdk`)         |
|                                                            |
|  +---------------------------+  +-----------------------+  |
|  | Antigravity::Agent        |  | Antigravity::Hooks    |  |
|  | (ask, prompt, auto-conn)  |  | (pre/post event hooks)|  |
|  +---------------------------+  +-----------------------+  |
|  | Antigravity::Conversation |  | Antigravity::Connect  |  |
|  | (chats, tool runner)      |  | (WebSocket manager)   |  |
|  +---------------------------+  +-----------------------+  |
+------------------------------+-----------------------------+
                               | (WebSocket on 127.0.0.1)
                               v
+------------------------------------------------------------+
|               Core Go Binary (`localharness`)              |
|                                                            |
|  - Manages agent session state, turns & tool routing       |
|  - Connects to Google Antigravity & Gemini backends        |
|  - Sends JSON-RPC tool dispatch requests over WS           |
|  - Streams token deltas, thoughts & turn completions       |
+------------------------------------------------------------+
```

## Getting Started: 5 Lines to Your First Agent

```ruby
require 'antigravity'

agent = Antigravity::Agent.new
agent.connect!  # Auto-connects if omitted
response = agent.ask("What's the mass of the Sun?")
puts response.content
```

That's it. The SDK spawns the harness, opens a WebSocket, sends your prompt, streams the response, and returns the full text. Under the hood, about 2000 lines of Ruby handle connection management, session lifecycle, tool routing, skill resolution, and structured logging.

## Building a Telegram Bot

The real fun starts when you connect the SDK to a messaging platform. Here's the core loop of our Telegram bot:

```ruby
bot.listen do |message|
  session = sessions[message.chat.id] ||= ChatSession.new(
    skills: SKILL_DIRS,
    tools: [find_skills_tool, load_skill_tool]
  )

  response = session.ask(message.text)
  bot.api.send_message(chat_id: message.chat.id, text: response)
end
```

Each Telegram chat gets its own `ChatSession` with its own Antigravity agent. The agent starts with a "metaskill" -- a skill that knows how to find and load other skills. Users can ask the bot to learn new capabilities on the fly:

> **User:** Find the riccardo-todo skill
> **Bot:** Found `riccardo-todo` at `/path/to/skills/riccardo-todo`
> **User:** Load it
> **Bot:** *[restarts session with new skill]* Loaded! I now know about your to-do list.
> **User:** Where's my to-do file?
> **Bot:** According to the skill, it's at `~/obsidian/TODOs/TODOz.md`

*But I don't want to type on Telegram, I want to speak with microphone!* No worries, dude, we got you. I've tested the SDK with Italian and English and it worked great! You just need to add this to your .env:

```
# See .env.dist for more info
TELEGRAM_BOT_TOKEN="<YOUR_BOT_TOKEN>"
TELEGRAM_CHAT_ID=<YOUR_CHAT_ID>
# [optional] Needed for Speech-to-Text translation, emojis are on us.
GEMINI_API_KEY=<your-api-key-here>
```

Don't believe me? Here's the view from my CLI.

![WhatsApp audio view from CLI v2](<images/telegram audio view from CLI.png>)

And here's how it looks on my phone:

{{< img src="/en/posts/technology/2026-08-13-antigravity-ruby-sdk-article/images/telegram-screenshot.png" caption="Telegram screenshot v2" alt="Telegram screenshot v2" position="center" >}}

I think you can work the maths even if you don't speak Italian!

## Skills: Superpowers for Your Agent

Skills are the [Agent Skills](https://agentskills.io) standard -- a `SKILL.md` file with YAML frontmatter and markdown instructions. The SDK supports:

```ruby
# Local paths
agent = Antigravity::Agent.new(skills: ["/path/to/my-skill"])

# GitHub URLs (auto-cloned to ~/.antigravity/cache/). Try our great SRE extension!
agent = Antigravity::Agent.new(skills: ["https://github.com/gemini-cli-extensions/sre"])

# Runtime discovery
agent.add_skill("/discovered/path", skill_name: "new-skill")

# Inline skills (no files needed)
agent.add_inline_skill(
  name: "greeter",
  description: "Greets users in Italian",
  instructions: "Always greet the user with 'Bella vecchio!'"
)

# You can also count them
agent.skills.count
=> 16
```

The runtime loading now attempts dynamic skill loading within the same session. If the model struggles to invoke the new skill, we fall back to a manual failsafe that reads the skill definition and executes it directly.

Personally, I enable at startup a single meta-skill for skill discovery based on my skills ruby script agc` (like `npx skills` but better): https://github.com/palladius/agc

Wanna try it? Just type this:

```bash
just rv-skill-telegram
# which is equivalent of:
rv run ruby examples/08_skill_telegram_bot.rb
```

My friend [Andre Arko](https://arko.net/) will be so happy to see I'm finally using [`rv`](https://github.com/spinel-coop/rv/) (yes, it's the ruby version of Astral `uv`, but faster!)

## The Hooks System: 3 Lines That Changed Everything

This is where Ruby shines. We needed debug observability for the WebSocket traffic, but didn't want to pollute the core `Conversation` class. The solution: a generic pub/sub event system.

**The entire core change:**

```ruby
# lib/antigravity/hooks.rb -- 2 methods added
def on(event, &block)
  @listeners[event.to_sym] << block if block_given?
end

def emit(event, *args)
  @listeners[event.to_sym].each { |cb| cb.call(*args) }
end

# lib/antigravity/conversation.rb -- 1 line added
@hooks&.emit(:ws_message, msg)
```

That's it. Three lines in the SDK. Everything else lives in the consumer:

```ruby
# In your app, test, or bot -- NOT in the SDK
agent.hooks.on(:ws_message) do |msg|
  if (s = msg[:stepUpdate])
    puts "Tool: #{s[:textDelta]}" if s[:target] =~ /ENVIRONMENT/
    print "." if s[:thinkingDelta]
  end
end
```

Instrumenting the TUI was never this easy! *Decorate this, Python!* :)

**Zero lines of debug code in the core SDK.** All observability is opt-in, external, and composable. This is the Ruby way.



## The Dynamic TUI Status Line

The hooks system's first real consumer was a dynamic terminal status line for the E2E test. One line that overwrites itself in-place:

```
     🏃 running 💭💭💭 ⏳42s 7↕
```

The implementation uses ANSI escape codes (`\r\e[K`), a state emoji map, and a background ticker thread:

```ruby
# Background thread ticks every second
@_ticker = Thread.new do
  loop do
    sleep 1
    _render_status if @_status[:active]
  end
end

def _render_status
  icon = case @_status[:state]
         when /RUNNING/ then '🏃'
         when /IDLE/    then '😴'
         when /CANCEL/  then '🛑'
         else '⏳'
         end

  elapsed = (Time.now - @_status[:started]).to_i
  line = "     #{icon} #{@_status[:state].downcase}"
  line += " #{@_status[:dots]}" unless @_status[:dots].empty?
  line += " ⏳#{elapsed}s #{@_status[:msg_count]}↕"

  print "\r\e[K#{line[0, 79]}"
  $stdout.flush
end
```

The result: you ALWAYS know what the agent is doing. Thinking? You see `💭💭💭`. Calling tools? You see `🔧 Find todo files`. Stuck? The timer keeps ticking: `⏳42s... ⏳43s... ⏳44s...`

## Debugging a Model Hang: A War Story

With the TUI in place, we caught a fascinating bug. When loading a new skill dynamically in Phase 3 of our E2E test, the model would sometimes hang -- every single time, with the exact same pattern:

```
     🏃 running 💭💭💭💭💭 ⏳2s 7↕
     🏃 running 💭💭💭💭💭 ⏳3s 7↕
     ...
     🏃 running 💭💭💭💭💭 ⏳59s 7↕
  ⚠️  Error: Wall-clock timeout after 60s
```

The model sent exactly 5 thinking deltas at the 2-second mark, then went completely silent. No `DONE`, no `FULLY_IDLE`, no error -- just nothing.

### What we learned the hard way

1. **Large tool results cause "thinking hangs".** Our `load_skill` tool was originally returning the entire 61-line `SKILL.md` content. This massive context dump overwhelmed the model, causing it to spin its wheels indefinitely. By optimizing the tool to return a concise 4-line summary (name, script path, description, usage hint), the model processed it instantly.

2. **Failsafes are better than session restarts.** We used to restart the entire session when loading a skill to ensure the model recognized it. Now, we use dynamic skill loading in the same session. If the model still times out in Phase 4 (acting on the new skill), our harness kicks in with a manual failsafe: it reads the `SKILL.md` and builds the `uv run` command directly, bypassing the agent loop entirely.

3. **Idle timeout != wall-clock timeout.** The SDK's `timeout:` parameter is a per-message idle timeout. If the model keeps sending tool calls, each response resets the timer. We added `Timeout.timeout()` as a hard wall-clock deadline.

With these improvements, all 9 E2E tests now pass consistently in around 73 seconds. This bug and its resolution are tracked in [Issue #16](https://github.com/palladius/antigravity-ruby-sdk/issues/16).

## Ruby Tips for Agent Code

A few patterns that proved invaluable:

### Tool Result Hygiene

Keep your tool responses concise. Models struggle with large, unstructured text dumps from tools (as seen in our model hang war story). Return only the essential metadata the agent needs to make its next decision, rather than full file contents or verbose logs.



### `ensure` for guaranteed cleanup
```ruby
def ask(text, wall_timeout: 180)
  @_status[:active] = true
  Timeout.timeout(wall_timeout) { ... }
ensure
  @_status[:active] = false  # ALWAYS runs, even on Timeout::Error
  print "\r\e[K"             # Clear the status line
end
```

### Monkey-patching for terminal aesthetics
```ruby
class String
  def to_bold    = "\e[1m#{self}\e[0m"
  def to_cyan    = "\e[36m#{self}\e[0m"
  def to_green   = "\e[32m#{self}\e[0m"
  def to_gray    = "\e[90m#{self}\e[0m"
  def to_red     = "\e[31m#{self}\e[0m"
  def to_yellow  = "\e[33m#{self}\e[0m"
end

puts "  ✅ PASS".to_green
puts "  ❌ FAIL".to_red

```


## What's Next

The [Antigravity Ruby SDK](https://rubygems.org/gems/antigravity-sdk) is at v0.4.2 with all 9 E2E tests passing consistently. Here's what's coming:

| Feature                                         | Status    | Issue                                                              |
| ----------------------------------------------- | --------- | ------------------------------------------------------------------ |
| Mid-session skill loading                       | Shipped   | [#15](https://github.com/palladius/antigravity-ruby-sdk/issues/15) |
| MCP server support                              | Planning  | --                                                                 |
| Channel abstraction (Telegram/WhatsApp/Discord) | Planning  | --                                                                 |
| Protobuf handshake                              | Backlog   | --                                                                 |
| Rails integration                               | P4 Vision | --                                                                 |

## Next steps: A beautiful Policy Engine

Any language can define a good policy engine. Only Ruby, I might argue, can define a beautiful policy engine DSL. And Atnigravity is the best partner in crime for this design!

How does [this](https://github.com/palladius/antigravity-ruby-sdk/issues/21) look, my friends?

{{< img src="/en/posts/technology/2026-08-13-antigravity-ruby-sdk-article/images/beautiful-policy-engine.png" caption="Beautiful Policy Engine" alt="Beautiful Policy Engine" position="center" >}}


## Your Turn

The [Antigravity Ruby SDK](https://github.com/palladius/antigravity-ruby-sdk) is open source and ready for experimentation! You can install it directly via the [`antigravity-sdk` gem on RubyGems](https://rubygems.org/gems/antigravity-sdk) (published with 5 downloads already! 💎) or clone the repository:

```bash
gem install antigravity-sdk
# OR clone the source
git clone https://github.com/palladius/antigravity-ruby-sdk
cd antigravity-ruby-sdk
cp .env.dist .env  # add your config
ruby examples/01_hello_world.rb
```

I'm genuinely curious how you'd use this. Would you build a Slack bot? A Rails assistant? A CLI tool that learns from your codebase? Open an issue, send a PR, or just say hello.

I'm currently looking for interetsing use cases for pre/post hooks and sidecars. If you have a neat use case, let me know: I might build it for you!

And if you want to see what Guillaume built for Java, check out [his article](https://glaforge.dev/posts/unofficial-antigravity-sdk-for-java/) -- it's the post that started this whole Ruby adventure.

---

*Riccardo Carlesso is a Developer Advocate for Google Cloud, focusing on Open Source, Developer Experience, and occasionally building things that probably didn't need to exist but are wonderful anyway.*

*The Antigravity Ruby SDK is an unofficial, community project. It is not an official Google product.*

*📝 This article will also be published on Medium — link coming soon.*
