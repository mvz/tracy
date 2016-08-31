Design
======

Take the following Ruby code:

    class Foo
      def bar
      end
    end

    class Bar
      def bar
      end
    end

    foo = Foo.new
    bar = Bar.new

    foo.bar
    bar.bar

If we say: rename method Foo#bar, defined on line 2, this affects only lines 2
and 14. On the other hand, if there is code like this:

    [foo, bar].each &:bar

We **must** rename both Foo#bar and Bar#bar.

How?

Ingredients:
* Detect all sites
* Rename method

1. Look at the line. Does it defined the method?
2. Dind call sites for the method (based on test runs).
3. Find other methods that get called there with the same name.
    -> Any others?
      * Defined by self? Ask if all should be renamed.
      * Defined elsewhere? We can't do anything.
    -> Only this?
      * Go ahead!
4. Do the rename at definition and call sites.

Alternative method: Traditional Refactoring


1. Modify code:

        class Foo
          def new_name
            # original implementation
          end

          def bar
            emit 'call site'
          end
        end

2. Run tests, finds call sites.
3. At call site:
  * Call bar but log usage.
4. Run tests, find callees.
5. Or: use this:

        if obj.is_a? Foo
          obj.new_name
        else
          obj.bar # <- Track this somehow
        end

6. Combine:
  * Use callee dat to find tests to run
  * Preform as much refactoring as can be done safely
  * Run tests
  * Remove unused leftovers

        class Foo
          def blub
            # ...
          end

          def bar
            blub
          end
        end

        # ...

        if obj.is_a? Foo
          obj.blub
        else
          obj.foo
        end

7. Remove uncalled code!
