class CurrentDirectoryFlacFileList

  attr_reader :flac_files

  def initialize(md5checker, fetcher, post_md5_valid_command)
    puts("We must have flac files...")
    @md5checker = md5checker
    @flac_files = fetcher.fetch
    @command = post_md5_valid_command
  end

  def valid?
    if(@md5checker.valid?)
      return @command.execute?
    end
    false
  end

end
