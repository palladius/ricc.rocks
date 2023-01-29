---
# type: docs
title: My Mac’s battery🔋 on Google Cloud Monitoring — send SMS if low 🪫
date: 2022-11-09T11:48:51+01:00
featured: false
draft: false
comment: true
toc: true
reward: true
pinned: false
carousel: false
series:
categories: []
tags: [GCP, macbook, SMS, pager]
images:
- battery-life-cli.webp
- london-airport.jpg
# original TODO more from https://medium.com/google-cloud/my-macs-battery-on-google-cloud-monitoring-with-sms-if-its-low-a1ccd70485fe
---

## TODO image doesnt work..

[london ariport](london-airport.jpg)

This article shows how you can easily inject a generic key/value into Google Cloud Monitoring and set up alerts on it. I use it to alert on disk space, and now also low battery!

This morning I was in London, and I forgot my charger at home. With plenty of time but 🪫 little battery, I thought: hey! I need to have a way to predict when my battery is low! And I need to do it in a totally overkill way!

<!--more-->

My battery was at 42%, which seemed a subtle indication my idea was worth blogging. Googling around, I found an article which gave me the tip on how to script my Mac’s battery (note this only works for a Macbook).

Ugly code here (hey! I’m in an airport with no charger, do you want Unit tests too?!?)

```ruby
#!/usr/bin/env ruby

# Note1. buridone is currently not used. It's for a more efficient use to extrapolate all info from a single file read.
# Note2. This does NOT work on M1. I've just fixed this in the github repo sakura. Find the updated 0.2 code there.
def processMacCapacity(buridone)
  ret = {}
  ret[:debug] = 'Will fill numerator and denominator until I nail it.'
  ret[:capacity_pct] = 142 # clearlly wrong
  # `ioreg -l -w0 | grep AppleRawMaxCapacity`.split
  # => ["|", "|", "\"AppleRawMaxCapacity\"", "=", "4320"]
  ret[:AppleRawMaxCapacity] = `ioreg -l -w0 | grep AppleRawMaxCapacity`.split[4].to_i
  ret[:AppleRawCurrentCapacity] = `ioreg -l -w0 | grep AppleRawCurrentCapacity`.split[4].to_i
  #  => ["\"StateOfCharge\"=41"]
  ret[:StateOfCharge] = `ioreg -l -w0 | grep BatteryData`.split(',').select{|e| e.match /StateOfCharge/ }[0].split('=')[1].to_i
  ret[:AppleDesignCapacity] = `ioreg -l -w0 | grep BatteryData`.split(',').select{|e| e.match /DesignCapacity/ }[0].split('=')[1].to_i

  # derived values..
  # this should be your battery life i guess?x
  ret[:BatteryCapacityPercent] = ret[:AppleRawCurrentCapacity]*100.0/ret[:AppleRawMaxCapacity]
  ret[:battery_health] =  ret[:AppleRawMaxCapacity]*100.0/ret[:AppleDesignCapacity]

  return ret
end

def real_program
  capacity_hash = processMacCapacity(`ioreg -l -w0 | grep Capacity`)
  deb "capacity_hash: '''#{white capacity_hash}'''"
  if $DEBUG
    capacity_hash.each{|k,v|
      puts "[DEB] #{k}:\t#{v}"
  }
  end
  puts "1. 🔋 BatteryLife % 🔌🪫: #{capacity_hash[:BatteryCapacityPercent].round(2)}"
  puts "2. 🔋 BatteryHealth % 🛟: #{capacity_hash[:battery_health].round(2)}"
end

def main(filename)
  deb "I'm called by #{white filename}"
  init        # Enable this to have command line parsing capabilities!
  real_program
end

main(__FILE__)
```



I know, I call the same command 10 times and I could cache it. This is for the next iteration!

The best part of this is, not only I get my battery life, it also gives me my battery durability — so when I need to change battery. Woohoo!

There you go, let’s try it out, let me just remove the cable so you dont get a boring 100%.
