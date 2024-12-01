

#  "src/posts//" =>  "src/posts/"
def sanitize_path(path:, removed_leading_slah: false)
  path.gsub(/\/+/, '/')
end

# classify
def iterate_through_carlessian_articles(
  input_base_folder:,
  max_articles:,
  extensions: ['zzo'],
  dry_run: true,
  show_file_list: false
)
  puts("iterate_through_carlessian_articles(): input_base_folder=#{input_base_folder}, max_articles=#{max_articles}")
  input_folder = input_base_folder
  puts("iterate_through_carlessian_articles(): DRYRUN enabled! ") if dry_run
  #exit 42
  n_articles = 0
  n_articles_errors = 0
  # Iterate through each extension and language
#  extensions.each do |extension|

    # Iterate through input files
      Dir.glob("#{input_folder}/**/*").each do |file|
        # Skip markdown files and directories
        next if File.directory?(file)

        # Determine output file path
        #output_file = output_folder + file.gsub(input_base_folder, '')

        # Create output directory if needed
        #FileUtils.mkdir_p(File.dirname(output_file))

        if file.end_with?('.md')
          file_stats = aruspicami(file: )
          puts("📜 markdown file: #{Rainbow(file).cyan}. file_stats: #{file_stats}") if show_file_list
          print_fancy_file_stats(file:, file_stats:)
          n_articles += 1
        else
          # Copy file to output folder
          deb("NOT MD => just ignoring #{file}..")
          #FileUtils.cp(file, output_file) unless dry_run
        end
      end


  puts("#Articles n_articles_errors✅ correctly parsed: #{n_articles}")
  puts("#Articles 🙈 with errors: #{n_articles_errors}")

  return { n_articles: , n_articles_errors: }
end



# I want to create a new version of iterate_through|() which takes same inputs, but for each files manages with a configurable callback. Please copy code in iterate_through() and for each file call a certain callback we add in argument. Lets call it iterate_through_with_callback()


# DryRun. If enabled, doesnt copy files, doesnt do Gemini translation but it does creat folders.
# Iterates trough a list of files with the intention to copy them to ZZO under EN/FR/ES and so on...
def iterate_through(
    #input_folder:,
    input_base_folder:,
    input_subfolder:,
    extensions:,
    languages:,
    overwrite_existing_out_file: false,
    max_articles: ,
    restrict_src_path_by_regex: ,
    out_dir: ,
    dry_run: false)
  input_folder = sanitize_path path: "#{input_base_folder}/#{input_subfolder}"
  puts("* INPUT: A   input_base_folder:  #{input_base_folder}")
  puts("* INPUT: B   input_subfolder:    #{input_subfolder}")
  puts("* INPUT: A+B input_folder:       #{input_folder}")
  puts("* INPUT: restrict_src_path_by_regex: #{restrict_src_path_by_regex}")
  puts("iterate_through() DRYRUN enabled! ") if dry_run
  #exit 42
  n_articles = 0
  n_articles_errors = 0
  # Iterate through each extension and language
  extensions.each do |extension|
    languages.each do |lang|
      # Create output folder
      output_folder = "#{out_dir}/#{extension}/#{lang}/"
      FileUtils.mkdir_p(output_folder)

      # Iterate through input files
      Dir.glob("#{input_folder}/**/*").each do |file|
        # Skip markdown files and directories
        next if File.directory?(file)

        # Determine output file path
        output_file = output_folder + file.gsub(input_base_folder, '')

        # Create output directory if needed
        FileUtils.mkdir_p(File.dirname(output_file))

        # Geminizing the file
        if file.end_with?('.md')
          #puts("TODO check the MD5 of the source file to see if it has changed. Wait, credo lo faccia gia semplicemente cambiando il nome del cache file.. l unico problema e trovare cache duplicates..")
          if File.exist?(output_file) and (not overwrite_existing_out_file)
            puts(Rainbow("Output File exists ('#{output_file}') and overwrite_existing_out_file=false => skipping Geminization").darkslategray)
          else
            # Exit if too many files.
            if n_articles >= max_articles
              puts("[ERROR] Max Articles reached (#{n_articles}) - refusing to use Gemini on #{file}")
              break
            end
            # Normal flow: Gemini is ON! :)
            deb("Either OutputFile '#{Rainbow(output_file).purple}' doesnt exist or overwrite_existing_out_file=false => doing Geminization!!")
            # Call your Gemini function (replace with your actual implementation)
#            translate_with_gemini(file_name: file, extension:, lang:, output_file: , overwrite_existing_out_file:)
            begin
              # Call your Gemini function (replace with your actual implementation)
              if dry_run
                puts("[DRYRUN] Skipping translate for #{file}")
              else
                translate_with_gemini(file_name: file, extension:, lang:, output_file:)
              end
              n_articles += 1
            rescue StandardError => e  # Catch any StandardError
              n_articles_errors += 1
              puts Rainbow("🙈 iterate_through(): Error processing file '#{file}': #{e.message}").red
              # Optionally, you can log the error to a file or error tracking service
              Langchain.logger.error("Error processing file '#{file}': #{e.message}")
              #  # Or use your preferred logging mechanism
              # Re-raise the exception if you want to halt execution
              raise e
            end
            #n_articles += 1
          end
        else
          # Copy file to output folder
          deb("NOT MD => just copying #{file} to #{output_file}..")
          FileUtils.cp(file, output_file) unless dry_run
        end
      end
    end
  end

  puts("#Articles n_articles_errors✅ correctly parsed: #{n_articles}")
  puts("#Articles 🙈 with errors: #{n_articles_errors}")

  return { n_articles: , n_articles_errors: }
end
