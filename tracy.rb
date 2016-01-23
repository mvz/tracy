require 'yaml'

class Tracy
  def initialize
    @callers = Hash.new { |hash, key| hash[key] = [] }
    @trace = TracePoint.new(:call, :line) do |tp|
      case tp.event
      when :call
        @callers[data_array(tp)].push @current_location
      when :line
        @current_location = data_array(tp)
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

  private

  def data_array(trace_point)
    klass = trace_point.defined_class
    [trace_point.method_id, klass ? klass.name : '', trace_point.lineno, trace_point.path]
  end
end
