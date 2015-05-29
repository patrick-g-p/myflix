# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

%w[Action Animated Comedy Documentary Horror].each do |category|
  Category.find_or_create_by(name: category)
end

Video.create!(title: "Futurama",
             description: "A pizza dilvery boy is flung into the year 3000! One of the best animated comedies ever made.",
             small_cover_url: "futurama.jpg",
             category_id: 2)

Video.create!(title: "South Park",
             description: "The legendary animated series by Matt Stone and Trey Parker.",
             small_cover_url: "south_park.jpg",
             category_id: 2)

Video.create!(title: "Family Guy",
             description: "An average comedy that you'll watch at 3am on Adult Swim when you can't sleep.",
             small_cover_url: "family_guy.jpg",
             category_id: 2)

Video.create!(title: "Monk",
             description: "That guy from Glaxy Quest is akward and solves mysteries.",
             small_cover_url: "monk.jpg",
             large_cover_url: "monk_large.jpg",
             category_id: 3)

Video.create!(title: "Firefly",
                  description: "A space western by the magnificent Joss Whedon. There's only one season,  we're just going to break it to you now.",
                  small_cover_url: "firefly.jpg",
                  large_cover_url: "firefly_large.jpg",
                  category_id: 1)
