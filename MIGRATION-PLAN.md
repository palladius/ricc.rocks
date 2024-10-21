
For now migrating stuff is manual.
something like this:

```
# Deciding to migrate MD from `zzo.ricc.rocks/content/en/posts/travel/` to Gemini.
ricc@derek:🏡~/git/ricc.rocks$ git mv ./zzo.ricc.rocks/content/en/posts/travel/ gemini/doc/posts/original-work/travel/
ricc@derek:🏡~/git/ricc.rocks/zzo.ricc.rocks/content/en/posts$ touch travel.migrated-to-gemini.touch
```

Many problems arise:

* post links break in case.
* What about images links? Fingers crossed.
* maybbe DRY this into a script?


## Gemini bugs

Only from Derek:

```
Net::ReadTimeout: Net::ReadTimeout with #<TCPSocket:(closed)>
```
