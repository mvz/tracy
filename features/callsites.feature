Feature: Looking up callsites

  Scenario: Printing callsites of a method
    Given a file named "program.rb" with:
      """
      require 'tracy'

      tracy = Tracy.new
      tracy.start

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

      foo = Foo.new
      foo.baz

      bar = Bar.new foo
      bar.bar
      foo.baz

      otherfoo = OtherFoo.new
      otherfoo.baz

      blub

      tracy.done
      """
    When I run "ruby program.rb"
    And I run "callsites Foo#baz"
    Then the output should contain:
      """
      Foo#baz at program.rb:7 is called by
        <main> at program.rb:34
        Bar#bar at program.rb:24
        <main> at program.rb:38
        Object#blub at program.rb:30
      """