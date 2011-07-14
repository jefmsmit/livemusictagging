class CommandFactory

  def shn_to_wav_to_flac_command(executor, md5checker)
    CompoundCommand.new(
        [ShnToWavCommand.new(executor, md5checker),
         WavToFlacCommand.new(executor),
         RemoveFilesCommand.new("*.wav", nil),
         RemoveFilesCommand.new("*.md5", "*wav*.md5")]
    )
  end

  def remove_md5_files_command
    RemoveFilesCommand.new("*.md5", "*wav*.md5")
  end

end