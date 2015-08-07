# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = []

%w[Action Animated Comedy Comedy-drama Drama Documentary Horror].each do |category|
  categories << Category.find_or_create_by(name: category)
end

Video.create!(title: "Family Guy",
             description: "An average comedy that you'll watch at 3am on Adult Swim when you can't sleep.",
             small_cover: File.open(File.join(Rails.root, 'app/assets/images/family_guy.jpg')),
             large_cover: File.open(File.join(Rails.root, 'app/assets/images/family_guy_large.jpg')),
             category: categories[1])

Video.create!(title: "Futurama",
             description: "A pizza dilvery boy is flung into the year 3000! One of the best animated comedies ever made.",
             small_cover: File.open(File.join(Rails.root, 'app/assets/images/futurama.jpg')),
             large_cover: File.open(File.join(Rails.root, 'app/assets/images/futurama_large.jpg')),
             category: categories[1])

Video.create!(title: "South Park",
             description: "The legendary animated series by Matt Stone and Trey Parker.",
             small_cover: File.open(File.join(Rails.root, 'app/assets/images/south_park.jpg')),
             large_cover: File.open(File.join(Rails.root, 'app/assets/images/south_park_large.jpg')),
             category: categories[1])

Video.create!(title: "Archer",
              description: "LANAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!!!",
              small_cover: File.open(File.join(Rails.root, 'app/assets/images/archer.jpg')),
              large_cover: File.open(File.join(Rails.root, 'app/assets/images/archer_large.jpg')),
              category: categories[1])

Video.create!(title: "Bob's Burgers",
              description: "A hysterical comedy about a family and their burger joint.",
              small_cover: File.open(File.join(Rails.root, 'app/assets/images/bobs_burgers.jpg')),
              large_cover: File.open(File.join(Rails.root, 'app/assets/images/bobs_burgers_large.jpg')),
              category: categories[1])

Video.create!(title: "Batman Beyond",
              description: "Future Batman with the quick witted humor of Spiderman. What's not awesome about that?",
              small_cover: File.open(File.join(Rails.root, 'app/assets/images/batman_beyond.jpg')),
              large_cover: File.open(File.join(Rails.root, 'app/assets/images/batman_beyond_large.jpg')),
              category: categories[1])

Video.create!(title: "Justice League Unlimited",
                    description: "The pinnacle of the DC animated universe.",
                    small_cover: File.open(File.join(Rails.root, 'app/assets/images/jlu.jpg')),
                    large_cover: File.open(File.join(Rails.root, 'app/assets/images/jlu_large.jpg')),
                    category: categories[1])

Video.create!(title: "Monk",
             description: "That guy from Glaxy Quest is akward and solves mysteries.",
             small_cover: File.open(File.join(Rails.root, 'app/assets/images/monk.jpg')),
             large_cover: File.open(File.join(Rails.root, 'app/assets/images/monk_large.jpg')),
             category: categories[3])

firefly = Video.create!(title: "Firefly",
              description: "A space western by the magnificent Joss Whedon. There's only one season,  we're just going to break it to you now.",
              small_cover: File.open(File.join(Rails.root, 'app/assets/images/firefly.jpg')),
              large_cover: File.open(File.join(Rails.root, 'app/assets/images/firefly_large.jpg')),
              category: categories[0])

7.times {Fabricate(:review, creator: Fabricate(:user), video: firefly )}
