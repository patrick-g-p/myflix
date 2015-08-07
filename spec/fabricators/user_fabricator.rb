Fabricator(:user) do |f|
  f.email { Faker::Internet.email }
  f.password { Faker::Lorem.characters(7) }
  f.full_name { Faker::Name.name }
end

Fabricator(:admin, from: :user) do
  role { 'admin' }
end
