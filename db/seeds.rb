# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Book.count == 0
	Book.create!(name: 'Challfie Special' , required_points: '0', level: '0', tier: '0')
	Book.create!(name: 'Newbie I' , required_points: '0', level: '1', tier: '1')
	Book.create!(name: 'Newbie II' , required_points: '100', level: '2', tier: '1')
	Book.create!(name: 'Newbie III' , required_points: '300', level: '3', tier: '1')
	Book.create!(name: 'Apprentice I' , required_points: '300', level: '4', tier: '2')
	Book.create!(name: 'Apprentice II' , required_points: '300', level: '5', tier: '2')
	Book.create!(name: 'Apprentice III' , required_points: '300', level: '6', tier: '2')
	Book.create!(name: 'Master I' , required_points: '300', level: '7', tier: '3')
	Book.create!(name: 'Master II' , required_points: '300', level: '8', tier: '3')
	Book.create!(name: 'Master III' , required_points: '300', level: '9', tier: '3')
end