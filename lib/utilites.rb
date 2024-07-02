# helper module for common functionalities
module Utilities
  def user_input
    gets.chomp.downcase.strip
  end

  def user_confirmed?(message = "Would you like to confirm? (y/n)")
    valid_choice = false
    until valid_choice == true
      puts message
      input = user_input
      case input
      when "y" then return true
      when "n" then return false
      else puts "I'm not sure what you mean, please try again"
      end
    end
  end
end
