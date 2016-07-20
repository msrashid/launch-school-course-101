def is_a_number? (word)
  word.to_i.to_s == word
end

def dot_separated_ip_address?(input_string)
  dot_separated_words = input_string.split(".")
  return false if dot_separated_words.size != 4
  dot_separated_words.each{|word| return false unless is_a_number?(word)}
  return true
end