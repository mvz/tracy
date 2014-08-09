require 'yaml'
location = ARGV[0]
file, line = location.split ':'
line = line.to_i
location_data = YAML.load(File.read('callsite-info.yml'))
locations = []

Location = Struct.new(:method_name, :class_name, :line, :file)

location_data.each do |key, callers|
  loc = Location.new(*key)
  if line == loc.line && file == loc.file
    locations += callers
  end
end

p locations
