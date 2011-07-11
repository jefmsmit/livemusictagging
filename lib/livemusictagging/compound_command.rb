class CompoundCommand

  def initialize(commands)
    @commands = commands
  end

  def execute?
    @commands.each do |command|
      status = command.execute?
      return status unless status
    end
    true
  end

end
