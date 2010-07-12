#!/usr/bin/env ruby

# ToDo:
# support automatic source information
# support automatic song information
# support user entered input as command line arguments
# check for shn first, validate md5s, convert to wavs, validate md5s again, convert to flacs
# support custom file patterns


require 'date'

class SystemExecutor
  def execute(call)
    return system(call)
  end
end

class UserEnteredSourceInfo
  def source_info
    puts("Source Info (when done type \"END\"): ")
    
    line = gets
    source = line
    while not (line.chomp == "END")
      line = gets
      source += line unless line.chomp == "END" # there must be a better way
    end
    
    source   
    
  end
end

class UserEnteredSongNameFetcher
  
  def song_name(file)
    puts("Song name for #{file}: ")
    songname = gets
  end
    
end

class MD5Checker
  
  def initialize(executor, pattern)
    @executor = executor
    @pattern = pattern
  end
  
  def valid?
    md5s = Dir.glob(@pattern)
    md5s.each do |file|
      puts("checking #{file}")
      #status = @executor.execute("md5sum -c #{file}") 
      #return status unless status
    end
    return true
  end
  
end

class ShnToWavConverter
  
  def initialize(executor)
    @executor = executor
  end
  
  def convert
    shns = Dir.glob("*.shn")
    
    shns.each do |file|
      puts ("converting shn file #{file} to wav")
      status = @executor.execute("shorten -x #{file}") #how do I keep the original shn files?
      return status unless status
    end
    return true
  end
  
end

class WavToFlacConverter
  
  def initialize(executor)
    @executor = executor
  end
  
  def convert
    #should validate any wav file md5 sums here
    flacs = Dir.glob("*.wav")
    
    flacs.each do |file|
      puts("converting wav file #{file} to flac")
      status = @executor.execute("flac -8 #{file}")
      return status unless status
    end   
    #need to delete the wav files 
    return true
  end
  
end

class RemoveWavConverter
  
  def initialize(executor)
    @executor = executor
  end
  
  def convert
    puts("should be deleting the wavs here, but I don't know how")
    return true
  end
  
end

class ChainedConverter
  
  def initialize(converters)
    @converters = converters
  end
  
  def convert
    @converters.each do |converter|
      status = converter.convert
      return status unless status
    end
    return true
  end
  
end

class CurrentDirectoryFlacFileList
  
  attr_reader :flac_files

  def initialize(md5checker)
    puts("We must have flac files...")
    @md5checker = md5checker
    @flac_files = Dir.glob("*.flac")
  end
  
  def valid?
    return @md5checker.valid?
  end
  
end

class CurrentDirectoryShnToWaveToFlacFileList
  
  def initialize(md5checker, executor)
    puts "We must have shn files..."
    @md5checker = md5checker
    @executor = executor
  end
  
  def valid?    
    if(@md5checker.valid?)
      return ChainedConverter.new(
        [ShnToWavConverter.new(@executor), WavToFlacConverter.new(@executor), RemoveWavConverter.new(@executor)]
      ).convert
    end    
    false
  end
  
  def flac_files
    flac_files = CurrentDirectoryFlacFileList.new(nil).flac_files
    puts(flac_files)
    flac_files
  end
  
end

class FlacFileListFactory
  
  def initialize(executor)
    @executor = executor
  end
  
  def flac_file_list
    if not Dir.glob("*.flac").empty?
      return CurrentDirectoryFlacFileList.new(MD5Checker.new(@executor, "*.md5"))
    elsif not Dir.glob("*.shn").empty?
      return CurrentDirectoryShnToWaveToFlacFileList.new(MD5Checker.new(@executor, "*.md5"), @executor)
    else
      []
    end    
  end
  
end

