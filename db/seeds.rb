# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Book.count == 0
	Book.create!(name: 'Newbie I' , required_points: '0', level: '1')
	Book.create!(name: 'Newbie II' , required_points: '100', level: '2')
	Book.create!(name: 'Newbie III' , required_points: '300', level: '3')
end