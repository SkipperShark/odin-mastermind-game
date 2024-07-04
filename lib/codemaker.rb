require_relative "peg/code_peg_set"

# Represents a player that is the codemaker, contains logic and methods that
# describe what the codemaker can do, such as setting the secret code
class Codemaker
  include Utilities

  attr_reader :is_human

  def initialize(is_human)
    @is_human = is_human
    @secret = CodePegSet.new
  end

  def build_secret
    secret_done = false
    until secret_done
      secret.build
      secret_done = true if confirm_secret?
      reset_secret
    end
  end

  def generate_secret
    secret.generate
  end

  def show_secret
    puts "secret : #{secret}\n\n"
  end

  private

  attr_reader :secret

  def confirm_secret?
    user_confirmed? "Secret complete, would you like to confirm? (y/n)"
  end

  def reset_secret
    @secret.reset
  end
end
