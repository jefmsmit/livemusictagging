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
