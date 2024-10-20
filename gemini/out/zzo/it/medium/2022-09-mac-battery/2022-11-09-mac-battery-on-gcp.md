# translate_with_gemini(file_name: doc/posts/medium/2022-09-mac-battery/2022-11-09-mac-battery-on-gcp.md, extension: zzo, lang: it). MD_content: 3KB. prompt_version=1.0

---
# type: docs
title: 💦♊ [Geminocks] La batteria🔋 del mio Mac su Google Cloud Monitoring — invia un SMS se scarica 🪫
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
tags: [GCP, macbook, SMS, pager, medium, symlink]
images:
- /images/articles/london-airport.jpg
meta_image: featured-sample.jpg # This is for ZZO
#- /images/battery-life-cli.webp
#- /images/london-airport.jpg
# original TODO more from https://medium.com/google-cloud/my-macs-battery-on-google-cloud-monitoring-with-sms-if-its-low-a1ccd70485fe
---

<!-- this works: ![Image Caption](/images/riccardo.jpg "Use Image Title as Caption aeroporto") -->
![Image Caption](/images/articles/london-airport.jpg "[HUGO] Prendendo un treno per City Airport, il mio aeroporto preferito a Londra")


Questo articolo mostra come è possibile inserire facilmente una chiave/valore generica in Google Cloud Monitoring e impostare avvisi su di essa. Lo uso per ricevere avvisi sullo spazio su disco e ora anche sulla batteria scarica!

Stamattina ero a Londra e ho dimenticato il caricabatterie a casa. Con un sacco di tempo ma 🪫 poca batteria, ho pensato: ehi! Ho bisogno di un modo per prevedere quando la mia batteria è scarica! E ho bisogno di farlo in un modo totalmente esagerato!

<!--more-->

La mia batteria era al 42%, il che mi è sembrato un sottile indizio che la mia idea valesse la pena di essere pubblicata su un blog. Cercando su Google, ho trovato un articolo che mi ha dato il suggerimento su come scrivere uno script per la batteria del mio Mac (nota che questo funziona solo per un Macbook).

Codice brutto qui (ehi! Sono in un aeroporto senza caricabatterie, vuoi anche i test unitari?!?)

```ruby
#!/usr/bin/env ruby

# Note1. buridone non è attualmente utilizzato. È per un uso più efficiente per estrapolare tutte le informazioni dalla lettura di un singolo file.
# Note2. Questo NON funziona su M1. L'ho appena corretto nel repository github sakura. Trova il codice 0.2 aggiornato lì.
def processMacCapacity(buridone)
  ret = {}
  ret[:debug] = 'Riempirà numeratore e denominatore finché non lo avrò capito.'
  ret[:capacity_pct] = 142 # chiaramente sbagliato
  # `ioreg -l -w0 | grep AppleRawMaxCapacity`.split
  # => ["|", "|", "\"AppleRawMaxCapacity\"", "=", "4320"]
  ret[:AppleRawMaxCapacity] = `ioreg -l -w0 | grep AppleRawMaxCapacity`.split[4].to_i
  ret[:AppleRawCurrentCapacity] = `ioreg -l -w0 | grep AppleRawCurrentCapacity`.split[4].to_i
  #  => ["\"StateOfCharge\"=41"]
  ret[:StateOfCharge] = `ioreg -l -w0 | grep BatteryData`.split(',').select{|e| e.match /StateOfCharge/ }[0].split('=')[1].to_i
  ret[:AppleDesignCapacity] = `ioreg -l -w0 | grep BatteryData`.split(',').select{|e| e.match /DesignCapacity/ }[0].split('=')[1].to_i

  # valori derivati..
  # questa dovrebbe essere la durata della batteria, immagino?x
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
  puts "1. 🔋 Durata batteria % 🔌🪫: #{capacity_hash[:BatteryCapacityPercent].round(2)}"
  puts "2. 🔋 Stato batteria % 🛟: #{capacity_hash[:battery_health].round(2)}"
end

def main(filename)
  deb "Sono chiamato da #{white filename}"
  init        # Abilita questo per avere capacità di analisi della riga di comando!
  real_program
end

main(__FILE__)
```


Lo so, chiamo lo stesso comando 10 volte e potrei metterlo nella cache. Questo è per la prossima iterazione!

La parte migliore di questo è che non solo ottengo la durata della batteria, ma anche la sua durata, quindi quando ho bisogno di cambiare la batteria. Evviva!

Ecco fatto, proviamolo, lasciate che tolga il cavo in modo che non abbiate un noioso 100%.

![Image Caption](/images/articles/battery-life-cli.webp "Ecco la durata della mia batteria e lo stato della mia batteria")

TODO(ricc): finire


[Vedi articolo su Medium](https://medium.com/google-cloud/my-macs-battery-on-google-cloud-monitoring-with-sms-if-its-low-a1ccd70485fe)
