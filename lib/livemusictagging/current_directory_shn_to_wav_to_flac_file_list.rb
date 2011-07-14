class CurrentDirectoryShnToWaveToFlacFileList

  def initialize(md5checker, executor, command_factory, flac_file_list_factory)
    puts "We must have shn files..."
    @md5checker = md5checker
    @executor = executor
    @command_factory = command_factory
    @flac_file_list_factory = flac_file_list_factory
  end

  def valid?
    if(@md5checker.valid?)
      return @command_factory.shn_to_wav_to_flac_command(@executor, @md5checker).execute?
    end
    false
  end

  def flac_files
    command = @command_factory.remove_md5_files_command
    @flac_file_list_factory.flac_file_list(nil, FlacFileFetcher.new, command).flac_files #nil here because there won't be an md5 file for flacs we created
  end

end
