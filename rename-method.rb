require 'yaml'
location, old_name, new_name = *ARGV
warn "Renaming #{old_name} to #{new_name}"
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

rename_locations = (locations + [[line, file]]).sort.uniq
warn rename_locations.inspect

filenames = rename_locations.map {|caller| caller[1]}.sort.uniq

filenames.each do |calling_name|
  lines = File.readlines(calling_name)
  rename_locations.each do |loc_line, loc_file|
    if calling_name == loc_file
      unless lines[loc_line - 1] =~ /\b#{old_name}\b/
        fail "Method #{old_name} not found on line #{loc_line} in #{calling_name}"
      end
      if lines[loc_line - 1] =~ /\b#{old_name}\b.*\b#{old_name}\b/
        fail "More than one match at line #{loc_line} in #{calling_name}"
      end
      lines[loc_line - 1].gsub!(/\b#{old_name}\b/, new_name)
    end
  end
  puts "# --- #{calling_name} ---"
  lines.each do |line|
    puts line
  end
end