class KeyPeg
  COLOR_OPTIONS = %w[red white].freeze
  private_class_method :new
  attr_reader :color

  def initialize(color_option)
    @color = color_option
  end

  def self.full_match
    self.new("red")
  end

  def self.position_match
    self.new("white")
  end
end


# test = KeyPeg.full_match
test = KeyPeg.new("red")
puts test.color
