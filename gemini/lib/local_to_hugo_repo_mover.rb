require_relative "tests/validate_markdowns"


def count_markdowns(folder:)
  `find '#{folder}' -name \\*.md`.split("\n")
end

def safe_rm_rf(dest_dir_to_be_cleaned_up: dest_language_specific_dir)
  # yup, sometimes its not sanitized so i have double //
  safety_regex = /zzo.ricc.rocks(\/)+content/
  max_files_delenda_safety = 20
  raise "Suspicious dir i wont rm -rf it: #{dest_dir_to_be_cleaned_up}" unless dest_dir_to_be_cleaned_up.match?(safety_regex)
  n_files_to_be_deleted = count_markdowns(folder: dest_dir_to_be_cleaned_up).count
  puts("Deleting #{n_files_to_be_deleted} files..")
  raise "Too many files (#{n_files_to_be_deleted} > #{max_files_delenda_safety}), safety detected, exiting!" if (n_files_to_be_deleted > max_files_delenda_safety)
  ret = `echodo rm -rf '#{dest_dir_to_be_cleaned_up}' >&2`
  puts("Successfully Deleted #{n_files_to_be_deleted} files from dir: #{Rainbow(dest_dir_to_be_cleaned_up).red}")
end

def safe_copy_files(src: , dst:)
  FileUtils.mkdir_p(dst)
  puts(`ls -al #{src}/`)
  raise "safe_copy_files(): unavailable SRC dir" unless File.exist?(src)
  raise "safe_copy_files(): unavailable DST dir" unless File.exist?(dst)
  # echodo is an additional safety net that it only works on ricc computer.
  copied = `echodo cp -R '#{src}' "#{dst}/"`
  puts("Cppied! #{Rainbow(copied).green}")
end


# This script copies from gemini/zzo/jp...
# to zzzo.ricc-rocks/content/jp/.. so from brutta to bella basically
# Note that for this script, out_dir is the SOURCE dir :)
def copy_files_to_enabled_extensions_zzo_for_single_language(local_dir:, lang:, cleanup_output_folder_before: )
  # DESTINATION FOLDER
  zzo_base_folder = ENV.fetch('ZZO_BASE_FOLDER', nil)
  local_language_specific_dir = "#{local_dir}/zzo/#{lang}/"
  raise "ZZO_BASE_FOLDER ('#{zzo_base_folder}') non existit - failing to deploy to local ZZO folder" unless File.exist?(zzo_base_folder)
  dest_language_specific_dir = "#{zzo_base_folder}/content/#{lang}/posts/"
  emoji = get_language_emoji(lang_code: lang)
  language_name = get_language_name(lang_code: lang) # eg "French"
  inspectanda_files = count_markdowns(folder: local_language_specific_dir) # `find #{local_language_specific_dir} -name \\*.md`.split("\n") # :)
  num_dst_files = count_markdowns(folder: dest_language_specific_dir)

  puts("="*80)
  puts("Local dir:       #{local_dir}")
  puts("lang:            #{lang}")
  puts("ZZO_BASE_FOLDER: #{zzo_base_folder}")
  puts('-'*80)
  puts("local language_specific_dir: #{local_language_specific_dir} (#{inspectanda_files.count} files)")
  puts("dest_language_specific_dir:  #{dest_language_specific_dir} (#{num_dst_files.count} files)")
  puts("cleanup_output_folder_before: #{cleanup_output_folder_before}. If true, say good bye to all those files above.")
  puts("="*80)

  # Cleanup if need be
  if cleanup_output_folder_before
    safe_rm_rf(dest_dir_to_be_cleaned_up: dest_language_specific_dir)
  end

  # Validation
  puts("DEB copy_files_to_enabled_extensions_zzo_for_single_language(outdir: , lang=#{lang})")
  puts("DEB 🔁 REFACTO(RICC): move to bin/build-all as phase 2: gemini, test, copy. not in the middle of the copy!")
  inspectanda_files.each do |file|
    deb("🔎 Inspecting Markdown: #{file}")
    validate_yaml_front_matter_for_file(file)
  end

  puts("Now #{emoji} We transfer just-produced #{language_name} stuff to your ZZO Hugo repo: #{zzo_base_folder}")

  puts("Riccardo todo sanitize")
  # 1/ Testing quality
  puts("1. Now validating... validate_yaml_front_matter for: #{local_language_specific_dir}")

  validate_yaml_front_matter_for_dir(local_language_specific_dir)
  puts(Rainbow("all good! Now lets copy!"))


  #################
  #safe_copy_files("out/zzo/#{lang}/", "#{zzo_base_folder}/content/#{lang}/posts/gemini/")
  safe_copy_files(
    src: "out/zzo/#{lang}/",
    dst: "#{zzo_base_folder}/content/#{lang}/posts/gemini/"
  )

  # commands = [
  #   "echo rsync -avz gemini/out/zzo/#{lang}/medium/ zzo.ricc.rocks/content/#{lang}/posts/medium/ [mi sa che questo e obsoleto ora Medium e dentro gemini]",
  # ]
  # commands.each do |cmd|
  #   puts("💻 TODO exec: #{Rainbow(cmd).red}")
  # end
end

# TODO
# verify if you want me to delete EVERYTHING from output folder before pushing my stuff. Somethings could have been renamed
# DFLT: YES
def copy_files_to_enabled_extensions(extensions:, languages:, out_dir:, cleanup_output_folder_before: true)
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
