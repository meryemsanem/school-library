class PreserveData
  attr_accessor :file_name

  def initialize(file_name)
    @file_name = file_name
  end
end

class WriteFile < PreserveData
  def write(data)
    json = JSON.pretty_generate(data)
    File.write(@file_name, json)
  end
end

class ReadFile < PreserveData
  def read
    WriteFile.new(@file_name).write([]) unless File.exist?(@file_name)
    file = File.read(@file_name)
    JSON.parse(file)
  end
end
