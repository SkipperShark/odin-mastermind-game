class MyClass
  @@class_variable = 0

  # Getter method for class variable
  # def self.class_variable
  #   @@class_variable
  # end

  # # Setter method for class variable
  # def self.class_variable=(value)
  #   @@class_variable = value
  # end

  # Alternatively, you can use attr_accessor:
  attr_accessor :class_variable
end

# Using accessor methods for class variable
puts MyClass.class_variable  # Output: 0
MyClass.class_variable = 10
puts MyClass.class_variable  # Output: 10
