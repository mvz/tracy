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

call_sites = ObjectSpace.each_object(Rubinius::CallSite).map(&:itself)

call_sites.each do |call_site|
  next if call_site.is_a? Rubinius::InlineCacheEntry
  next unless call_site.location =~ /tracy/
  case call_site
  when Rubinius::PolyInlineCache
    puts "PolyInlineCache at #{call_site.location}"
    call_site.entries.each do |entry|
      next unless entry
      puts "  Cache entry for method #{entry.receiver_class}::#{call_site.name} at #{call_site.location}"
    end
  when Rubinius::MonoInlineCache
    puts "Mono cache for method #{call_site.receiver_class}::#{call_site.name} at #{call_site.location}"
  when Rubinius::CallSite
    puts "CallSite #{call_site.name} inside #{call_site.executable.name} at #{call_site.location}"
  end
end
