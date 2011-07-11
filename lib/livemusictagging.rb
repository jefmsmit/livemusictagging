Dir.glob(File.join(File.dirname(__FILE__), 'livemusictagging', '*.rb')).each do |file|
  require file
end

module LiveMusicTagging
  # Your code goes here...
end
