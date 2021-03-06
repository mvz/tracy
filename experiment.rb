# frozen_string_literal: true

require "tracy"

tracy = Tracy.new
tracy.start

class Foo
  def baz
    puts "baz"
  end
end

class OtherFoo
  def baz
    puts "this is not the original baz"
  end
end

class Bar
  def initialize(foo)
    @foo = foo
  end

  def bar
    @foo.baz
  end
end

def blub
  puts "Blub"
  Foo.new.baz
end

foo = Foo.new
foo.baz

bar = Bar.new foo
bar.bar
foo.baz

otherfoo = OtherFoo.new
otherfoo.baz

blub

tracy.done
