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

  executable.call_sites.each do |call_site|
    print_call_site(call_site, count + 1)
  end

  executable.child_methods.each do |ex|
    print_executable(ex, count + 1)
  end
end

def print_call_site(call_site, count)
  indent = '    ' * count

  case call_site
  when Rubinius::PolyInlineCache
    call_site.entries.each do |entry|
      next unless entry
      print_cache_entry(call_site, entry, count + 1)
    end
  when Rubinius::MonoInlineCache
    callee = call_site.method
    if callee.is_a? Rubinius::CompiledCode
      executable = call_site.executable
      scope = executable.scope
      puts "MonoInlineCache:"
      puts "  Caller: #{scope.module if scope}::#{executable.name} at #{call_site.location}"
      puts "  Callee: #{call_site.receiver_class}::#{call_site.name} at #{callee.file}:#{callee.defined_line}"
    end
    print_executable(callee, count + 1)
  when Rubinius::CallSite
  end
end

def print_cache_entry(call_site, entry, count)
  indent = '    ' * count
  callee = entry.method
  if callee.is_a? Rubinius::CompiledCode
    executable = call_site.executable
    scope = executable.scope
    puts "InlineCacheEntry:"
    puts "  Caller: #{scope.module if scope}::#{executable.name} at #{call_site.location}"
    puts "  Callee: #{entry.receiver_class}::#{call_site.name} at #{callee.file}:#{callee.defined_line}"
  end
  print_executable(callee, count + 1)
end

print_executable(m.executable, 0)
