require 'yaml'
MG = YAML.load_file('mortgage.yml')
LANGUAGE = 'en'
def language(line, lang = 'en')
  MG[lang][line]
end

def print(x)
  out = language(x, LANGUAGE)
  puts "=> #{out}"
end

def valid_number?(x)
  if x.to_s =~ /0/ && x.to_i >= 0
    return true
  elsif x.to_i == 0
  elsif x.to_f >= 0
    return true
  else
    print("valid")
  end
end

def valid_zero?(x)
  if x.to_s =~ /0/
    x.to_f <= 100 && x.to_f >= 0 ? (return true) : (return false)
  end
end

def valid_rate?(x)
  if valid_zero?(x) == true
    return true
  elsif x.to_i == 0
    print("valid")
  elsif x.to_f <= 100 && x.to_f >= 0
    return true
  else
    print("valid")
  end
end

def input(method)
  value = false
  variable = 1
  until value == true
    variable = gets.chomp.delete(",")
    value = method.call(variable)
  end
  variable
end
print("welcome")
j = 1
until j == 0
  name = gets.chomp
  if name.empty?
    print("validname")
  else
    puts "=> Welcome #{name}!"
    j = 0
  end
end
# amount
print("amount")
amount = input(method(:valid_number?)).to_f
# rate
print("rate")
rate = input(method(:valid_rate?)).to_f
print("minterest")
puts "#{(rate.to_f / 1200).round(6)}%"
# duration
print("duration")
duration = input(method(:valid_number?)).to_f
# months or years
print("time")
t = gets.chomp
value = false
until value == true
  if t.downcase.start_with?('m')
    t = "M"
    value = true
  elsif t.downcase.start_with?('y')
    t = "Y"
    duration *= 12
    value = true
  elsif t.to_i == 0
    puts "Enter 'M' or 'Y'"
    t = gets.chomp
  else 
    puts "Enter 'M' or 'Y'"
    t = gets.chomp
  end
end
# monthly payment
c = (rate.to_f / 1200)
l = ((amount * (c * ((1 + c)**duration))) / ((1 + c)**duration - 1)).round(0)
print("payment")
puts "$#{l}"
# remaining payment
print("remaining")
r = gets.chomp
value = false
until value == true
  if r.downcase.start_with?('y')
    print("months")
    p = input(method(:valid_number?)).to_f
    value = true
  elsif r.downcase.start_with?('n')
    break
  else
    puts "Enter 'Y' or 'N'"
  end
end
b = l * (duration - p)
string = duration - p
print("total")
puts string.to_s
print("balance")
puts "$#{b.round(0)}"
print("thanks")
