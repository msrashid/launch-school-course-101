require 'yaml'
MESSAGE = YAML.load_file("tick.yml")
player_win = 0
computer_win = 0
tie = 0
computer_won = nil
win_formula = [[1, 2, 3], [1, 4, 7], [1, 5, 9], [5, 4, 6], [5, 2, 8],
               [5, 3, 7], [5, 1, 9], [9, 7, 8], [9, 3, 6], [9, 1, 5]]
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
def winner?(user_inputs, win_formula)
  # Does the user have any of the winning values?
  win_formula.each do |values|
    return true if user_inputs.include?(values[0]) &&
                   user_inputs.include?(values[1]) &&
                   user_inputs.include?(values[2])
  end
  false
end

# Should computer go for the win or save itself?
def computer_win_or_save(array, win_formula, possible_values)
  win_formula.each do |win_formula_iteration|
    win_value = win_formula_iteration - array
    next if win_value.size > 1
    return win_value[0] if possible_values.include?(win_value[0])
  end
  false
end

# What is the best move for computer?
def best_move_for_computer(player_array, computer_array,
                           win_formula, possible_values)
  defend = computer_win_or_save(player_array, win_formula, possible_values)
  attack = computer_win_or_save(computer_array, win_formula, possible_values)
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
def computer_move(possible_values, win_formula, display_marks,
                  computer_array = [], player_array = [])
  computer_value = best_move_for_computer(player_array, computer_array,
                                          win_formula, possible_values)
  possible_values.delete(computer_value)
  computer_array.push(computer_value)
  prompt("Computermove")
  display_marks[computer_value] = "O"
  winner?(computer_array, win_formula)
end

# The "or" extra challenge
def joiner(array_inputs)
  return array_inputs if array_inputs.size <= 1
  new_array_input = array_inputs.map { |x| x }
  new_array_input[-1] = "or" + " " + array_inputs[-1].to_s
  new_array_input
end

# The main program .
loop do
  player_array = []
  computer_array = []
  possible_values = []
  display_marks = {}
  (1..9).each do |value|
    display_marks[value.to_i] = value.to_s
    possible_values += [value]
  end
  display_board(display_marks, "no")
  prompt("Welcome")
  prompt("Whofirst?")
  who_is_first = gets.chomp
  loop do
    if who_is_first.casecmp("y") == 0
      player_move(possible_values, player_array, display_marks)
      computer_won = computer_move(possible_values, win_formula, display_marks,
                                   computer_array,  player_array)
    else
      computer_won = computer_move(possible_values, win_formula, display_marks,
                                   computer_array, player_array)
      display_board(display_marks)
      unless computer_won || possible_values.empty?
        player_move(possible_values, player_array, display_marks)
      end
    end
    display_board(display_marks)
    # Who Won?
    if winner?(player_array, win_formula)
      player_win += 1
      prompt("Win") if player_win == 5
      break
    elsif computer_won
      computer_win += 1
      prompt("Loss") if computer_win == 5
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
|    Player      | #{player_win}                  |
|    Computer    | #{computer_win}                  |
|    Tie         | #{tie}                  |
|_____________________________________|
|_____________________________________|


             SCORE
  puts score # Tallying up the score
  next unless player_win == 5 || computer_win == 5
  player_win = 0
  computer_win = 0
  prompt("Play")
  puts
  play = gets.chomp.to_s
  break if play.casecmp("n") == 0 # Play again
end
