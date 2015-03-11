module Accessors
  def attr_accessor_with_default name, *default, &block
    if(default.size >= 1)
      define_method name.to_sym do
        instance_variable_set(
          "@#{name}",
          default[0]) unless instance_variable_defined?("@#{name}")
        instance_variable_get("@#{name}")
      end
    elsif block_given?
      define_method name.to_sym do
        instance_variable_set(
          "@#{name}",
          instance_eval(&block)) unless instance_variable_defined?("@#{name}")
        instance_variable_get("@#{name}")
      end
    else
      raise "Must either provide a default value or a default code block"
    end
    define_method "#{name}=".to_sym do |value|
      instance_variable_set("@#{name}",value)
    end
  end
end
