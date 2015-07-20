Fabricator(:review) do |f|
  f.rating { rand(1..5) }
  f.body { Faker::Lorem.paragraph }
end
