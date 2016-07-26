require "pry"
require 'yaml'
MESSAGE = YAML.load_file("tick.yml")
WIN_FORMULA = [[1, 2, 3], [1, 4, 7], [1, 5, 9], [5, 4, 6], [5, 2, 8],
               [5, 3, 7], [5, 1, 9], [9, 7, 8], [9, 3, 6], [9, 1, 5]].freeze

# Is the value read in a valid number between 1-9?
def valid_number?(number, possible_values)
  number <= 9 && number >= 1 && possible_values.include?(number.to_i)
end

def prompt(key)
  puts "==> #{MESSAGE[key]}"
end

def display_board(display_marks, continue = "yes")
  system 'clear' if continue == "yes"
  display_board = <<-DISPLAY
     |     |
  #{display_marks[1]}  |  #{display_marks[2]}  |  #{display_marks[3]}
_____|_____|_____
     |     |
  #{display_marks[4]}  |  #{display_marks[5]}  |  #{display_marks[6]}
_____|_____|_____
     |     |
  #{display_marks[7]}  |  #{display_marks[8]}  |  #{display_marks[9]}
     |     |
                     DISPLAY
  puts display_board
end

# Is there a winner?
def winner?(user_inputs)
  # Does the user have any of the winning values?
  WIN_FORMULA.each do |values|
    return true if user_inputs.include?(values[0]) &&
                   user_inputs.include?(values[1]) &&
                   user_inputs.include?(values[2])
  end
  false
end

# Should computer go for the win or save itself?
def computer_win_or_save(array, possible_values)
  WIN_FORMULA.each do |win_formula_line|
    win_value = win_formula_line - array
    next if win_value.size > 1
    return win_value[0] if possible_values.include?(win_value[0])
  end
  false
end

# What is the best move for computer?
def best_move_for_computer(player_array, computer_array, possible_values)
  defend = computer_win_or_save(player_array, possible_values)
  attack = computer_win_or_save(computer_array, possible_values)
  if attack
    attack
  elsif defend
    defend
  elsif possible_values.include?(5)
    5
  else
    possible_values.sample
  end
end

# Player choice and recording the results in an array.
def player_move(possible_values, player_array, display_marks)
  inputs_with_or = joiner(possible_values)
  puts "=> Choose a position to place a piece: #{inputs_with_or.join(', ')}"
  player_value = gets.chomp.to_i
  loop do
    break if valid_number?(player_value, possible_values)
    prompt("Invalid")
    prompt("First")
    player_value = gets.chomp.to_i
  end
  possible_values.delete(player_value)
  player_array.push(player_value)
  prompt("Playermove")
  display_marks[player_value] = "X"
end

# Calling methods for the best move and recording it in an array.
def computer_move(possible_values, display_marks,
                  computer_array = [], player_array = [])
  computer_value = best_move_for_computer(player_array, computer_array,
                                          possible_values)
  possible_values.delete(computer_value)
  computer_array.push(computer_value)
  prompt("Computermove")
  display_marks[computer_value] = "O"
  winner?(computer_array)
end

# The "or" extra challenge
def joiner(array_inputs)
  return array_inputs if array_inputs.size <= 1
  new_array_input = array_inputs.map { |x| x }
  new_array_input[-1] = "or" + " " + array_inputs[-1].to_s
  new_array_input
end

player_score = 0
computer_score = 0
tie = 0
computer_won = nil
prompt("Welcome")
prompt("Whofirst?")
# The main program .
loop do
  player_array = []
  computer_array = []
  possible_values = []
  display_marks = {}
  initial_display_marks = {}
  
  (1..9).each do |value|
    display_marks[value.to_i] = " "
    possible_values += [value]
    initial_display_marks[value.to_i] = value
  end

  display_board(initial_display_marks, "no")
  first_turn_input = gets.chomp
 
  loop do
    if first_turn_input.casecmp("y") == 0
      player_move(possible_values, player_array, display_marks)
      computer_won = computer_move(possible_values, display_marks,
                                   computer_array,  player_array)
    else
      computer_won = computer_move(possible_values, display_marks,
                                   computer_array, player_array)
      display_board(display_marks)
      unless computer_won || possible_values.empty?
        player_move(possible_values, player_array, display_marks)
      end
    end

    display_board(display_marks)
    # Who Won?
    if winner?(player_array)
      player_score += 1
      prompt("Win") if player_score == 5
      break
    elsif computer_won
      computer_score += 1
      prompt("Loss") if computer_score == 5
      break
    elsif possible_values.empty?
      prompt("Again")
      tie += 1
      break
    end
  end

  system 'clear'
  display_board(display_marks, "no")
  score = <<-SCORE

             RESULTS
 _____________________________________
|_____________________________________|
|    User        | Score              |
|    ---------------------            |
|    Player      | #{player_score}                  |
|    Computer    | #{computer_score}                  |
|    Tie         | #{tie}                  |
|_____________________________________|
|_____________________________________|


             SCORE

  puts score # Tallying up the score
  prompt("Whofirst?") if !(player_score == 5 || computer_score == 5)
  binding.pry
  next unless player_score == 5 || computer_score == 5
  player_score = 0
  computer_score = 0
  prompt("Play")
  puts
  play = gets.chomp.to_s
  break if play.casecmp("n") == 0 # Play again
  prompt("Welcome")
  prompt("Whofirst?")
end
