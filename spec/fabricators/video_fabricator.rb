Fabricator(:video) do |f|
  f.title { Faker::Lorem.word }
  f.description { Faker::Lorem.paragraph }
end
