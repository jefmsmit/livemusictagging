require 'date'

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
    @date = Date.parse(date)
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

class FlacTagger

  BIN_DIR = "/Applications/xACT.app/Contents/Resources/Binaries/bin"
  METAFLAC = "#{BIN_DIR}/metaflac"
  
  def initialize(artist, date, location, venue)
    @date = Date.parse(date)
    @files = CurrentDirectoryFlacFileList.new.flac_files
    @disc_and_track_info = DiscAndTrackInfo.new(date, @files)
    @artist = artist
    @year = @date.year
    @month = @date.month
    @day = @date.day
    @location = location
    @venue = venue
    @song_name_fetcher = UserEnteredSongNameFetcher.new
  end
  
  def write_tags
    @files.each do |file|
      disc_total = @disc_and_track_info.disc_total
      track_number = @disc_and_track_info.track_number(file)
      disc_number = @disc_and_track_info.disc_number(file)
      track_total = @disc_and_track_info.track_total(file)
      
      songname = @song_name_fetcher.song_name(file)
      
      system("#{METAFLAC} --set-tag=TITLE='#{songname}' --set-tag=ARTIST='#{@artist}' --set-tag=ALBUM='#{build_album_string}' --set-tag=DATE='#{@year}' --set-tag=Genre=Rock --set-tag=DISCTOTAL=#{disc_total} --set-tag=TRACKNUMBER='#{track_number}' --set-tag=DISCNUMBER='#{disc_number}' --set-tag=TRACKTOTAL='#{track_total}' #{file}")
    end    
  end
  
  def build_album_string
    "#{@year}/#{@month}/#{@day} #{@location} - #{@venue}"
  end
  
end

puts "Enter Date: "
date = gets

puts "Enter City, State: "
location = gets

puts "Enter Venue: "
venue = gets

tagger = FlacTagger.new("Grateful Dead", date, location, venue)
tagger.write_tags
