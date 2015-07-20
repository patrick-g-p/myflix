Fabricator(:invitation) do |f|
  f.recipients_email { Faker::Internet.email }
  f.recipients_name { Faker::Name.name }
  f.message { Faker::Lorem.paragraph }
end
