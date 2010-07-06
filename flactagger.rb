require 'date'

#class UserEnteredSourceInfo
#  def source_info
#    puts("Source Info (when done type \"END\"): ")
#    STDIN.gets("")
#  end
#end

class UserEnteredSongNameFetcher
  
  def song_name(file)
    puts("Song name for #{file}: ")
    songname = gets
  end
    
end

class CurrentDirectoryFlacFileList
  
  def flac_files
    Dir.glob("*.flac")
  end
  
end

class DiscAndTrackInfo
  
  def initialize(date, files)
    @date = date
    @month = @date.month
    @day = @date.day
    @files = files
    
    @discs_and_tracks = {}
    @file_to_disc = {}
    @file_to_track = {}     
    
    @files.each do |file|
      file[Regexp.new("gd#{@date.strftime('%g')}-#{@month}-#{@day}d(\\d)t(\\d+).flac")]
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

class MetaFlacArgumentBuilder
  SET_TAG_PREFIX = "--set-tag="
  
  def initialize
    @args = ""
  end
  
  def arguments
    @args
  end
  
  def add_description(desc)
    add_argument("DESCRIPTION", desc)
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
  end
  
  def add_date(date)
    add_argument("DATE", date)
  end
  
  def add_genre(genre)
    add_argument("GENRE", genre)
  end
  
  def add_disc_total(total)
    add_argument("DISCTOTAL", total)
  end
  
  def add_track_number(number)
    add_argument("TRACKNUMBER", number)
  end
  
  def add_disc_number(number)
    add_argument("DISCNUMBER", number)
  end
  
  def add_track_total(total)
    add_argument("TRACKTOTAL", total)
  end
  
  private
  
  def add_argument(tag_name, value)
    @args += " #{SET_TAG_PREFIX}#{tag_name}=\"#{value}\""
  end
  
end

class FlacTagger

  BIN_DIR = "/Applications/xACT.app/Contents/Resources/Binaries/bin"
  METAFLAC = "#{BIN_DIR}/metaflac"
  
  def initialize(artist, date, location, venue)
    @date = Date.parse(date)
    #@source_info = UserEnteredSourceInfo.new
    @files = CurrentDirectoryFlacFileList.new.flac_files
    @disc_and_track_info = DiscAndTrackInfo.new(@date, @files)
    @artist = artist
    @location = location
    @venue = venue
    @song_name_fetcher = UserEnteredSongNameFetcher.new
  end
  
  def write_tags
    #source = @source_info.source_info
    
    @files.each do |file|
      builder = MetaFlacArgumentBuilder.new  
      #builder.add_description(source)    
      builder.add_title(@song_name_fetcher.song_name(file))
      builder.add_artist(@artist)
      builder.add_album(build_album_string)
      builder.add_date(@year)
      builder.add_genre("Rock")
      builder.add_disc_total(@disc_and_track_info.disc_total)
      builder.add_track_number(@disc_and_track_info.track_number(file))
      builder.add_disc_number(@disc_and_track_info.disc_number(file))
      builder.add_track_total(@disc_and_track_info.track_total(file))
      
      system("#{METAFLAC} #{builder.arguments} #{file}")
    end    
  end
  
  def build_album_string
    "#{@date.strftime('%Y/%m/%d')} #{@location} - #{@venue}"
  end
  
end

puts "Enter Date (yyyy/mm/dd): "
date = gets

puts "Enter City, State: "
location = gets

puts "Enter Venue: "
venue = gets

tagger = FlacTagger.new("Grateful Dead", date, location, venue)
tagger.write_tags
