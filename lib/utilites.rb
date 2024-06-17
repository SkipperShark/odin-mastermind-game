module Utilities

  def self.user_input
    gets.chomp.downcase.lstrip.rstrip
  end
end
