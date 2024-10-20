#!/usr/bin/env ruby

require 'rainbow'
require 'langchain'
require 'net/http'
require 'fileutils'
require 'dotenv'

require_relative '../lib/gemini/translator'
require_relative '../lib/hugo/filesystem_iterator'

# Input folder
input_folder = 'doc/posts'

# Hugo Blog Extensions and languages
#extensions = ['zzo', 'papermod', 'ananke']
extensions = ['zzo']
#languages = ['en', 'it', 'fr', 'de]
#languages = ['it', 'fr']
languages = ['it']


ENABLE_GEMINI = ENV.fetch('ENABLE_GEMINI', 'false').downcase == 'true'
OVERWRITE_FILES = ENV.fetch('OVERWRITE_FILES', 'fAlse').downcase == 'true'

puts(Rainbow("OVERWRITE_FILES: #{OVERWRITE_FILES} (#{OVERWRITE_FILES ? 'unsafe' : 'safe'})").send( OVERWRITE_FILES ? :red : :green))
puts(Rainbow("ENABLE_GEMINI:   #{ENABLE_GEMINI} (#{ENABLE_GEMINI ? 'Slow' : 'blazing-fast'})").send( ENABLE_GEMINI ? :red : :green))

iterate_through(input_folder:, extensions:, languages:, overwrite: OVERWRITE_FILES)
