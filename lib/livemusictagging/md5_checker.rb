require 'digest/md5'

class MD5Checker

  def initialize(pattern, exclude_pattern)
    all_files = Dir.glob(pattern)
    excludes = exclude_pattern ? Dir.glob(exclude_pattern) : []
    @files = []

    all_files.each do |file|
      @files.push(file) unless excludes.member?(file)
    end

  end

  def valid?
    @files.each do |file|
      status = all_in_file_valid?(file)
      return status unless status
    end
    true
  end

  private

  def all_in_file_valid?(file)
    puts "Validating #{file}"
    file_to_checksum = build_file_checksum_hash(file)
    valid = true

    file_to_checksum.sort{|a,b| a<=>b}.each do |key, value|
      status = file_passes_checksum?(key, value)
      valid = valid && status
    end

    valid
  end

  def build_file_checksum_hash(md5file)
    file_to_checksum = {}

    #todo, this breaks if there are blank lines
    File.open(md5file, "r") do |infile|
      puts "opened file"
      while(line = infile.gets)
        parts = line.split(/\s+/)
        file_to_checksum[parts[1].sub(/\*/, "").chomp] = parts[0]
      end
    end

    file_to_checksum
  end

  def file_passes_checksum?(file, checksum)
    puts "Checking #{file}"
    if(File.exist?(file))
      puts("  #{file} passed")
      all_digest = Digest::MD5.hexdigest(File.read(file))
      all_digest == checksum
    else
      puts "  #{file} not found"
      false
    end
  end

end
