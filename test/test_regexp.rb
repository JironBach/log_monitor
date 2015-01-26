reg = "error5.*match?"
if "error500 match?".match(/#{reg}/)
  puts "match"
else
  puts "not match"
end

