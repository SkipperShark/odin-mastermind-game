# contains general methods used by multiple classes in the app
module Utilities
  def user_input
    gets.chomp.downcase.strip
  end
end
