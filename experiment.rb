@callers = {}
trace = TracePoint.new(:call, :line) do |tp|
  case tp.event
  when :call
    key = [tp.method_id, tp.defined_class, tp.lineno, tp.path]
    @callers[key] ||= []
    @callers[key].push @current_location
  when :line
    @current_location = [tp.lineno, tp.path]
  end
end

trace.enable

class Foo
  def foo
    puts 'bar'
  end
end

class Bar
  def initialize foo
    @foo = foo
  end

  def bar
    @foo.foo
  end
end

foo = Foo.new
foo.foo

bar = Bar.new foo
bar.bar; foo.foo

trace.disable

p @callers
