require 'yaml'

class Tracy
  def initialize
    @callers = Hash.new { |hash, key| hash[key] = [] }
    @trace = TracePoint.new(:call, :line) do |tp|
      case tp.event
      when :call
        key = [tp.method_id, tp.defined_class.name, tp.lineno, tp.path]
        @callers[key].push @current_location
      when :line
        @current_location = [tp.lineno, tp.path]
      end
    end
  end

  def start
    @trace.enable
  end

  def done
    @trace.disable
    IO.write('callsite-info.yml', YAML.dump(@callers))
  end
end
