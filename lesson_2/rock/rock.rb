require 'yaml'
MESSAGE = YAML.load_file('rock.yml')
option = nil
player_score = 0
computer_score = 0
OPTIONS = {
  "r" => "rock",
  "p" => "paper",
  "s" => "scissors",
  "sp" => "spock",
  "l" => "lizard"
}

# prompt
  def prompt(prompt_name)
    puts "=> #{prompt_name}"
  end

# win or lose logic
def did_player_win?(user_input, computer_input)
  # keys represents user_input, arrays represent computer_input
  winning_combinations_for_player = { 'p' => %w(r sp), 
                                      'r' => %w(s l),
                                      's' => %w(p l),
                                      'sp' => %w(r s),
                                      'l' => %w(l sp) }
  winning_combinations_for_player[user_input].include?(computer_input)
end
  
loop do
  # determining inputs for user and computer
  computer_option = OPTIONS.keys.sample
  loop do
    puts MESSAGE['Welcome']
    option = gets.chomp.downcase
    OPTIONS.include?(option) ? break : prompt("Try again:")
  end
  prompt("Player chose: #{OPTIONS[option]}")
  prompt("Computer chose: #{OPTIONS[computer_option]}")

  # computing round victor and displaying scoreboard
  if option == computer_option
    prompt("It's a tie!")
    next
  elsif did_player_win?(option, computer_option)
    prompt("One point for Player!")
    player_score += 1
  else
    prompt("One point for Computer!")
    computer_score += 1
  end
  puts
  score = <<-SCOREBOARD

          Scoreboard
        Player    |   Wins
        ----------------------
        Computer  |  #{computer_score}
        You       |  #{player_score}

  SCOREBOARD
  puts score

  # Determining winner and loser
  if player_score == 5
    prompt("Player Won!")
    puts score
    break
  elsif computer_score == 5
    prompt("Computer Won!")
    puts score
    break
  end

end

# goodbye!
prompt("Thank you for playing! Goodbye!")
