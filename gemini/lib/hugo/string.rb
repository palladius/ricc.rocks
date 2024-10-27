
class String
  def inject_in_front_matter(comment)
    if self =~ /---\n/
      self.sub!(/---\n/, "---\n#{comment}\n")
    else
      raise "No front matter found in the string."
      puts("Esco per sicurezza")
      exit(42)
    end
    self
  end
end
