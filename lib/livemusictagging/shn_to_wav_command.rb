class ShnToWavCommand

  def initialize(executor, wav_md5_checker)
    @executor = executor
    @wav_md5_checker = wav_md5_checker
  end

  def execute?
    shns = Dir.glob("*.shn")

    shns.each do |file|
      puts ("converting shn file #{file} to wav")
      status = @executor.execute("shorten -x #{file}") #how do I keep the original shn files?
      return status unless status
    end

    @wav_md5_checker.valid?
  end

end
