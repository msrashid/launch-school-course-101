require "pry"
require "yaml"
MESSAGE = YAML.load_file("jack.yml")

# Cards
win_algorithm = { "Jack" => 10,
                  "Queen" => 10,
                  "King" => 10,
                  :Ace => [1, 11] }

SUITS = ["Hearts", "Spades", "Clubs", "Diamonds"].freeze
(2..10).each { |value| win_algorithm[value.to_s] = value }
WIN = win_algorithm

# Prompt with "=>"
def prompt(msg)
  puts "=> #{msg}"
end

# Computing the random hand and calling suits to get corresponding suit.
def random_hand(sum, hand, iteration, prompt, total_prompts)
  iteration.times do
    hand += [WIN.keys.sample]
    sum = (hand.last == :Ace ? sum + 11 : sum + WIN[hand[-1]])
  end
  hand.each do |value|
    if sum > 21 && value == :Ace
      hand[hand.index(:Ace)] = "Ace"
      sum -= 10
    end
  end
  hand_prompt_with_suits(hand.last(iteration), total_prompts, prompt)
  [sum, hand]
end

# Adding suits to the cards.
def hand_prompt_with_suits(hand, total_prompts, prompt)
  new_prompt = []
  hand.each do |card|
    loop do
      new_prompt = ["#{card} of #{SUITS.sample}"]
      next if total_prompts.include?(new_prompt)
      break
    end
    total_prompts << new_prompt
    prompt << new_prompt
  end
  prompt.flatten!
end

# Who won?
def winner(first_sum, second_sum, default)
  (first_sum == default || second_sum > default || first_sum > second_sum) &&
    !(first_sum > default)
end

# Creating the special hand prompt
def create_hand_prompt(hand, special_case)
  hand.each_with_index do |card, index|
    if special_case
      (print " and ") if index == hand.size - 1
      print card
      break if index == hand.size - 1
      print hand.size == 2 ? "" : ", "
    else
      print "#{card} and Unknown Card"
      break
    end
  end
end

# Displaying the hand
def display_hand(hand, user, have_or_has, special_case = true)
  print "=> #{user} #{have_or_has}: "
  create_hand_prompt(hand, special_case)
  puts
end

loop do
  # New game and refresh.
  system 'clear'
  computer_running_total = 0
  player_running_total = 0
  puts MESSAGE["welcome"]
  answer = gets.chomp
  default = 21
  if answer.casecmp("change") == 0 ? true : false
    loop do
      prompt("Type in the new winning score")
      default = gets.chomp.to_i
      break if default == default.to_i.to_s.to_i
      prompt("Please type in a valid number.")
    end
  end

  loop do
    # New round and refresh
    system 'clear'
    player_sum = 0
    computer_sum = 0
    player_hand = []
    computer_hand = []
    player_hand_prompt = []
    computer_hand_prompt = []
    total_prompts = []
    computer_sum, computer_hand = random_hand(computer_sum, computer_hand, 2,
                                              computer_hand_prompt,
                                              total_prompts)
    player_sum, player_hand = random_hand(player_sum, player_hand, 2,
                                          player_hand_prompt, total_prompts)

    # Player round
    loop do
      display_hand(computer_hand_prompt, "Computer", "has", false)
      display_hand(player_hand_prompt, "You", "have")
      puts "=> Player's Total: #{player_sum}"
      break if player_sum >= default
      prompt("Hit or stay? Enter S to STAY any other key to HIT.")
      answer = gets.chomp
      if answer.casecmp("S") == 0
        puts "=> You have chosen to stay"
        break if answer.casecmp("S") == 0
      else
        puts "=> You have chosen to hit"
      end
      player_sum, player_hand = random_hand(player_sum, player_hand, 1,
                                            player_hand_prompt, total_prompts)
    end

    # Computer round.
    loop do
      break if computer_sum >= (default - 4) || player_sum > default
      computer_sum, computer_hand = random_hand(computer_sum, computer_hand, 1,
                                                computer_hand_prompt,
                                                total_prompts)
      display_hand(computer_hand_prompt, "Computer", "has", 1)
      display_hand(player_hand_prompt, "You", "have")
    end

    # Did player or computer win the round?
    system 'clear'
    if computer_sum == player_sum
      prompt("Tie. No points awarded.")
    elsif winner(computer_sum, player_sum, default)
      prompt("Computer Wins The Round!")
      computer_running_total += 1
    else
      prompt("Player Wins The Round!")
      player_running_total += 1
    end

    prompt("BLACKJACK!") if player_sum == default || computer_sum == default
    prompt("BUST!") if player_sum > default || computer_sum > default
    puts "------------------------------------"
    display_hand(computer_hand_prompt, "Computer", "has")
    display_hand(player_hand_prompt, "You", "have")
    puts
    prompt("Computer's Final Card Total: #{computer_sum}")
    prompt("Player's Final Card Total: #{player_sum}")
    prompt("Computer's Running Total Score: #{computer_running_total}")
    prompt("Player's Running Total Score: #{player_running_total}")
    puts "------------------------------------"

    # Did player or computer win the game? Also play new round?
    break if player_running_total == 5 || computer_running_total == 5
    puts "=> Play next round? Enter N to end. Press any other key to continue."
    answer = gets.chomp
    break if answer.casecmp("N") == 0
  end

  # Win game prompt and play again?
  if player_running_total == 5
    prompt("PLAYER WINS THE GAME!!! CONGRATULATIONS")
  elsif computer_running_total == 5
    prompt("Player lost the game. Computer wins.")
  end
  prompt("Play new game? Enter N to end. Press any other key to continue.")
  answer = gets.chomp
  break if answer.casecmp("N") == 0
end
