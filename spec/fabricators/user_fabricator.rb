Fabricator(:user) do
  full_name { Faker::Name.name }
  email { Faker::Internet.email }
  password { "hunter" }
  active true
end

Fabricator(:admin, from: :user) do
  admin true
end