class DiscAndTrackInfo
  
  def initialize(date, files)
    @discs_and_tracks = {}
    @file_to_disc = {}
    @file_to_track = {}     
    
    files.each do |file|
      regex = "gd#{date.strftime('%g')}-#{date.strftime('%m')}-#{date.strftime('%d')}d(\\d)t(\\d+).flac"
      file[Regexp.new(regex)]
      current_disc = $1
      current_track = $2.to_i
      @file_to_disc[file] = current_disc
      @file_to_track[file] = current_track
      @discs_and_tracks[current_disc] = current_track
    end
  end
  
  def disc_total
    @discs_and_tracks.size
  end
  
  def track_number(file)
    @file_to_track[file]
  end  
  
  def disc_number(file)
    @file_to_disc[file]
  end
  
  def track_total(file)
    @discs_and_tracks[disc_number(file)]
  end
      
end

class FlacTagBuilder
  SET_TAG_PREFIX = "--set-tag="
  
  def initialize
    @args = ""
  end
  
  def arguments
    @args
  end
  
  def add_description(desc)
    add_argument("DESCRIPTION", desc)
    self
  end
  
  def add_title(title)
    add_argument("TITLE", title)
    self
  end
  
  def add_artist(artist)
    add_argument("ARTIST", artist)
    self
  end  
  
  def add_album(album)
    add_argument("ALBUM", album)
    self
  end
  
  def add_date(date)
    add_argument("DATE", date)
    self
  end
  
  def add_genre(genre)
    add_argument("GENRE", genre)
    self
  end
  
  def add_disc_total(total)
    add_argument("DISCTOTAL", total)
    self
  end
  
  def add_track_number(number)
    add_argument("TRACKNUMBER", number)
    self
  end
  
  def add_disc_number(number)
    add_argument("DISCNUMBER", number)
    self
  end
  
  def add_track_total(total)
    add_argument("TRACKTOTAL", total)
    self
  end
  
  private
  
  def add_argument(tag_name, value)
    @args += " #{SET_TAG_PREFIX}#{tag_name}=\"#{value}\""
  end
  
end

class TagWriter
  
  def initialize(executor)
    @executor = executor
  end
  
  def write_tags(file, builder)
    @executor.execute("metaflac #{builder.arguments} #{file}")
  end
  
end

class FlacTagger

  def initialize(files, source_info, disc_and_track_info, song_name_fetcher, tag_writer)
    @files = files
    @source_info = source_info    
    @disc_and_track_info = disc_and_track_info
    @song_name_fetcher = song_name_fetcher
    @tag_writer = tag_writer
  end
  
  def write_tags(artist, date, location, venue)
    source = @source_info.source_info
    
    @files.each do |file|
      builder = FlacTagBuilder.new  
      builder.add_description(source).    
        add_title(@song_name_fetcher.song_name(file)).
        add_artist(artist).
        add_album(build_album_string(date, location, venue)).
        add_date(date.strftime('%Y')).
        add_genre("Rock").
        add_disc_total(@disc_and_track_info.disc_total).
        add_track_number(@disc_and_track_info.track_number(file)).
        add_disc_number(@disc_and_track_info.disc_number(file)).
        add_track_total(@disc_and_track_info.track_total(file))
      
      @tag_writer.write_tags(file, builder)
    end    
  end
  
  def build_album_string(date, location, venue)
    "#{date.strftime('%Y/%m/%d')} #{location} - #{venue}"
  end
  
end

puts "Enter Date (yyyy/mm/dd): "
date = Date.parse(gets.chomp)

puts "Enter City, State: "
location = gets.chomp

puts "Enter Venue: "
venue = gets.chomp

system_executor = SystemExecutor.new
source_info = UserEnteredSourceInfo.new
flac_file_list = FlacFileListFactory.new(system_executor).flac_file_list

if(flac_file_list.valid?)
  puts "Flac files are valid, proceeding..."
  files = flac_file_list.flac_files 
  disc_and_track_info = DiscAndTrackInfo.new(date, files)
  song_name_fetcher = UserEnteredSongNameFetcher.new
  tag_writer = TagWriter.new(system_executor)

  tagger = FlacTagger.new(files, source_info, disc_and_track_info, song_name_fetcher, tag_writer)
  tagger.write_tags("Grateful Dead", date, location, venue)
else
  puts "There was a problem with the flacs, perhaps a bad md5?"
end

