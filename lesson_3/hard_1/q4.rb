def random_uuid
  uuid = []
  sections = [8, 4, 4, 4, 12]
  sections.each do |x|
  	placeholder = ''
    x.times {|iteration| placeholder = ([rand(10).to_s, ('a'..'f').to_a.sample].sample) + placeholder}
    uuid += [placeholder]
  end
  uuid = uuid.join("-")
end

random_uuid






