#!/usr/bin/env ruby

# ToDo:
# re-create the ffp
# support user entered input as command line arguments
# support custom file patterns

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib', 'livemusictagging'))

Dir.glob(File.join(File.dirname(__FILE__), 'lib', 'livemusictagging', '*.rb')).each do |file|
  require file
end


require 'date'

puts "Enter Date (yyyy/mm/dd): "
date = Date.parse(gets.chomp)

puts "Enter City, State: "
location = gets.chomp

puts "Enter Venue: "
venue = gets.chomp

default_pattern = "gd#{date.strftime('%g')}-#{date.strftime('%m')}-#{date.strftime('%d')}d{d}t{t}.flac"
puts "File Pattern [#{default_pattern}]:"
user_pattern = gets.chomp
pattern = (not user_pattern.empty?) ? user_pattern : default_pattern 
regex_builder = FilePatternRegexBuilder.new(date, pattern)

system_executor = SystemExecutor.new
source_info = UserEnteredSourceInfo.new
flac_file_list = FlacFileListFactory.new(system_executor).flac_file_list

if(flac_file_list.valid?)
  puts "Flac files are valid, proceeding..."
  files = flac_file_list.flac_files 
  disc_and_track_info = DiscAndTrackInfo.new(regex_builder, files)
  song_name_fetcher = UserEnteredSongNameFetcher.new
  tag_writer = TagWriter.new(system_executor)

  tagger = FlacTagger.new(files, source_info, disc_and_track_info, song_name_fetcher, tag_writer)
  tagger.write_tags("Grateful Dead", date, location, venue)
else
  puts "There was a problem with the flacs, perhaps a bad md5?"
end

