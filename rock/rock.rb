require 'yaml'
MESSAGE = YAML.load_file('rock.yml')
option = "TO BE DETERMINED"
player = 0
computer = 0
options = {
  "r" => "rock",
  "p" => "paper",
  "s" => "scissors",
  "sp" => "spock",
  "l" => "lizard"
}

# prompt
loop do
  def prompt(prompt_name)
    puts "=> #{prompt_name}"
  end

  # win or lose logic
  def win_logic?(user_input, computer_input)
    win = %w(p r sp r s l s p l sp r s l p sp)
    true_false = false
    5.times do |x|
      true_false = (user_input == win[3 * x] &&
      (computer_input == win[3 * x + 1] || computer_input == win[3 * x + 2]))
      break if true_false
    end
    true_false
  end

  win_logic?("r", "s")
  win_logic?("s", "r")

  computer_option = options.keys.sample
  loop do
    puts MESSAGE['Welcome']
    option = gets.chomp.downcase
    options.include?(option) ? break : prompt("Try again:")
  end
  prompt("Player chose: #{options[option]}")
  prompt("Computer chose: #{options[computer_option]}")

  # computing round victor and displaying scoreboard
  if option == computer_option
    prompt("It's a tie!")
    next
  elsif win_logic?(option, computer_option)
    prompt("One point for Player!")
  else
    prompt("One point for Computer!")
  end
  puts
  win_logic?(option, computer_option) ? player += 1 : computer += 1
  score = <<-SCOREBOARD

          Scoreboard
        Player    |   Wins
        ----------------------
        Computer  |  #{computer}
        You       |  #{player}

  SCOREBOARD

  # Determining winner and loser
  if player == 5
    prompt("Player Won!")
    puts score
  elsif computer == 5
    prompt("Computer Won!")
    puts score
  end
  break if player == 5 || computer == 5
  puts score
end

# goodbye!
prompt("Thank you for playing! Goodbye!")
