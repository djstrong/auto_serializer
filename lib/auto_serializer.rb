class AutoSerializer
  # Create file name based on class/method name and its constructor arguments. Try deserialize from this file, otherwise initialize object and serialize to file.
  def self.auto(klass_or_method, *arguments) #TODO methods
    name = create_name(klass_or_method, arguments)
    if File.exist? name
      File.open(name) do |file|
        return Marshal.load(file)
      end
    end

    if klass_or_method.instance_of? Class
      object = klass_or_method.new(*arguments)
    else
      object = method(klass_or_method).call(*arguments)
    end
    File.open(name, 'w') do |output|
      Marshal.dump(object, output)
    end
    return object
  end

  private
  # Create file name based on class/method name and its (constructor) arguments.
  def self.create_name(klass_or_method, arguments)
    '%s-%s.marshal' % [klass_or_method.to_s, arguments.map { |argument| argument.to_s.gsub('/', '_')[0..100] }.join(';')]
  end
end

