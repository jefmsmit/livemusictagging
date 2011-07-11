class CurrentDirectoryFlacFileList

  attr_reader :flac_files

  def initialize(md5checker)
    puts("We must have flac files...")
    @md5checker = md5checker
    @flac_files = Dir.glob("*.flac")
  end

  def valid?
    if(@md5checker.valid?)
      return RemoveFilesCommand.new("*.md5", "*wav*.md5").execute?
    end
    false
  end

end
