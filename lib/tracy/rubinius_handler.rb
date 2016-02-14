require 'yaml'

class Tracy
  class RubiniusHandler
    def process(executable)
      @callers = Hash.new { |hash, key| hash[key] = {} }
      @executables = {}
      process_executable(executable)
      IO.write('callsite-info.yml', YAML.dump(@callers))
    end

    private

    def process_executable(executable)
      return unless executable.is_a? Rubinius::CompiledCode
      return if @executables[executable]
      @executables[executable] = 1

      executable.call_sites.each do |call_site|
        process_call_site(call_site)
      end

      executable.child_methods.each do |ex|
        process_executable(ex)
      end
    end

    def process_call_site(call_site)
      case call_site
      when Rubinius::PolyInlineCache
        call_site.entries.each do |entry|
          next unless entry
          process_cache_entry(call_site, entry)
        end
      when Rubinius::MonoInlineCache
        process_mono_cache(call_site)
      when Rubinius::CallSite
      end
    end

    def process_mono_cache(call_site)
      callee = call_site.method
      process_data(call_site, callee, 'MonoInlineCache')
      process_executable(callee)
    end

    def process_cache_entry(call_site, entry)
      callee = entry.method
      process_data(call_site, callee, 'InlineCacheEntry')
      process_executable(callee)
    end

    def process_data(call_site, callee, entry_type)
      if callee.is_a?(Rubinius::CompiledCode) && callee.file =~ /tracy/
        @callers[callee_data(callee)][caller_data(call_site)] = 1
      end
    end

    def callee_data(callee)
      scope = callee.scope
      [callee.name, scope ? scope.module.to_s : '', callee.defined_line, callee.file]
    end

    def caller_data(call_site)
      executable = call_site.executable
      scope = executable.scope
      path, line = call_site.location.split(':')
      [executable.name, scope ? scope.module.to_s : '', line.to_i, path]
    end
  end
end

