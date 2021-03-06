# Fun with tracing

A set of experiments to investigate the possibility of using tracing
information gathered during, e.g., the running of a test suite to aid in
refactoring.

## Installing

    gem install tracy

If the gem is not installed, you should run the commands listed below using
`bundle exec`.

## Gathering caller info

Running `ruby experiment.rb` will generate `callsite-info.yml` containing a
list of callers for each method in `experiment.rb`.

## Showing caller info

The `callsites` script simply fetches info from `callsites-info.yml`. The
following will display callers of the method defined on line 7 of
`experiment.rb`:

    callsites experiment.rb:7

Alternatively, you can fetch call sites for a method by name like so:

    callsites Foo#baz

## Renaming methods

The `rename-method.rb` script performs a simple informed method renaming. It
will only rename methods on the caller locations found in `callsites-info.yml`.

Because this script currently does a simple string replace on the listed lines,
it could get confused if the method name occurs more than once on the same
line. Therefore, it aborts if this happens, rather than accidentally renaming
the wrong thing.

The following example will rename the method `Foo#baz`, but not `OtherFoo#baz`:

    ruby rename-method.rb experiment.rb:17 baz foodeldoo

## Problems

Gathering information like this is currently excruciatingly slow in real-world
projects.
