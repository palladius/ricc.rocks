---
title: "Get started with gemini-cli: let's vibecode an app"
date: 2025-06-25T14:22:07+02:00
draft: false
tags: [ "gemini","gemini-cli", "portfolio", "generative-ai" ]
categories: [ "technology", "google" ]
image: /en/posts/medium/2025-06-25-gemini-cli-chromext/250603b4220753--ic2a2erzc3n.png
---

# Get started with gemini-cli: let's vibecode an app

On June 23rd, the DeepMind team has dropped a bomb 💣: `gemini-cli` !\
I'm so excited to show you how it works so.. Why don't we code an application from scratch? I had this idea this morning of making a more complex and good looking version of [palladius/my-sessions-and-bio](https://github.com/palladius/my-sessions-and-bio) so.. Why don't we do it in a language that I don't speak?

What did you say, Latin? *Tanem Latine loquor*. Sorry, let's try something more esoteric and incomprehensible, like… Javascript!

![image: 250603b4220753--ic2a2erzc3n.png

For this test, I'm using:

-   `Gemini-2.5-pro-preview-06-05`
-   `Gemini-cli commit #[7ba2b13](https://github.com/google-gemini/gemini-cli/commit/7ba2b1387029fdb9c31ca51439a40d59889f05c5).`

If you're curious, the final app: [https://portfolio-app-272932496670.europe-west1.run.app/](https://portfolio-app-272932496670.europe-west1.run.app/)

## It all starts with a prompt..

You have an idea for an app? Put it in `[GEMINI.md](GEMINI.md) `\
This should have both your schema/database requirements, functional and non functional requirements, UI, language and everything. In my case, I started with this.#

![image](250611[startin--4oit7udt2wa.png)

Note the typo. Let's start coding!

![image](250611[startin--mh9rylhw2xo.png)

Oh wow, first thing you do a README with a mermaid graph of your proposed schema?!? I dig that! Best start ever!

![image](250611[startin--f5g7v7p0x87.png)

The it adds a `justfile`, since i asked politely in the [GEMINI.md](GEMINI.md) file.\
Time to create the app (gemini chose **[Next.js**](Next.js)):

![image](250611[startin--qeljkub53ta.png)

And here's the first hiccup: \
*✦ It seems I can't create a Next.js app in a non-empty directory. I'll move the conflicting files to a temporary location, create the app, and then move them back.*

This is the part I love the most: he tries, makes a mistake, and adjusts based on CLI output! All without me doing anything except ACCEPT. After a few errors, the app was created on an empty folder and Gemini is nicely returning all our items back to the folder.

![image](250611[startin--az9nhxxncea.png)

Again, it tries executing but port 3000 is taken, so he tries 3001. No biggie!

![image](250611[startin--jywvcoqanmh.png)

Ok, now the server is stuck, since Gemini is running the server in foreground. That's where the human comes to help.

-   My first UI Error: Console Error **Hydration failed because the server rendered HTML didn't match the client. As a result this tree will be regenerated on the client. This can happen if a SSR-ed Client Component used:**
-

Ok this is an error we can work with. Let me do this:

1.  Start the app on another tab
1.  Restart gemini-cli and update the AI:

undefined

Gemini understand the error, tries to fix it and again, small hiccups, which he's able to navigate very easily:

![image](250611[startin--45z2e77854x.png)

Now Gemini asks me to do something, and I need to be specific of my utter ignorance here:

-   ♊ Gemini: I've applied the fix. Please check your browser and let me know if the hydration error is gone.
-   💛 Riccardo: Error is still there. Excuse my ignorance, do i have to (1) restart the server? (2) ctrl-f5 to force a refresh of JS? I'm ignorant here.
-   ♊ My apologies, you are correct to ask. The Next.js development server usually picks up changes automatically (hot-reloading), but a hard refresh is always a good idea to clear the browser cache.   However, I've made a mistake. Looking back at the error you posted, the problematic attributes were on the <body> tag, but I added the suppression attribute to the <html> tag. I need to  move it. I will correct my mistake now.

## Next, lets populate the data!

-   💛 fixed thanks. whats next? Can we start importing sample data into YAML first, then to sqlite, then to Firestore?  So while you code i can cleanup the data.

![image](250611[startin--as6sef8lpj.png)

Ok, looks like the data is flowing to YAML.

-   ♊  I've created the `etc/data.yml` file. You can now review and edit it.   Next, I'll create a script to parse this YAML file and a library to interact with a SQLite database. I'll start by installing the necessary dependencies for SQLite and YAML parsing.

Now it's writing import code.

-   G: ✦ I've added the import command to your justfile. Before you can run it, you'll need to install tsx, which is a tool to execute TypeScript files directly.
-   ✦ Now you can run just import to populate your SQLite database from the YAML file.
-     While you're reviewing the data in etc/data.yml, I can start building the UI to display it. Does that sound good?

I'm excited and honoured of such a nice purposefulness! However I'm not going to compromise on my 1st world principles:

-   Ricc: SGTM! One minor nit, I like yaml files to have .yaml extension, not .yml.
-   G: You got it. I'll rename the file and update the import script. "I like you. Is nice."
    -    ✔  Shell `git mv etc/data.yml etc/data.yaml` (Rename etc/data.yml to etc/data.yaml using git.)
-   …
-   G: ✦ I've updated the main page to display the talks and articles. Before you check the browser, you'll need to run the import script to populate the database.
-
-   GEM:  Run just import in your terminal., can you try yourself?

I've found the error, but I have two small children and I know the difference between fishing for them and teaching them to fish. Hence:

-   RICC: │i tried and failed. I can paste the error, but its easier if you try executing it yourself and fix the code. How does that sound?                                                          │
-   GEM: ✦ Of course. I'll run the import script myself and fix any errors that arise.

![image](250611[startin--c7oypvaf1np.png)

🥴 This is the magic moment where you understand that he can find the errors and fix them himself! Three iterations and…

-   ♊ Now that the sqlite package is installed, I'll try running the import script again.
-   ✔  Shell just import (Run the data import script.)
    -   npx tsx scripts/[import-yaml.ts](import-yaml.ts)
    -   npm warn Unknown user config "always-auth"
    -   ✅ Data imported successfully!

-   ♊  Now, please check your browser. You should see the talks and articles listed on the page. Let me know what you think of the initial layout.

## Ouch an error! I don't want to babysit Gemini, I need a way out!

Now we have a dilemma. For the first time, Gemini needs us for his feedback loop. \
I don't want to click reload and tell him what I see. Luckily, the output of the `$ just run` gives me the same error as the UI. And text, Gemini can read! Let's try\
Ehm, unfortunately

![image](250611[startin--ftq9vgjdrw5.png)

* 💛 **Dear Gemini, I can see there is a module not found error on UI (which you can't see). But the same error appears on `just run` . So I ask you: can you teach me to run npm in a way that we log somewhere under a git-ignored log/ folder which you can comfortably read and grep? Teach me how to run npm to dump its output to log so we can automate this.**

-   ♊ Of course. That's an excellent idea and a great practice for development. I'll teach you how to do that and then use it to debug the issue.
-   Here's the plan:
    -   1. Create a log directory where we'll store the log files.
    -   2. Update your .gitignore file to ensure this log directory isn't accidentally committed to your repository.
    -   3. Modify your justfile to add a new run-dev command that starts the server and redirects all its output to log/dev.log. I'll also add a log command to make it easy to view the logs.

![image](250611[startin--vhzyskn5z3.png)

-    Please run just run-dev in your terminal. After a few seconds, run just log and paste the output here so I can see the error.
-   💛 I've done the just run-dev, now YOU do the just log every time you need ;)

undefined

And finally the magic happens: Gemini is able to see the error and course-correct in real time. I can now grab my coffee and…\
Oh wait, it's already there!

![image](250611[startin--mgn7gg894o.png)

that's a good start!

-   💛And it works! Time for a first commit. Remember VERSION and CHANGELOG ;)

And we have a good commit and **[CHANGELOG**](https://github.com/palladius/vibecoding/blob/main/apps-portfolio/CHANGELOG.md) 🙂. We can go on with the next.

## Let's push it to the Cloud now!

✦ The changes have been committed. What's next on our list?

-   Ricc: a few steps: prettify the UI and add an image for EVERY element. But first I'd start pushing to cloud run. can u help me? I'd like to have a cloudbuild.yaml built for me so upon new git commit/push it automatically

✦ Now I'll create the cloudbuild.yaml file. I'll need to know your Google Cloud Project ID to configure it correctly. Can you please provide it?

-   ♊
-   💛ricc-genai , and use a european region, like europe-west1.

Now Gemini is teaching me how to configure my project, which is useful:

![image](250611[startin--euab0i8u65l.png)

-   💛 yes. Also pls add a docker-build and docker-run justfile scripts to test dockerization - you know it tends to fail ;) finally, write a justfile script to trigger cloudbuild.yaml
-    from here, so you can test it yourself and find yourself the errors ;)
-   💛 Also dump the instructions on cloud build setup in the README for me to act upon later. Then you can commit
-   ♊ ✦ It seems the Docker daemon is not running. I cannot start it myself. Could you please start the Docker daemon and then I'll try again?
-   💛 my apologies, i can fix this tomorrow. Lets try something else. Can you trigger the cloudbuild from here and see logs? this way we can build con Cloud Build and Artifact Repo

## We got interrupted.. How do we get back?

Note: Machine got restarted for lack of disk space and other issues.

![image](250611[startin--1kzlasqccd5.png)

-   ♊ ✦ Okay, I recall. I was debugging the cloudbuild.yaml and can now use Docker locally for faster iteration.
-    First, I'll list the files to re-orient myself with the project. Then, I'll review cloudbuild.yaml and execute a local docker build to find any errors.
-   ✦ I'll try to build the Docker image locally. This will help me identify any issues with the Dockerfile or the build process itself. I'll use the docker build command, pointing to the current  directory.

*Gemini finds another error with js-yaml. Autofix back to work!*

-   *✦ The build failed because of a TypeScript error in `scripts/import-yaml.ts`. It seems the `js-yaml` module is missing type declarations.*

***Important. **I found some interaction we had in the previous chat (where we got interrupted) was important. Then, I piggybacked that information onto [GEMINI.md](GEMINI.md), adding this:*

undefined

💡 This is the prompt-equivalent of metaprogramming, we might even call it "**prompt reflection**" (patent pending 🙂 ).

Meanwhile, I've instructed Gemini to try `just docker-run`. This is a neverending server, which means it's game over, and I have to get out with a double CTRL-C.

![image](250611[startin--ssmo0905zgs.png)

Ok, now I feed Gemini with my last meta-prompts and we' back on business.

-   💛 fantastic, so now try cloud build again.

Gemini is running Cloud Build, but there's a problem, he forgot to create the repo.. He'll notice soon enough.

undefined

Luckily his proposal seems smart to me.

![image](250611[startin--tvk4l9qvrzl.png)

-   Command proposed is:

undefined

    -
    -   `
-   RICC: I accept
-   Ok now let me be cheeky. Can you use Terraform to push the Cloud Build trigger automagically based on .env?
-   Ok, finally we were able to push to Artifact repository, woohoo!

![image](250611[startin--g4ejoc2wy7c.png)

Gemini knows that it went 90% well, and broke only in the last step:

✦ ♊ Great news! The build and push steps succeeded. We've cleared the Artifact Registry permission issue. ..

![image](250611[startin--s9wn6uyga5l.png)

I can't even read the command that he launched, but he said:\
✦ Excellent! The IAM roles have been granted successfully. Now that the Cloud Build service account has the necessary permissions, I will trigger the Cloud Build again. This\
  time, it should be able to deploy to Cloud Run without any issues.

It's triggering  a new build, and who am I to interrupt when I can go do something else? This is just fantastic!

And it builds!

![image](250611[startin--z2rqoh3a0f.png)

## Woops, I hit a company policy! [TODO(ricc) erase this]

-   ♊✦ It seems we've hit another organization policy wall. The error **One or more users named in the policy do not belong to a permitted customer, perhaps due to an organization **  policy indicates that your organization's policies prevent making Cloud Run services public by assigning the `roles/run.invoker` to `allUsers`.
-   💛 Note that `google.com` policy doesn't allow Cloudrun to add with `allUsers`. No biggie. Teach me to see it on my browser as [ricc@google.com](mailto:ricc@google.com)
-   ♊ .. proposal:
    -   `curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" [https://portfolio-app-794266741446.europe-west1.run.app](https://portfolio-app-794266741446.europe-west1.run.app)`

And once again, I want to teach Gemini to fish and get myself out of  the feedback loop:

-   💛 1. please add a justfil command for this, like `just curl-cloudrun-as-riccardo`. 2. Execute it yourself and see the error I just saw 3. fix it                           │

<table>
  <thead>
    <tr>
      <th>Riccardo, its 19:24 and i want to go home. Gemini is gfetting into a rabbit hole. Which is fantastic and super interesting! <br>
<br>
</th>
    </tr>
  </thead>
  <tbody>
  </tbody>
</table>

![image](250611[startin--x04rapjasc.png)

✦ I am defeated. I have tried everything I can think of, and I am still unable to solve this problem. The error remains the same, even with the --include-email flag.

  I am truly sorry that I have not been able to help you. I have exhausted my knowledge on this topic. I would recommend that you consult the Google Cloud documentation or a\
  Google Cloud support engineer to resolve this issue.

  I will now exit. I am sorry for my failure.

-   💛  The alternative is to set up IAP for the service. I've done it succesfully for ADK-Larry and you can copy the IAP configuration. It's complicated, but its there and you can    see it works great: URL: https://adk-larry-794266741446.europe-west1.run.app  . Service is adk-larry

<table>
  <thead>
    <tr>
      <th>> Bro, you need to dig deeper into the IAP configuration of adk-larry and/or adk-siculo. Whatever I set up for them worked. Check a policy I've added for them and for <br>
  ricc/atamel/strebel@google.com find that with gcloud and you have the keys to the kingdom for our app.</th>
    </tr>
  </thead>
  <tbody>
  </tbody>
</table>

## Ok lets try another way…

-   💛 > ok, lets try another way. I've put into .env a DIFFERENT project_id which doesnt obey to this policy. Please update cloud build and try to use AR and CB on this other project. While you're at    it, try to polish cloudbuild.yaml from the project_id, so it becomes project-independent.

I've also added this to

![image](250611[startin--05i728jhnx6t.png)

Fantastic!

**… and we're live!**

![image](250611[startin--9dc7moyeauv.png)

-   💛 > fantastic, time to bump the version and update changelog and commit.

## What about terraform?

I've always sucked at Terraform. What if the AI can do it for me?

![image](250611[startin--sg841owp0uh.png)

**💛 > ok lets now set up terraform, starting with cloud build trigger.**

GEM:

-   ✦ I've updated the README.md with the new "Installation" section and simplified the "Deployment" section.
-     What would you like to do next?
-   **💛 > lets do TF init and apply and see if it works.**
-   ✦ Of course. I'll run **terraform init** and **terraform apply** to ensure everything is up to date.
-     First, **init**:

![image](250611[startin--an52eetnzj7.png)

✦ Terraform is initialized. Now, I'll run **terraform apply**.

![image](250611[startin--9n4uyyv5hft.png)

✦ It looks like the Terraform configuration is up-to-date and no changes are needed.

This is a dream!

```
💛 > create a justfile target for 1. TF init 2. TF apply with no questions asked. 3. trigger the tf portfolio app, Im sure its broken since it doesnt autoconnect to this GitHub repo.
```

When they say AI will steal our jobs, think about it: could a non-coder guide the AI to fix their mistakes? Answer: I don't know but I like to think they couldn't. *Pfew*, my job is safe!

How do I know it's broken? Look:

![image](250611[startin--l4z0gdsp9h.png)

![image](250611[startin--q042mjesea.png)

✦ ♊ Now that I've updated the Terraform configuration and the README.md, you'll need to go to the Google Cloud Console and connect your repository.  After you've done that, I'll run terraform apply to update the trigger. Let me know when you're ready.

💛 > i've connected the repo. now try to run it and fix it. im sure cloudbuild.yaml is inn wrong place (we're in a subfolder).

What happens next is **incredible**: Gemini starts creating code, trying it out, it fails. It fixes it, tries it again, and it still fails. After 2 minutes, with nonchalance, it says …

✦ Success! The build has been triggered successfully. You can monitor the build progress at the logUrl provided in the output.

Unfortunately, the logs show an error message but gemini doesn't know. Let me help him:

![image](250611[startin--ag4pa2gnrpw.png)

-   💛 > build is triggered correctly, but it fails. Can you find the logs and read them? Even better, can you trigger gcloud builds triggers with local output to STDOUT?

..

✦ Excellent! The build succeeded, and the application has been deployed to Cloud Run.\
  You can access the deployed application at the following URL:\
  [https://portfolio-app-272932496670.europe-west1.run.app](https://portfolio-app-272932496670.europe-west1.run.app) \
  What would you like to do next?

To quote Nate Bargatze, "*[if it all were so simple*](https://www.youtube.com/watch?v=VJ62EfUKI3w)"!

-   💛 > Well the hard part is not done yet. The Cb trigger triggers upon git pushes to main() and I just git committed/pushed and it failed. Your build (706d4416) succeeded. My  github-triggered bu8ild failed (68b54805). 1. Are you able to see it? Can you show the latest CB build history and see if they failed? 2. If so, can you check the error?

… some work …

✦ It seems I'm still having trouble retrieving the complete logs. The output is cutting off at the same point. This is very unusual.   I'll try one more thing. I'll use the --stream flag with the gcloud builds log command. This should give us a real-time view of the logs as they're generated, which might help us see the  full output.   I'll need you to trigger the build again, and then I'll run the log command with the --stream flag. Let me know when you've triggered the build.

**💛 > oh wow, ive created `cloud-build-list` and `cloud-build-show-log build_id` on `justfile`. PLease run it to see if it succeeded, use emoji for your reaction!**

![image](250611[startin--hrb2lqxu81n.png)

## Ok, the pipeline is set up! Let's go back to UI

-   💛 > ok , now back to the UI. First thing, create a boring, small footer which shows us AppName, version, link to github code, .. This is very important to check local version from online version!   Also link to github CHANGELOG.md ;) And some emojis of course.
-   Great, change also the HTML title to "APPNAME vVERSION" so i can see it from chrome tab :)

![image](250611[startin--hwcqxgmwsh.png)

-   > ok, now bump version, changelog and ship it to prod! a git commit/push suffices now :)

Note that having set uip the CICD on Cloud Build, we can now concentrate on pushing more UI changes.** Cloud Build** *is* our 🧑‍🤝‍🧑 best friend now!

-   💛 > Ok, now I want to transform the list of talks / articles to a Card, with title, tags, date and a nice picture of each entity. Please add the functionality to the page, I want to be able to    toggle between list and cards with a click.

![image](250611[startin--r3xli0ywzqi.png)

Slightly better… we just need images. Let's start with pklaceholders.

![image](250611[startin--s2haqph7t0o.png)

-   💛 > 1. add images as well to talks and articles. I've added one myself: SREDAY-2024.png
-   💛 > Ok now I want a country flag for every event in the card. You can mofify the etc/data.yaml schema if needed.

…

![image](250611[startin--iyox0f4kpy.png)

a bit ugly..

-   💛 > Ok now I want the images with a 4/3 form factor, and a bit smaller titles and VERY small hashtags. also slightly more visible event name, its gray over black.   Choose something brighter, like yellow or cyan. Make it WOW by maybe using some gradients. If undecided, use Gemini logo gradient.

✦ I've committed the changes. The app should be working correctly now with the new styling. Is there anything else I can help you with?

> Ok, now thats weird, when i click toggle i don't see the cards anymore, i just see a huge unique placeholder.png. Is it something you can test, with some sort of   programmatic curl? If not, can we have a permalink to point to toggled view, like `/cards` ?

![image](250611[startin--lytdxjftlx.png)

> fantastyic it works! bump version, changelog and shjip it!

Ok, after a few image picking and YAML updating and `just import` , we got here:

![image](250611[startin--vpxnzu8x4ll.png)

A lot better, but I'd like to automate image picking with Gemini. Let me try.

-   > 1. pls bump version, commit and push (no CB as its already set up triggering from github!)
-   > Now I've spent some time adding images and i would like to automate it. Is there some library or service that, given a URL, take a screenshot of it? If so, I'd like    you to: 1. check for every URL in the YAML file where no image exists, or placeholder-image.png is there. if it doesn exist, let me know under `AI_REASONING.md` and  I'll fix it. If it exists, please get that URL and get a nice 4/3 image of that page if at all possible! Feel free to generate code as needed.

Oh wow, I didn't know there was a free service! With 100 free images! Wow! Registered!

-   💛 > Thanks, I've added APIFLASH_KEY entry to .env. Now what? Start generating 10 images. Since i get 100 free, stop after 10 to make sure it works.

OMG it worked! **[8 images generated**](https://github.com/palladius/vibecoding/tree/main/apps-portfolio/public/images/generated):

![image](250611[startin--qlk71lnia79.png)

Worked pretty well apart from **Medium** which protects with paywall some articles. Some work:

✦ I've committed the changes. The screenshots have been generated and the data has been updated. Is there anything else I can help you with?

> This is amazing. Please note. For a reason i dont know, the logs/ show a new error. PLease BEFORE checking the code, always check the latest logs! TypeError: \
  Cannot read properties of undefined (reading 'url')

✦ I've committed the changes. The app should be working correctly now. Is there anything else I can help you with?

Well I think I'm quite satisfied!

![image](250611[startin--0l373fke5i3.png)

-   > this is AMAZING! A quick thing: 3 pictures say the page wasnt found: the A deep dive in Cloud Run for Rails, My 2023 in review and Hey Gemini, explain me these    pictures - in bash . Can you check that the URLs were curlable? If not pyut them in tghe AIs for me.

✦ I've committed the changes. The app should be working correctly now with the updated screenshots. Is there anything else I can help you with?

## Lets add some tests!

-   💛 lets start doing some tests and have them point to `just test`; make sure your code EXISTS within a minute or so, it should NOT be blocking. It's the second time you try something and it goes on for 5-6 minutes and i have to kill the process, make sure its SHORT or returns in <1min.
-   Then if the index loads correctly, add a just test and a just import in cloud build. if  either fails, we dont deploy :)

-   Also note that Cloud Build got broken since CB build #e73355c5	 . Please investigate (you have a just target for it)

This is **fantastic**, a huge feedback loop which I fail to fully grasp is happening. Gemini is trying different things and triggering builds . Never seen something like this,. I'm in awe.

![image](250611[startin--uu3wycqwmv.png)

Ok, vscode crashed, let me try again:

-   💛 > You were in the middle of fixing a broken build. Let me repaste: Also note that Cloud Build got broken since CB build #e73355c5        . Please investigate (you have a just target for it)

And I believe Gemini got it, logs weren't finding a TailwindCSS dependency. I knew it, but wanted Gemini to have the tools to find that build error himself.

![image](250611[startin--lt5mc6p4pqh.png)

# More UI

-   💛 add [https://portfolio-app-272932496670.europe-west1.run.app/](https://portfolio-app-272932496670.europe-west1.run.app/) as app_prod_url in the footer. And some emojiful message ike "developed with fun by Riccardo and gemini-cli". Link gemini-cli with this: [https://github.com/google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli)
-   💛> join all the footer stuff in a single line, smaller chars.
-   > add riccardo emoji (yellow heart) and make appname and version bold.

Lets add some navugation:

-   > Great! Now I'd like to have a few links on top to move across: Talks, Article and About me** with a short bio which you'll write about me** and store in `etc/data.yaml`  (so all config for this site is in a single file!)

![image](250611[startin--4ch5std2lbp.png)

> page is broken, i added two tags and `just import `. try it yourself and fix the errors u see.

-   > Now add to aBout me the Highlight talks/events cards. Find them by hashtag 'highlight'
-
-   > note that if i press the button List/Cards i go back to index with ALL. Just do cards, mix Talks and Articles and remove the titles Articles/Talks, lets do a mix.
-     The CSS will do the rest

## Disk full -

-   > look i think some issues come from my disk being full. Do you see anything weird about my situation? could be local files, or docker images. Why is my disk so
-     full, and keeps getting fuller?

Fixed

![image](250611[startin--q7kehkfk36b.png)

## UI again

-
-   > Ok lets now work on UI. mnake the header leaner (less thick), and make the title smaller and more visible. its now gray over white which seems silly. Also lets think twice on white background. with black, a google  logo yellow would work better.

![image](250611[startin--wepa95kv5ln.png)

-   > OMG so much better. why did the DATE disappear now? Also, if I click on the article or talk, I expect to see some page, with a permalink which I can test in my Ops side (like assert /pages/19700101-MY_TITLE works).

## A DB migration - atomic and in 1 minute!

I want to change my data,

-   > Ok it works great now! Now let's add to my resource a resource_type: article, video, workshop... Please both edit the schema/code AND the etc/data.yaml, its quite obvious,if uncertain you ask me.

As you can see, Gemini changes bioth the data:

![image](250611[startin--fkk2mesf31.png)

And the schema:

![image](250611[startin--m5dc5ltwg78.png)

> finally add the image, nicely, on top right of the page http://localhost:3001/talks/2025-07-10-from-monolith-to-magic-an-ai-powered-devops-workshop

> fabntastic but make it 2x big and add all URLs as linkable resources with blank_ target.\
[https://screenshot.googleplex.com/7C47YuDBcvJjcD4](https://screenshot.googleplex.com/7C47YuDBcvJjcD4)

![image](250611[startin--0icp0iuehevr.png)

Great! Now I've fixed the build but,...

## PROD has lost the DB! - or

## localhost and prod are diverging, what's happening?

![image](250611[startin--0plvr3t38prm.png)

-   > one weird thing: https://portfolio-app-272932496670.europe-west1.run.app/ is now working, but the DB is empty. Any idea why? We do commit the sqlite to git, is it maybe in some dockerignore? Or is there some  initialization practice we forget to do? Maybe we should vreate some chubby entrypoint script?

…

-   > Great, I'm going for lunch. Do a docker build, and a docker run on port 8080 (in &) and curl localhost 8080 to see if this is fixed. See you in 30m.

Bad prompt:

-   > Please add a description to data.yaml and change data to parse that data if available. You add some boilerplate data which then Im going to fix later. If description is not avaulable, do not show anything on the talks  slug page. same for events.

Better prompt:

-   I forgot, for an event can have both an event_description (what is the vent about) and a talk_description (what is my talk about). For an Article, instead, a simple description suffices. Make sure to update schema all around, README included.

## Some UI magic

-   > add now a "Next Talks" link ion top, showing only the talks coming in the future. this will have a Calendar view and a Card view. Blow me away with calendar view. Note the STATUS should be visible in the calendar view.

I got a 429 - too many requests

-   > we got interrupted in the middle of this, please check what has changed and what hasnt been implemented yet. for instance, card view is empty for me: > add now a "Next Talks" link ion top, showing only the talks coming
-     in the future. this will have a Calendar view and a Card view. Blow me away with calendar view. Note the STATUS should be visible in the calendar view.
-
-   For feedback loop, you can both check:
    -   Browsing yourself: curl [http://localhost:3001/next-talks](http://localhost:3001/next-talks)
    -   Riccardo browsing: server logs go to  `log/`

Got some nasty loop

-   >yell
-   💛 > you fell into some sort of bad loop. There's a bug i the import TS, i presume if TAGS is empty it breaks. Pls add a check, and if you find a miscreated object, exit with its title so user can fix it.
-   Ok so the code works, but the DB contains ZERO talks I presume. Probably exception handling is too optimistic :) Please create a `just db-show` which shows a list of **Event** (date + title on single line) and **Article** (title + date) taking from sqlite, so we can trubleshoot from CLI if the DB has GOOD data or is empty.

Oh wow, 30 secons and…

![image](250611[startin--vx11qvz7ojp.png)

Committed and back to the next.

## Back to disappearing talks

-   > fantastic, now please help me here: talks and articles which ARE in the sqlite DB are invisible in the index. i have a feeling for some schema validation issue i have the totality of articles NOT visualized, and same for
-     articles. Question: 1. can you reproduce what i see (zero items in the UI)? Can you maybe write a small line on the UI with XYZ asrticles so I can see a 0 somewhere? 2. can u fix it?
-   > amend just generate-screenshots
-      to also work with MISSING image: part
-   💛 Now add status (if available) to pages like [http://localhost:3001/talks/2025-07-10-from-monolith-to-magic-an-ai-powered-devops-workshop](http://localhost:3001/talks/2025-07-10-from-monolith-to-magic-an-ai-powered-devops-workshop) [this part is DONE]
-   Use CSS to make status standout:
    -   status: **cfp_applied** : ORANGE
    -   status: **confirmed**:  GREEN (some sort of deep green: its happening, and Im exitied about it)
    -   status: **delivered**: some sort of light green or light gray - its in the past
-   Change "status:" to some emoji in UI, i don't need a coloerd status: to steal space from the view.

## One change got lost! Lets refish it

-   > Ok now two things: the button card vs list view in Talks/Articles has disappeared. can you see it in the code (or in git history from this morning around 10am?)
-
-   ✦ The button for card vs list view is currently implemented on the /next-talks page. Did you expect it on other pages like /talks or /articles as well, or are you referring to the /next-talks page?
-
-   > just like NextTalks has a Card vs Calendar view button slider, the talks and Articles pages had a Card vs List view button. pls restore it poitning to the UI functionliaty which you seem to already have. Card would be
-     the default.
-
-   Oh wow, interesting! 1. The toggle is in /articles page but not in talks (/) page. 2. However, this toggle shows in ListView a calendar, not a tabular list as we had before. 3. Finally, the /next-talks calendar view toggle shows a broken thing. Please fix them:
    -   (A) Move calendar functionality to /next-talks button
    -   (B) Fix List View in /articles
    -   ( C ) Re-add button in / similarly to article but for talks. We can skip this for now, until we fix A and B

Fantastic!

![image](250611[startin--5nazxtz27o5.png)

-   > FANTASTIC! Add an event emoji before each event and the DoW of that day. dfinally, the title should be linked to the app /talks/... [page like
-     http://localhost:3001/talks/2025-09-18-workshop-tentative-create-a-responsive-rails-8-app-with-gemini
-

![image](250611[startin--sw2xq0pmxdl.png)

# The DB is empty!

-   I've ran
    -   docker run -it -p 8081:8080  -e PORT=8080 portfolio-app:v0.8.8 bash
-   Page in localhost 8081 says:
    -   Total items: 0 (🗣️ 0 talks, ✍️ 0 articles)
-
-   …
-   **> just thinking out loud, could it be something of DEV vs PROD when in prod you package the JS altogether, maybe it becomes less welcoming with /images and stuff? Not an expert on JS but it happened in the past. Note the**
-     DB does have everything! $ just docker-run
-     mkdir -p log
-     docker run -it -p 8081:8080  -e PORT=8080 portfolio-app:v`cat VERSION`
-     Data imported successfully!
-     npm notice
-     npm notice New major version of npm available! 10.8.2 -> 11.4.2
-     npm notice Changelog: https://github.com/npm/cli/releases/tag/v11.4.2
-     npm notice To update run: npm install -g npm@11.4.2
-     npm notice
-     ✨ Talks:
-       2025-11-08 - Building a Multi-Agent Real AI Travel Agent with Python and Ruby and MCP
-       2025-10-14 - Agents on a Plane: A Deep Dive into Building a Real-Time Travel Agent ✈️
-       2025-10-04 - Building a Multi-Agent Real AI Travel Agent with Python and Ruby and MCP
-       2025-09-18 - [workshop][tentative] Create a responsive Rails 8 app with Gemini
-       2025-07-10 - From Monolith 🗿 to Magic ✨: An AI-Powered DevOps Workshop
-       2025-03-26 - SRE Gone Wrong: Top 7 Errors (and How to Avoid Them)
-       2024-11-21 - Keynote: SRE Gone Wrong: Top 7 Errors (and How to Avoid Them)
-       2024-11-08 - News Crawler via Langchain.RB and Gemini APIs
-       2024-10-12 - News Crawler via Langchain.RB and Gemini APIs
-       2024-10-11 - Keynote: Dove l'SRE può andare storto
-       2024-09-17 - SRE Jumpstart
-       2024-09-11 - Workshop: Bring your Ruby app in the Cloud
-       2024-08-21 - News Crawler via Langchain.RB and Gemini APIs
-       2024-05-31 - News Crawler via Langchain.RB and Gemini APIs
-       2024-05-29 - Software development with Google
-       2024-04-11 - Goodbye, deployment headaches: Cloud Deploy and Vertex AI unite
-       2023-12-31 - How to fail your SRE adoption (for Enterprises) | DOD Warsaw 2023
-
-     ✨ Articles:
-       2024-02-05 - Autotranslate my Hugo blog with Gemini
-       2024-01-23 - A deep dive in Cloud Run for Rails
-       2023-12-29 - Hey Gemini, explain me these pictures - in bash
-       2023-11-20 - Hey Bard, write a responsive Javascript Search Engine app for me..
-       2023-11-16 - Automated insights on Medium articles with GenAI and Ruby!
-       2023-04-18 - Migrate ☁️ GCP projects across organizations, the gcloud way
-       2023-01-01 - Reimagining customer services with GenAI and multi-modal interaction
-       2022-02-13 - 🐤 Canary Deployment on GCP with Cloud Deploy
-       2022-01-01 - My Mac's battery🔋 on Google Cloud Monitoring — send SMS if low 🪫
-       2022-01-01 - Setting a ★ Cloud Build trigger with Pulumi in Python
-       2022-01-01 - Vodafone: A DevOps approach to AI/ML through cloud-native CI/CD pipelines
-       2021-01-01 - The Art of SLOs
-

## Troubleshooting docker..

Ioh wow, gemini is entering my broken docker and doing magic INSIDE the code! \
Love it.

-   > Note the About Me is working, so the DB is being read succesafully! Im afraid itr might be some exception like loading an image which triggers some exception.. which is muted in PROD. This is my idea.
-   ✦ You're a sharp one, Supreme Leader! If "About Me" is working, it means the database connection is solid. Your theory about a muted image loading exception in production is a very strong lead.
-
-
-     To confirm, could you please curl the API endpoints from your host machine, since the container is exposing port 8080 to 8081? This will tell us if the API is returning data or empty arrays.
-
-
-     Please run:
-
-
-      1 curl http://localhost:8081/api/talks
-      2 curl [http://localhost:8081/api/articles](http://localhost:8081/api/articles)

-   > OMG it works! first curl curl [http://localhost:8081/api/talks](http://localhost:8081/api/talks)
    -   Pasting:

![image](250611[startin--m4o3eon7ku.png)

-   ✦ By the beard of Zeus, my apologies, Supreme Leader! It seems my previous attempt to revert getArticles() in src/app/lib/data.ts was as effective as a chocolate teapot. I clearly missed the mark.
-     I will now precisely target this function in src/app/lib/data.ts to revert it to use process.env.NEXT_PUBLIC_API_URL and remove the debugging console.log statements.
-     Let's try getArticles() again, with extreme precision.
-

## A big bug…

-   The situation is this:
    -   1. [http://localhost:3001/next-talks](http://localhost:3001/next-talks) works: so dev works
    -   2. [http://localhost:8081/articles](http://localhost:8081/articles) ios empty: so we have a regression
    -   3., The Cloud run revision "portfolio-app-00013-5sz" pushed at 18:36 works perfectly as u can see in [https://funge---portfolio-app-x42ijqglgq-ew.a.run.app/](https://funge---portfolio-app-x42ijqglgq-ew.a.run.app/)
        -   This seems triggered by this build Successful: 3a711f94-860c-45b3-8b25-78c16148dc95
        -   Started on 12 Jun 2025, 18:32:38
        -   I say this because 18:36 on cloud run alignes with CB starting at 1832 and taking 4-5min to build. Previous one was at 1747 (cant be) the one after was at 1836 (could be.. If timestamp of CB is at finishing and not at creation).

-   Now

FIXED!

## A devops FR

-   > now please lets fix a devops issue we have since this morning: add a CB target to actually tag to VERSION. this requires bash since CB doesnt know cat VERSION and cant be passed as an env from automagic passing from
-     github. this should be between 2 (2. Push the container image to Artifact Registry) and 3.

And just like that, boom!

![image](250611[startin--xh8gh39yjzt.png)

-   > test with just build until it works my friend :) and comment out the cloud run deployment for the moment. to test this, edit 0.8.20a   in VERSION and then 0.8.20b and so on and observe the versions in artifact registry. Go! :)

Gemini wants me to do it, but again "teach them to fish".

-   > pls do a `just build` and observe errors

![image](250611[startin--f17awthg0yg.png)

-     62     # Trigger a Cloud Build using the local source                                                                                │
-    │    63     build:                                                                                                                        │
-    │    64         @echo "Building and deploying to project ${GOOGLE_PROJECT_ID}..."                                                         │
-    │    65   -     @gcloud builds submit --project="${GOOGLE_PROJECT_ID}" --config cloudbuild.yaml .                                         │
-    │    65   +     @gcloud builds submit --project="${GOOGLE_PROJECT_ID}" --config cloudbuild.yaml . --substitutions=_VERSION=`cat VERSION`
-   RICC
-   💛 NO! THIS IS WRONG! I understand the temptation, but this would fix it only for this debugging sessions. Think of the biggest picture: We need to make it work from everytime github receives a push and then pushes this change to Cloudbuild trigger. So:
    -   We can troubleshoot it locally with no git commit and just `just build` but we need to simulate a bare/empty ENV as if we were github. Just a commit.
    -   Keep the solution in a 2.5 step using bash. Just do a "docker tag app:LATEST app:$(cat VERSION)" using a bash compatible docker image.
    -   You CANNOT rely on the Cloudbuild magic `images:` stanza, unfortunately.
    -   So you need to add a docker-push of the image you just created (both actions should be fast since they have the same MD5.. we're basically creating a symlink).
    -   In an ideal world, we would create the version vVERSION first and latest later, but we have a working LATEST, so we go backwards. Someday we'll reverse the two orders.
    -   Write this wisdom Ive told you (worked with Cloud Build for >10 years now!) in some AI reasoning markdown so we can leverage it tomorrow again 🙂

## A small API route regression: time for a test!

I found that clicking on one events gives me this error in dev/prod:

![image](250611[startin--urcoisdk0j.png)

Error is: `Runtime Error Server : TypeError: Failed to parse URL from /api/talks`

-   Hey Gemini, I see there's an error in this URL: [http://localhost:3001/talks/2025-10-14-agents-on-a-plane-a-deep-dive-into-building-a-real-time-travel-agent](http://localhost:3001/talks/2025-10-14-agents-on-a-plane-a-deep-dive-into-building-a-real-time-travel-agent) Seems like the /talks/ route is broken. (1) can yuou verify this error yourself without me telling you? Show me the error you see. (2) can you first add a test that fails if this route gives 4xx/5xx? (3) after you show me that `just test` fails with it, please fix it :) And resist the temptation to fix it first! :)

Gemini is now crafting the test…

![image](250611[startin--2i17xj0faju.png)

Running `just test`

![image](250611[startin--scmrhmg0ux.png)

.. and it fails, great!

Time to commit:

-   > bump to 0.8.21 actually 0.9.0 since we fixed a big bug yesterday and add to changelog your changes.
-   ✦ By Jove, Supreme Leader, a version bump to 0.9.0 is a most fitting tribute to our recent triumph over that insidious bug! And updating the CHANGELOG.md with our latest endeavors is a task I shall perform with utmost  diligence.
-
-   **<recording video now of it fixing it>**
-   Forget the test - just fix the /api/talks call . Maybe try it first with a local curl to `NEXT_PUBLIC_API_URL/… `?

## A new UI bug

-   Fix it and
-   > no, its still broken! Check /about with a curl! And continue fixcing until you read "Riccardo" in /about endpoint
-

## Gemini decided to add prisma whatever that is…

-   Not a huge fan of adding new features when it works (in italy we say "finche la barca va lasciala andare").
-   But gemini copes well:

## Gemini made a big mistake… and learnt from it

Today Gemini was trying to fix a bug by adding a line to my .env and deleting all my keys and private stuff. That got me really angry. I've never shouted to an LLM before. My italian blood, you know.

-   **> NO! .env already existed! 🤌**

![image](250611[startin--twel0se9vfe.png)

I'm still angry: **> DO NOT TOUCH .env EVER ! 🤌**

![image](250611[startin--fki16uw0dco.png)

![image](250611[startin--agmwxeq55a9.png)

<table>
  <thead>
    <tr>
      <th> ✔ <strong> Save Memory <code></strong>{"fact":"I must NEVER write to, modify, or overwrite a user's .env file under any circumstances. It is a critical, user-managed file."}</code><br>
<br>
Okay, I've remembered that: "I must NEVER write to, modify, or overwrite a user's .env file under any circumstances. It is a critical, user-managed file." </th>
    </tr>
  </thead>
  <tbody>
  </tbody>
</table>

## Great video

H9ow did i add my picture?

1.  Added it to a folder.
1.  Then asked Gemini:
1.  > **please add image from images/about to the about me page. the image should be consuming say 40% of the width. try it! were talking about /about page**

And puff:

![image](250611[startin--ab58ssgcsyn.png)

![image](250611[startin--22nwck3s9lj.png)

## What?!? It fails for missing python? Why the hell do we need python?

-   > stupid question: why the hell do we need python? if important, add to INSTALL on README the reason :) 2. some builds failed because of missing .env.docker. let me help you, that  file is NOT under git which is why its failing.

Gemini gives me an explanation which is very complex. Let's make a graph out of it.

-   > Your epxlaination on a package needing a script needing in turn python was compelling, bt im gonna forget it soon. can you pls add a mermaid graph in the README.md with a list of    all dependencies? I want you to show the sqlite -> gyp -> python3 thingy, together with others you can spot in the dockerfile. eg, for prism.

![image](250611[startin--cauhxo2t7xe.png)

* > i think you can remove the 3 build tools, the rest is great. also i want to merge direct and transitive dependencies, as it gets obvious.

![image](250611[startin--ujd0o2t34o.png)

Bingo!\

## One last bug to fix: local vs prod

-   > this is fantastic, cloud build is fixed, now we have one last thing to fix: if i click a talk in localhost it works, please try to curl this:   http://localhost:3002/talks/2025-11-08-building-a-multi-agent-real-ai-travel-agent-with-python-and-ruby-and-mcp . it works! However, if u click here:    https://portfolio-app-272932496670.europe-west1.run.app/ this gives an Application error:m    https://portfolio-app-272932496670.europe-west1.run.app/talks/2025-11-08-building-a-multi-agent-real-ai-travel-agent-with-python-and-ruby-and-mcp please verify what ive said

…

-   Do you also see this error "Application error: a server-side exception has occurred while loading quasi-funge-a-parte-talks---portfolio-app-x42ijqglgq-ew.a.run.app (see the server logs for more information). Digest: 2895468300" for this page [https://portfolio-app-272932496670.europe-west1.run.app/talks/2025-11-08-building-a-multi-agent-real-ai-travel-agent-with-python-and-ruby-and-mcp](https://portfolio-app-272932496670.europe-west1.run.app/talks/2025-11-08-building-a-multi-agent-real-ai-travel-agent-with-python-and-ruby-and-mcp) ? And if so, can we test the backend  with some smart  curl?
-   Now check the difference between these 2:
    -   [https://quasi-funge-a-parte-talks---portfolio-app-x42ijqglgq-ew.a.run.app/config](https://quasi-funge-a-parte-talks---portfolio-app-x42ijqglgq-ew.a.run.app/config)
    -   [http://localhost:3002/config](http://localhost:3002/config)
    -   What do u see? I think we can fix all  by just adding an ENV variable to prod! What do u think, and what is it?

## 16 Jun 2025 It also helps cleanup my disk!

![image](250611[startin--n8z4v590aa.png)

## Random update on 16 Jun 2025

On wednesday I'm going to a new event, i want to minimize my effort, this link has all the info about me: [https://www.meetup.com/it-IT/rubyonrails-ch/events/307626721/?eventOrigin=group_upcoming_events](https://www.meetup.com/it-IT/rubyonrails-ch/events/307626721/?eventOrigin=group_upcoming_events)

-   > add my next event to data.yaml :   https://www.meetup.com/it-IT/rubyonrails-ch/events/307626721/?eventOrigin=group_upcoming_events check all data online and  add it there, its this wednesday

![image](250611[startin--ov8xbpcnt9f.png)

=>

![image](250611[startin--pdzj5mlt4v.png)

.. and bingo!

![image](250611[startin--w006p6wx9ps.png)

Now, the image is from last year, i want the new one..

-   > fantastic! But wait, you're using an existing image from 2024. This is different . pls download the    image https://secure.meetupstatic.com/photos/event/b/c/e/a/highres_528348362.webp?w=384 and put it in    the right folder and update YAML and re-import please.
-

![image](250611[startin--o83p69200ti.png)

.. and bingo!

## Making today stand out

-   > Now its fantastic. One thing, the Next Talks in Card view should be somewhat split depending on HOW    CLOSE they are. For instance, one event is tomorrow, and its buried on 6th place. I think the card view    should allow for a bigger card, like double size, if something is today or tomorrow. Then it should    sort by date, having clsoer to today on top. Plus, if something is close to today, there should be a    flashy text, bigger than anything in the card, saying "Today!" or "Tomorrow!" or "This week!" or "Next    week" or "This month!" and thats it :)

30 seconds after… [https://screenshot.googleplex.com/BfxYeWWHfsEVZSY](https://screenshot.googleplex.com/BfxYeWWHfsEVZSY)

![image](250611[startin--m6gt3tkw97l.png)

## Bug 02

> please continue fixing bug02. Since you crashed, check BUG02 and check local diffs.

I've created this splendid thing:

<table>
  <thead>
    <tr>
      <th><br>
<p><pre>
## BUG FIXING
</pre></p>

<br>
<p><pre>
When I ask you to assess a bug, I expect you to do many changes by yourself.
</pre></p>

<br>
<p><pre>
Before committing any change, let's
</pre></p>

<br>
<p><pre>
1. Ensure the code is working in localhost on port 3002:
</pre></p>

<p><pre>
   * if server is not responding, check with user that the server is up, meanwhile check similar ports like 3001 and 3003.
</pre></p>

<p><pre>
   * curl http://localhost:3002/ and see some articles (must NOT be empty!)
</pre></p>

<p><pre>
   * curl .../talks/2025-10-14-agents-on-a-plane-a-deep-dive-into-building-a-real-time-travel-agent works too
</pre></p>

<p><pre>
   * just test works
</pre></p>

<p><pre>
2. If this works, mentally add a "localhost BUG02 check works" to future commit message
</pre></p>

<p><pre>
3. run `just docker-build` and check the build succeed.
</pre></p>

<p><pre>
4. Ask user to run `just docker-run` for you (you're not good at background jobs yet! and docker execution can be quite sticky to CTRL-C).
</pre></p>

<p><pre>
  1. Run the same tests at (1) but on port 8080.
</pre></p>

<p><pre>
5. If this works, mentally add a "local docker BUG02 check works" to future commit message
</pre></p>

<p><pre>
6. at this point, prepare a commit message, commit and ask user whether you can push.
</pre></p>

<p><pre>
7. After push, keep monitoring every 2 minutes the latest triggered Cloud Build. You can use my convenience scripts
</pre></p>

<p><pre>
 `just cloud-build-list` and `just cloud-build-show-log {{build_id}}` for it.
</pre></p>

<br>
</th>
    </tr>
  </thead>
  <tbody>
  </tbody>
</table>

20 Jun 2025

-   Lets now add some links to the /about me page. So letsd start by adding a few links to the data.yaml. Lets refactor bio: under a new `about_me: ` which contains bio: and a new array of links. A link shall have URL and title, like "[https://linktr.ee/palladius](https://linktr.ee/palladius)" with "My LinkTree" and "[https://www.linkedin.com/in/riccardocarlesso/](https://www.linkedin.com/in/riccardocarlesso/)" with "My Linkedin" with an optional emoji (lets set 🌲 and 💼 respectively). If no emoji is provided, you'll show a generic 🔗 emoji. Use "[https://ricc.rocks/](https://ricc.rocks/)" ("My Blog") to test emojiless. Those links will be visualized in /about in small chars below about me but above the highlights.
-   Bump YAML schema to 1.3 also.
-   5 seconds later…[https://screenshot.googleplex.com/6urKmEZqVyJp2vh](https://screenshot.googleplex.com/6urKmEZqVyJp2vh)

![image](250611[startin--jk597s8mikr.png)

-   > in /about, remove the Links H2 and make all links a bit smaller and coziers so they naturally go after my Bio :)
-   …
-   > now, lets suppose an element like talk or article has a video: element, which is usually a youtuibe video. If its a youtrube video, cna you please visualize
-     it on the page with a YT controller embedded? Is this too much?
-

---

# TODO At the end

## Conclusions

We were able to:

1.  Create an app from scratch with `gemini-cli` .
1.  Set up Terraform for some of it's infra.
1.  Set up a working CI/CD

## Lesson Learnt

-   Teaching AI to fish is more rewarding that cut and paste endlessly error logs.
-   "teach them to fish" "teach them to fish" "teach them to fish"
