#!/usr/bin/env ruby


require_relative '../lib/importz'
require 'dotenv/load'

DRY_RUN = true
lang = ARGV[0]

raise "[usage] Give me an argument!" if lang.nil?
raise "Wrong language!" unless %w{ it de fr jp }.include? lang

# only works in Carlessian computers heheheh safety by obscurity!
GIT_ROOT = `git rev-parse --show-toplevel`.chomp

def zzo_cleanup(lang:)
  command = "cd #{GIT_ROOT} && echodo echo rm zzo.ricc.rocks/content/#{lang}/posts/gemini/"
  puts("Command to execxute: #{Rainbow(command).white}")

  if DRY_RUN
    puts("DRY_RUN enabled! Not executing: #{command}")
  else
  `#{command}`
  end
end


zzo_cleanup(lang:)
