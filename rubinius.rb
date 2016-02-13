class Foo
  def baz
    puts 'baz'
  end
end

class OtherFoo
  def baz
    puts 'this is not the original baz'
  end
end

class Bar
  def initialize foo
    @foo = foo
  end

  def bar
    @foo.baz
  end
end

def blub
  puts 'Blub'
  Foo.new.baz
end

def main
  foo = Foo.new
  foo.baz

  bar = Bar.new foo
  bar.bar
  foo.baz

  otherfoo = OtherFoo.new

  [foo, otherfoo].each do |it|
    it.baz
  end

  blub
end

main

m = method :__script__

EXECUTABLES = {}

def print_executable(executable, count)
  return unless executable.is_a? Rubinius::CompiledCode
  return if EXECUTABLES[executable]
  EXECUTABLES[executable] = 1

  printable = executable.file =~ /tracy/
  indent = '    ' * count

  puts "#{indent}Executable #{executable.name} in #{executable.file} line #{executable.defined_line}" if printable

  executable.call_sites.each do |call_site|
    print_call_site(call_site, count + 1, printable)
  end

  executable.child_methods.each do |ex|
    print_executable(ex, count + 1)
  end
end

def print_call_site(call_site, count, printable)
  indent = '    ' * count

  case call_site
  when Rubinius::PolyInlineCache
    puts "#{indent}PolyInlineCache at #{call_site.location}" if printable
    call_site.entries.each do |entry|
      next unless entry
      print_cache_entry(call_site, entry, count + 1, printable)
    end
  when Rubinius::MonoInlineCache
    executable = call_site.method
    if printable
      if executable.is_a? Rubinius::CompiledCode
        puts "#{indent}MonoInlineCache at #{call_site.location} calling #{call_site.receiver_class}::#{call_site.name} at #{executable.file}:#{executable.defined_line}"
      else
        puts "#{indent}MonoInlineCache at #{call_site.location} calling #{call_site.receiver_class}::#{call_site.name}"
      end
    end
    print_executable(executable, count + 1)
  when Rubinius::CallSite
    puts "#{indent}CallSite #{call_site.name} at #{call_site.location}" if printable
  end
end

def print_cache_entry(call_site, entry, count, printable)
  indent = '    ' * count
  executable = entry.method
  if printable
    if executable.is_a? Rubinius::CompiledCode
      puts "#{indent}InlineCacheEntry at #{call_site.location} calling #{entry.receiver_class}::#{call_site.name} at #{executable.file}:#{executable.defined_line}"
    else
      puts "#{indent}InlineCacheEntry at #{call_site.location} calling #{entry.receiver_class}::#{call_site.name}"
    end
  end
  print_executable(executable, count + 1)
end

print_executable(m.executable, 0)
