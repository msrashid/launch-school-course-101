require 'yaml'
MG = YAML.load_file('mortgage.yml')

amount = "To Be Determined"
duration = "To Be Determined"
rate = "To Be Determined"

# print format
def read(x)
  read = MG["en"][x]
  puts "=> #{read}"
end

# valid number (0 and above)
def valid_number?(x)
  if !(x =~ /[a-zA-Z]/) && x =~ /0/ && x.to_f == 0
    false
  elsif x.to_f >= 1 && !(x =~ /[a-zA-Z]/)
    true
  else
    false
  end
end

# welcome
read("welcome")

# amount
loop do
  read("amount")
  amount = gets.chomp.delete("$")
  break if valid_number?(amount) ? true : read("valid")
end

# duration
loop do
  read("duration")
  duration = gets.chomp
  break if valid_number?(duration) ? true : read("valid")
end

# rate
loop do
  read("rate")
  rate = gets.chomp
  valid_rate = valid_number?(rate) && rate.to_f < 100
  break if valid_rate ? true : read("valid")
end

amount = amount.to_f
duration = duration.to_f * 12
adjusted_rate = (rate.to_f / 1200)

# monthly payment
payment = ((amount * (adjusted_rate * ((1 + adjusted_rate)**duration))) /
                  ((1 + adjusted_rate)**duration - 1))
read("payment")
puts "$#{payment.round(2)}"

# goodbye
print("thanks")
