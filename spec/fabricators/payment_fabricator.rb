Fabricator(:payment) do |f|
  f.amount { 999 }
  f.reference_id { Faker::Lorem.word }
end
