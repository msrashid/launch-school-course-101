require 'yaml'
MG = YAML.load_file('calculator_messages.yml')
LANGUAGE = 'en'

def print(operation)
  puts "=> The result is #{operation}"
end

def messages(message, lang = 'en')
  MG[lang][message]
end

def prompt(key)
  message = messages(key, LANGUAGE)
  puts "=> #{message}" unless key.empty?
end

def valid_choice(x)
  if x == 1
    prompt('adding')
  elsif x == 2
    prompt('sub')
  elsif x == 3
    prompt('multiple')
  else
    prompt('divide')
  end
end

def valid_number?(x)
  if x =~ /0/
    true
  elsif x.to_f == 0
    false
  else
    true
  end
end

def operation_to_message(x)
  if x > 4 && x < 1
    valid_choice(x)
  else
    prompt('must')
  end
end
first = 0
second = 0
x = true

prompt('welcome')
name = ''

loop do
  name = gets.chomp
  if name.empty?
    prompt('name')
  else break
  end
end

puts "=> Hello #{name}."

loop do
  loop do
    prompt('first')
    first = gets.chomp
    if valid_number?(first)
      first = first.to_f
      break
    else
      prompt('hmm')
    end
  end
  loop do
    prompt('second')
    second = gets.chomp
    if valid_number?(second)
      second = second.to_f
      break
    else
      prompt('hmm')
    end
  end
  a = first + second
  b = first - second
  c = first * second
  d = first / second
  while x == true
    prompt('operator_prompt')
    operator = gets.chomp.to_i
    operation_to_message(operator)
    case operator
    when 1
      x = print(a)
    when 2
      x = print(b)
    when 3
      x = print(c)
    when 4
      x = print(d)
    end
  end
  prompt('again')
  z = gets.chomp
  break unless z.downcase.start_with?('y')
end
prompt('thanks')
