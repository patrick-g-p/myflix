Fabricator(:invitation) do
  recipients_email { Faker::Internet.email }
  recipients_name { Faker::Name.name }
  message { Faker::Lorem.paragraph }
end
