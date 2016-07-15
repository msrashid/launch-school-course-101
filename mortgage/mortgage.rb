require 'yaml'
MESSAGE = YAML.load_file('mortgage.yml')

amount = "To Be Determined"
duration = "To Be Determined"
rate = "To Be Determined"

# print format
def prompt(prompt_name)
  read = MESSAGE["en"][prompt_name]
  puts "=> #{read}"
end

# valid number (0 and above)
def valid_number?(number)
  if !(number =~ /[a-zA-Z]/) && number =~ /0/ && number.to_f == 0
    false
  elsif number.to_f >= 1 && !(number =~ /[a-zA-Z]/)
    true
  else
    false
  end
end

# welcome
prompt("welcome")

# amount
loop do
  prompt("amount")
  amount = gets.chomp.delete("$")
  break if valid_number?(amount) ? true : prompt("valid")
end

# duration
loop do
  prompt("duration")
  duration = gets.chomp
  break if valid_number?(duration) ? true : prompt("valid")
end

# rate
loop do
  prompt("rate")
  rate = gets.chomp
  valid_rate = valid_number?(rate) && rate.to_f < 100
  break if valid_rate ? true : prompt("valid")
end

amount = amount.to_f
duration = duration.to_f * 12
adjusted_rate = (rate.to_f / 1200)

# monthly payment
payment = ((amount * (adjusted_rate * ((1 + adjusted_rate)**duration))) /
                  ((1 + adjusted_rate)**duration - 1))
prompt("payment")
puts "$#{payment.round(2)}"

# goodbye
print("thanks")
