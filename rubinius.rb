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

m = method :main

def recurse_call_sites(x, count)
  return if count > 7
  x.call_sites.each do |call_site|
    printable = call_site.location =~ /tracy/
    printable = true
    case call_site
    when Rubinius::PolyInlineCache
      puts "[#{count}] PolyInlineCache at #{call_site.location}" if printable
      call_site.entries.each do |entry|
        next unless entry
        puts "[#{count}] Cache entry for method #{entry.receiver_class}::#{call_site.name} at #{call_site.location}" if printable
        begin
          recurse_call_sites(entry.method, count + 1)
        rescue => e
          require 'pry'
          binding.pry
        end
      end
    when Rubinius::MonoInlineCache
      puts "[#{count}] Mono cache for method #{call_site.receiver_class}::#{call_site.name} at #{call_site.location}" if printable
      recurse_call_sites(call_site.method, count + 1)
    when Rubinius::CallSite
      puts "[#{count}] Plain compiled_code inside #{x.name}; #{call_site.executable == x}" if printable
    else
      p call_site if printable
      recurse_call_sites(call_site.method, count + 1)
    end
  end
end

recurse_call_sites(m.executable, 0)
