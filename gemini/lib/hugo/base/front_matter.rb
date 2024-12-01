# Described here: https://gohugo.io/content-management/front-matter/

require 'yaml'

# From Gemini
def parse_frontmatter(file_path)
  # Read the file contents
  content = File.read(file_path)

  # Split the content into frontmatter and body
  if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
    frontmatter = YAML.safe_load($1, permitted_classes: [Time, Date])
    body = $'
  else
    frontmatter = {}
    body = content
  end

  # Return the frontmatter and body
  return frontmatter, body
end
