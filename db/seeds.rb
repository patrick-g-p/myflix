# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: "Futurama", description: "A pizza dilvery boy is flung into the year 3000! One of the best animated comedies ever made.", small_cover_url: "futurama.jpg")

Video.create(title: "South Park", description: "The legendary animated series by Matt Stone and Trey Parker.", small_cover_url: "south_park.jpg")

Video.create(title: "Family Guy", description: "An average comedy the you'll watch at 3am on Adult Swim when you can't sleep sometimes.", small_cover_url: "family_guy.jpg")

Video.create(title: "Monk", description: "That guy from Glaxy Quest is akward and solves mysteries.", small_cover_url: "monk.jpg", large_cover_url: "monk_large.jpg")
