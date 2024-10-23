## Geminocks

Project `Geminocks` (from "Gemini rocks"). :gemini:

## Folders

* `bin/`: scripts
* `doc/`: source docs. Still unsure how to categorize Work vs Personal or get Gemini to auto-detect.
* `etc/`: configs
* `out/`: output configs.

## Idea :bulb:

The idea is to use Gemini to write down automated markdown content with Gemini.
You write it once with

---
headers (possibly adapted.)
---

and in English and it will:

1. Translate to Italian.
2. Create header for different solutions, like
3. Use function calling to create header ([front matter](https://gohugo.io/content-management/front-matter/)) for different solutions.

A simple `make` command will produce the output in local (not on the web, since Gemini is now free) and some magic `cp -R` will update the ZZO and other Hugo thingies.
