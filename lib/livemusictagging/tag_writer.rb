class TagWriter

  def initialize(executor)
    @executor = executor
  end

  def write_tags(file, builder)
    @executor.execute("metaflac #{builder.arguments} #{file}")
  end

end
