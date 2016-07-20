def factors(number)
  dividend = number
  divisors = []
  begin
    break if dividend == 0
    divisors << number / dividend if number % dividend == 0
    dividend -= 1
  end until dividend == 0
  divisors
end