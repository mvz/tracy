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

def recurse_call_sites(executable, count)
  return unless executable.is_a? Rubinius::CompiledCode
  return if EXECUTABLES[executable]
  EXECUTABLES[executable] = 1

  indent = '   ' * count

  printable = executable.file =~ /tracy/

  puts "#{indent}Executable #{executable.name} in #{executable.file} line #{executable.defined_line}" if printable

  executable.call_sites.each do |call_site|
    case call_site
    when Rubinius::PolyInlineCache
      puts "#{indent} PolyInlineCache at #{call_site.location}" if printable
      call_site.entries.each do |entry|
        next unless entry
        puts "#{indent}  Cache entry for method #{entry.receiver_class}::#{call_site.name} at #{call_site.location}" if printable
        recurse_call_sites(entry.method, count + 1)
      end
    when Rubinius::MonoInlineCache
      puts "#{indent} Mono cache for method #{call_site.receiver_class}::#{call_site.name} at #{call_site.location}" if printable
      recurse_call_sites(call_site.method, count + 1)
    when Rubinius::CallSite
      puts "#{indent} CallSite #{call_site.name} at #{call_site.location}" if printable
    else
      p call_site
      recurse_call_sites(call_site.method, count + 1)
    end
  end

  executable.child_methods.each do |ex|
    recurse_call_sites(ex, count + 1)
  end
end

recurse_call_sites(m.executable, 0)
