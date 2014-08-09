require 'yaml'
@callers = {}
trace = TracePoint.new(:call, :line) do |tp|
  case tp.event
  when :call
    key = [tp.method_id, tp.defined_class.name, tp.lineno, tp.path]
    @callers[key] ||= []
    @callers[key].push @current_location
  when :line
    @current_location = [tp.lineno, tp.path]
  end
end

trace.enable

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

foo = Foo.new
foo.baz

bar = Bar.new foo
bar.bar
foo.baz

otherfoo = OtherFoo.new
otherfoo.baz

trace.disable
IO.write('callsite-info.yml', YAML.dump(@callers))