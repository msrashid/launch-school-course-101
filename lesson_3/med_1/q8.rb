def titleize(string)
 string.split(" ").each {|word| word.capitalize!}.join(" ")
end

titleize("Hello my name is shahriar")