class Tracy
  class RubiniusHandler
    EXECUTABLES = {}

    def print_executable(executable)
      return unless executable.is_a? Rubinius::CompiledCode
      return if EXECUTABLES[executable]
      EXECUTABLES[executable] = 1

      executable.call_sites.each do |call_site|
        print_call_site(call_site)
      end

      executable.child_methods.each do |ex|
        print_executable(ex)
      end
    end

    def print_call_site(call_site)
      case call_site
      when Rubinius::PolyInlineCache
        call_site.entries.each do |entry|
          next unless entry
          print_cache_entry(call_site, entry)
        end
      when Rubinius::MonoInlineCache
        print_mono_cache(call_site)
      when Rubinius::CallSite
      end
    end

    def print_mono_cache(call_site)
      callee = call_site.method
      print_data(call_site, callee, 'MonoInlineCache')
      print_executable(callee)
    end

    def print_cache_entry(call_site, entry)
      callee = entry.method
      print_data(call_site, callee, 'InlineCacheEntry')
      print_executable(callee)
    end

    def print_data(call_site, callee, entry_type)
      if callee.is_a?(Rubinius::CompiledCode) && callee.file =~ /tracy/
        puts "#{entry_type}:"
        p caller_data(call_site)
        p callee_data(callee)
      end
    end

    def callee_data(callee)
      scope = callee.scope
      [callee.name, scope ? scope.module : '', callee.defined_line, callee.file]
    end

    def caller_data(call_site)
      executable = call_site.executable
      scope = executable.scope
      path, line = call_site.location.split(':')
      [executable.name, scope ? scope.module : '', line.to_i, path]
    end
  end
end

