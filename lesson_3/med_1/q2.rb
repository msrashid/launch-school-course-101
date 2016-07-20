statement = statement.chars.to_a
letter_frequency = {}
statement.each {|letter| letter_frequency[letter] = statement.count(letter) unless letter == " "}
letter_frequency.sort