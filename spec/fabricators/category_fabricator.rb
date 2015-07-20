Fabricator(:category) do
  name { Faker::Lorem.words.join(" ") }
end
