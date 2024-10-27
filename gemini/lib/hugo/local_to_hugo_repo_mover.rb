
#
# Note that for this script, out_dir is the SOURCE dir :)
##
def copy_files_to_enabled_extensions_zzo_for_single_language(local_dir:, lang:, cleanup_output_folder_before: )
  puts("DEB copy_files_to_enabled_extensions_zzo_for_single_language(outdir: , lang=#{lang})")
  # DESTINATION FOLDER
  zzo_base_folder = ENV.fetch('ZZO_BASE_FOLDER', nil)

  raise "ZZO_BASE_FOLDER ('#{zzo_base_folder}') non existit - failing to deploy to local ZZO folder" unless File.exist?(zzo_base_folder)
  puts("Riccardo todo sanitize")
  emoji = get_language_emoji(lang)
  puts("Now 🇫🇷 French stuff - TODO in lang ==> #{emoji}")
  commands = [
    "TODO ricc in ruby, test each file in local folder...",
    "echo test output folder for BAD stuff, or maybe do it before :)",
    "echo cp -R gemini/out/zzo/#{lang}/ #{zzo_base_folder}/content/#{lang}/posts/gemini/ || true",
    "echo rsync -avz gemini/out/zzo/#{lang}/medium/ zzo.ricc.rocks/content/#{lang}/posts/medium/ || true",
  ]
  commands.each do |cmd|
    puts("💻 TODO exec: #{Rainbow(cmd).red}")
  end
end

# TODO
# verify if you want me to delete EVERYTHING from output folder before pushing my stuff. Somethings could have been renamed
# DFLT: YES
def copy_files_to_enabled_extensions(extensions:, languages:, out_dir:, cleanup_output_folder_before: true)
  puts("TODO ricc implementami. sposta ora tutto verso ZZO & c. Devo anche sapere la output dir.")
  extensions.each do |hugo_ext|
    puts("TODO(ricc): move all output files to extension: #{hugo_ext}, likely from #{out_dir}/#{hugo_ext}")
    if hugo_ext == 'zzo'
      languages.each do |lang|
        # Note that for this scruipt, OUTPUT means another thing so I renamed it LOCAL.
        copy_files_to_enabled_extensions_zzo_for_single_language(local_dir: out_dir, lang:, cleanup_output_folder_before: )
      end
    else
      raise "Unimplemented extension: #{hugo_ext}"
    end
  end


end
