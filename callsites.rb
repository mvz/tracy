require 'yaml'

Location = Struct.new(:method_name, :class_name, :line, :file) do
  def match(other)
    (other.method_name.nil? || other.method_name == method_name) &&
      (other.class_name.nil? || other.class_name == class_name) &&
      (other.line.nil? || other.line == line) &&
      (other.file.nil? || other.file == file)
  end
end

location = ARGV[0]
file, line = location.split ':'
line = line.to_i

target_location = Location.new(nil, nil, line, file)

location_data = YAML.load(File.read('callsite-info.yml'))
locations = []

location_data.each do |key, callers|
  loc = Location.new(*key)
  if loc.match(target_location)
    locations += callers
  end
end

p locations
