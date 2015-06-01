Fabricator(:user) do
  email {Faker::Internet.email}
  password {Faker::Lorem.characters(7)}
  full_name {Faker::Name.name}
end
