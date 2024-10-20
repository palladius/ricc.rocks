#!/usr/bin/env ruby

require 'rainbow'
require 'langchain'
require 'net/http'
require 'fileutils'

require_relative '../lib/gemini/translator'
require_relative '../lib/hugo/filesystem_iterator'

# Input folder
input_folder = 'doc/posts'

# Hugo Blog Extensions and languages
#extensions = ['zzo', 'papermod', 'ananke']
extensions = ['zzo']
#languages = ['en', 'it', 'fr']
languages = ['it']

#OVERWRITE_FILES = ENV.fecth('OVERWRITE_FILES', 'false') = > false
OVERWRITE_FILES = ENV.fetch('OVERWRITE_FILES', 'fAlse').downcase == 'true'

puts(Rainbow("OVERWRITE_FILES: #{OVERWRITE_FILES} (#{OVERWRITE_FILES ? 'unsafe' : 'safe'})").send( OVERWRITE_FILES ? :red : :green))

iterate_through(input_folder:, extensions:, languages:, overwrite: OVERWRITE_FILES)
