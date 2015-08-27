# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Book.where("name = 'DailyChallenge'").count == 0
	Book.create!(name: 'DailyChallenge' , required_points: '0', level: '0', tier: '0', visible: '0', active: '1')
	#Daily Challenge
	daily_challenge_book = Book.find_by name:'DailyChallenge'
	daily_challenge_book.challenges.create(point: 0, description_en: 'Take a selfie with your own drawing of Challfie\'s logo', description_fr: 'Prendre un selfie avec son dessin du logo Challfie' , difficulty: 1)
	daily_challenge_book.challenges.create(point: 0, description_en: 'Take a selfie with today\'s lunch', description_fr: 'Prendre un selfie avec son repas du midi' , difficulty: 1)	
	daily_challenge_book.challenges.create(point: 0, description_en: 'Take a selfie showing what time you woke up today', description_fr: 'Prendre un selfie affichant l\'heure à laquelle tu t\'es réveillé aujourd\'hui' , difficulty: 1)
end

if Book.count == 0
	#Book.create!(name: 'Challfie Special' , required_points: '0', level: '0', tier: '0')
	Book.create!(name: 'Newbie I' , required_points: '0', level: '1', tier: '1')
	Book.create!(name: 'Newbie II' , required_points: '200', level: '2', tier: '1')
	Book.create!(name: 'Newbie III' , required_points: '600', level: '3', tier: '1')
	Book.create!(name: 'Apprentice I' , required_points: '1400', level: '4', tier: '2')
	Book.create!(name: 'Apprentice II' , required_points: '3000', level: '5', tier: '2')
	Book.create!(name: 'Apprentice III' , required_points: '6000', level: '6', tier: '2')
	Book.create!(name: 'Master I' , required_points: '10500', level: '7', tier: '3')
	Book.create!(name: 'Master II' , required_points: '16500', level: '8', tier: '3')
	Book.create!(name: 'Master III' , required_points: '25000', level: '9', tier: '3')

	#Newbie I Challenges
	newbie_one_book = Book.find_by name: 'Newbie I'
	newbie_one_book.challenges.create(point: 20, description_en: 'Take a selfie', description_fr: 'Prendre un selfie', difficulty: 1)
	newbie_one_book.challenges.create(point: 20, description_en: 'Take a selfie with your friends', description_fr: 'Prendre un selfie avec ses amis', difficulty: 1)
	newbie_one_book.challenges.create(point: 20, description_en: 'Take a mirror selfie', description_fr: 'Prendre un selfie avec un miroir', difficulty: 1)
	newbie_one_book.challenges.create(point: 40, description_en: 'Take a gym selfie', description_fr: 'Prendre un selfie à la salle de sport', difficulty: 2)
	newbie_one_book.challenges.create(point: 40, description_en: 'Take a selfie with your new haircut', description_fr: 'Prendre un selfie avec sa nouvelle coupe de cheveux', difficulty: 2)
	newbie_one_book.challenges.create(point: 40, description_en: 'Take a selfie during a party', description_fr: 'Prendre un selfie pendant une soirée', difficulty: 2)
	newbie_one_book.challenges.create(point: 60, description_en: 'Take a selfie with a complete stranger', description_fr: 'Prendre un selfie avec un inconnu', difficulty: 3)
	newbie_one_book.challenges.create(point: 60, description_en: 'Take a "I love Challfie" selfie', description_fr: 'Prendre un "J\'aime Challfie" selfie ', difficulty: 3)
	newbie_one_book.challenges.create(point: 80, description_en: 'Take a selfie showing your professor during a lecture', description_fr: 'Prendre un selfie montrant son professeur en plein cours', difficulty: 4)
	newbie_one_book.challenges.create(point: 100, description_en: 'Take a selfie with someone who is currently mad at you', description_fr: 'Prendre un selfie avec quelqu\'un d\'énervé contre toi', difficulty: 5)	

	#Newbie II Challenges
	newbie_two_book = Book.find_by name: 'Newbie II'
	newbie_two_book.challenges.create(point: 30, description_en: 'Take a selfie with your dad', description_fr: 'Prendre un selfie avec son père', difficulty: 1)
	newbie_two_book.challenges.create(point: 30, description_en: 'Take a selfie with your best friend', description_fr: 'Prendre un selfie avec son meilleur ami', difficulty: 1)
	newbie_two_book.challenges.create(point: 30, description_en: 'Take a selfie during sunset', description_fr: 'Prendre un selfie au coucher de soleil', difficulty: 1)
	newbie_two_book.challenges.create(point: 60, description_en: 'Take a drunk selfie', description_fr: 'Prendre un selfie en étant ivre', difficulty: 2)
	newbie_two_book.challenges.create(point: 60, description_en: 'Take a selfie post-workout', description_fr: 'Prendre un selfie après une séance de cardio/musculation', difficulty: 2)
	newbie_two_book.challenges.create(point: 60, description_en: 'Take a selfie with your boss or teacher', description_fr: 'Prendre un selfie avec son boss ou son professeur', difficulty: 2)
	newbie_two_book.challenges.create(point: 90, description_en: 'Take a selfie at a concert', description_fr: 'Prendre un selfie à un concert', difficulty: 3)
	newbie_two_book.challenges.create(point: 120, description_en: 'Take a selfie jumping in a pool', description_fr: 'Prendre un selfie en sautant dans une piscine', difficulty: 4)
	newbie_two_book.challenges.create(point: 120, description_en: 'Take a selfie wearing a costume in public', description_fr: 'Prendre un selfie en portant un costume en publique', difficulty: 4)
	newbie_two_book.challenges.create(point: 150, description_en: 'Take a skydiving selfie', description_fr: 'Prendre un selfie en saut en parachute', difficulty: 5)

	# Newbie III Challenges
	newbie_three_book = Book.find_by name: 'Newbie III'
	newbie_three_book.challenges.create(point: 40, description_en: 'Take a selfie with your mom', description_fr: 'Prendre un selfie avec sa mère', difficulty: 1)
	newbie_three_book.challenges.create(point: 40, description_en: 'Take a selfie with your boyfriend', description_fr: 'Prendre un selfie avec ton petit ami', difficulty: 1)
	newbie_three_book.challenges.create(point: 40, description_en: 'Take a selfie with your meal', description_fr: 'Prendre un selfie avec son repas', difficulty: 1)
	newbie_three_book.challenges.create(point: 80, description_en: 'Take a selfie with your pet', description_fr: 'Prendre un selfie avec son animal domestique', difficulty: 2)
	newbie_three_book.challenges.create(point: 80, description_en: 'Take a car selfie', description_fr: 'Prendre un selfie dans une voiture', difficulty: 2)
	newbie_three_book.challenges.create(point: 80, description_en: 'Take a selfie in a very ugly outfit', description_fr: 'Prendre un selfie dans une tenue atrocement moche', difficulty: 2)
	newbie_three_book.challenges.create(point: 120, description_en: 'Take a selfie with a dead bug', description_fr: 'Prendre un selfie avec un insecte mort', difficulty: 3)
	newbie_three_book.challenges.create(point: 120, description_en: 'Take a selfie with your team after a victory', description_fr: 'Prendre un selfie avec son équipe après une victoire', difficulty: 3)
	newbie_three_book.challenges.create(point: 160, description_en: 'Take a selfie on a helicopter', description_fr: 'Prendre un selfie dans un hélicoptère', difficulty: 4)
	newbie_three_book.challenges.create(point: 200, description_en: 'Take a selfie with a famous singer', description_fr: 'Prendre un selfie avec un chanteur connu', difficulty: 5)

	# Apprentice I Callenges
	apprentice_one_book = Book.find_by name: 'Apprentice I'
	apprentice_one_book.challenges.create(point: 50, description_en: 'Take a selfie with your sister', description_fr: 'Prendre un selfie avec sa soeur', difficulty: 1)
	apprentice_one_book.challenges.create(point: 50, description_en: 'Take a selfie with your girlfriend', description_fr: 'Prendre un selfie avec sa petite amie', difficulty: 1)
	apprentice_one_book.challenges.create(point: 50, description_en: 'Take a "duck face" selfie', description_fr: 'Prendre un "duck face" selfie', difficulty: 1)	
	apprentice_one_book.challenges.create(point: 100, description_en: 'Take a "stuck in traffic" selfie', description_fr: 'Prendre un selfie dans les bouchons', difficulty: 2)	
	apprentice_one_book.challenges.create(point: 100, description_en: 'Take a selfie at a basketball game', description_fr: 'Prendre un selfie à un match de basketball', difficulty: 2)
	apprentice_one_book.challenges.create(point: 150, description_en: 'Take a selfie on a plane', description_fr: 'Prendre un selfie dans un avion', difficulty: 3)
	apprentice_one_book.challenges.create(point: 150, description_en: 'Take a selfie while dancing', description_fr: 'Prendre un selfie en dansant', difficulty: 3)
	apprentice_one_book.challenges.create(point: 200, description_en: 'Take a selfie during a businesss meeting', description_fr: 'Prendre un selfie durant une réunion d\'affaires', difficulty: 4)	
	apprentice_one_book.challenges.create(point: 200, description_en: 'Take a selfie driving shirtless', description_fr: 'Prendre un selfie en conduisant torse nu', difficulty: 4)
	apprentice_one_book.challenges.create(point: 250, description_en: 'Take a selfie with your birthday cake', description_fr: 'Prendre un selfie avec son gâteau d\'anniversaire', difficulty: 5)

	# Apprentice II Challenges
	apprentice_two_book = Book.find_by name: 'Apprentice II'
	apprentice_two_book.challenges.create(point: 60, description_en: 'Take a selfie with your brother', description_fr: 'Prendre un selfie avec son frère', difficulty: 1)
	apprentice_two_book.challenges.create(point: 60, description_en: 'Take a selfie while brushing your teeth', description_fr: 'Prendre un selfie en se brossant les dents', difficulty: 1)
	apprentice_two_book.challenges.create(point: 60, description_en: 'Take a selfie before going out', description_fr: 'Prendre un selfie avant de sortir en soirée', difficulty: 1)
	apprentice_two_book.challenges.create(point: 120, description_en: 'Take a selfie at an american football game', description_fr: 'Prendre un selfie à un match de football américain', difficulty: 2)
	apprentice_two_book.challenges.create(point: 120, description_en: 'Take a selfie with your team after being defeated', description_fr: 'Prendre un selfie avec son équipe après une défaite', difficulty: 2)
	apprentice_two_book.challenges.create(point: 120, description_en: 'Take a selfie cooking', description_fr: 'Prendre un selfie en cuisinant', difficulty: 2)
	apprentice_two_book.challenges.create(point: 180, description_en: 'Take a selfie in front of a waterfall', description_fr: 'Prendre un selfie devant une cascade', difficulty: 3)
	apprentice_two_book.challenges.create(point: 180, description_en: 'Take a selfie eating something weird', description_fr: 'Prendre un selfie en mangeant quelque chose d\'étrange', difficulty: 3)
	apprentice_two_book.challenges.create(point: 240, description_en: 'Take a selfie during an exam', description_fr: 'Prendre un selfie pendant un examen', difficulty: 4)
	apprentice_two_book.challenges.create(point: 300, description_en: 'Take a selfie with a famous actor', description_fr: 'Prendre un selfie avec un acteur connu', difficulty: 5)

	# Apprentice III Challenges
	apprentice_three_book = Book.find_by name: 'Apprentice III'
	apprentice_three_book.challenges.create(point: 70, description_en: 'Take a "just woke up" selfie', description_fr: 'Prendre un selfie au réveil', difficulty: 1)
	apprentice_three_book.challenges.create(point: 70, description_en: 'Take a selfie with your favorite stuffed animal', description_fr: 'Prendre un selfie avec ton animal en peluche préféré', difficulty: 1)
	apprentice_three_book.challenges.create(point: 70, description_en: 'Take a "I ate too much" selfie', description_fr: 'Prendre un "J\'ai trop mangé" selfie', difficulty: 1)
	apprentice_three_book.challenges.create(point: 140, description_en: 'Take a selfie at a baseball game', description_fr: 'Prendre un selfie à un match de baseball', difficulty: 2)
	apprentice_three_book.challenges.create(point: 140, description_en: 'Take a selfie at a soccer game', description_fr: 'Prendre un selfie à un match de football', difficulty: 2)
	apprentice_three_book.challenges.create(point: 140, description_en: 'Take a selfie with a minion', description_fr: 'Prendre un selfie avec un minion', difficulty: 2)
	apprentice_three_book.challenges.create(point: 210, description_en: 'Take a selfie with your company\'s CEO', description_fr: 'Prendre un selfie avec le PDG de son entreprise', difficulty: 3)
	apprentice_three_book.challenges.create(point: 210, description_en: 'Take a selfie with a bug alive', description_fr: 'Prendre un selfie avec un insecte vivant', difficulty: 3)
	apprentice_three_book.challenges.create(point: 280, description_en: 'Take a selfie with someone you truly hate', description_fr: 'Prendre un selfie avec quelqu\'un que tu déteste sincèrement', difficulty: 4)
	apprentice_three_book.challenges.create(point: 350, description_en: 'Take a selfie with a politician', description_fr: 'Prendre un selfie avec un politicien', difficulty: 5)

	# Master I Challenges
	master_one_book = Book.find_by name: 'Master I'
	master_one_book.challenges.create(point: 80, description_en: 'Take a selfie pretending to be asleep', description_fr: 'Prendre un selfie en prétendant être endormi', difficulty: 1)
	master_one_book.challenges.create(point: 160, description_en: 'Take a selfie at a wedding', description_fr: 'Prendre un selfie à un mariage', difficulty: 2)
	
	master_one_book.challenges.create(point: 160, description_en: 'Take a selfie at the beach', description_fr: 'Prendre un selfie à la plage', difficulty: 2)
	master_one_book.challenges.create(point: 240, description_en: 'Take a selfie for Halloween', description_fr: 'Prendre un selfie pour Halloween', difficulty: 3)	
	master_one_book.challenges.create(point: 240, description_en: 'Take a selfie with the Eiffel Tower', description_fr: 'Prendre un selfie avec la Tour Eiffel', difficulty: 3)
	master_one_book.challenges.create(point: 240, description_en: 'Take a selfie doing community service', description_fr: 'Prendre un selfie en faisant du bénévolat', difficulty: 3)
	master_one_book.challenges.create(point: 320, description_en: 'Take a selfie with a cop', description_fr: 'Prendre un selfie avec un policer', difficulty: 4)
	master_one_book.challenges.create(point: 320, description_en: 'Take a selfie on top of a roller coaster', description_fr: 'Prendre un selfie en haut d\'une montagne russe', difficulty: 4)
	master_one_book.challenges.create(point: 400, description_en: 'Take a selfie in front of one of the seven wonders', description_fr: 'Prendre un selfie dans une des sept merveilles du monde', difficulty: 5)
	master_one_book.challenges.create(point: 400, description_en: 'Take a selfie with a dangerous animal', description_fr: 'Prendre un selfie avec un animal dangereux', difficulty: 5)

	# Master II Challenges
	master_two_book = Book.find_by name: 'Master II'	
	master_two_book.challenges.create(point: 180, description_en: 'Take a selfie showing off your muscle', description_fr: 'Prendre un selfie en montrant ses muscles', difficulty: 2)	
	master_two_book.challenges.create(point: 180, description_en: 'Take a selfie on a club podium', description_fr: 'Prendre un selfie sur un podium de boîte de nuit', difficulty: 2)
	master_two_book.challenges.create(point: 270, description_en: 'Take a selfie on a ski lift', description_fr: 'Prendre un selfie en téléphérique', difficulty: 3)
	master_two_book.challenges.create(point: 270, description_en: 'Take a selfie on a boat', description_fr: 'Prendre un selfie sur un bâteau', difficulty: 3)
	master_two_book.challenges.create(point: 270, description_en: 'Take a selfie with a snowman', description_fr: 'Prendre un selfie avec un bonhomme de neige', difficulty: 3)
	master_two_book.challenges.create(point: 360, description_en: 'Take a selfie holding a snake', description_fr: 'Prendre un selfie en portant un serpent', difficulty: 4)
	master_two_book.challenges.create(point: 360, description_en: 'Take a selfie while running a marathon', description_fr: 'Prendre un selfie en courant un marathon', difficulty: 4)
	master_two_book.challenges.create(point: 360, description_en: 'Take a selfie at graduation', description_fr: 'Prendre un selfie à la cérémonie de remise des diplômes', difficulty: 4)
	master_two_book.challenges.create(point: 450, description_en: 'Take a pregnant belly selfie', description_fr: 'Prendre un selfie enceinte', difficulty: 5)
	master_two_book.challenges.create(point: 450, description_en: 'Take a selfie with a famous soccer player', description_fr: 'Prendre un selfie avec un joueur de football professionnel', difficulty: 5)
	
	# Master III Challenges
	master_three_book = Book.find_by name: 'Master III'	
	master_three_book.challenges.create(point: 200, description_en: 'Take a selfie with your trophy or medal', description_fr: 'Prendre un selfie avec son trophée ou médaille', difficulty: 2)
	master_three_book.challenges.create(point: 200, description_en: 'Take a selfie singing at Karaoke', description_fr: 'Prendre un selfie en chantant dans un karaoké', difficulty: 2)
	master_three_book.challenges.create(point: 300, description_en: 'Take a selfie while skiing/snow boarding', description_fr: 'Prendre un selfie en train de skier/snowboarder', difficulty: 3)
	master_three_book.challenges.create(point: 300, description_en: 'Take a selfie at Disneyland', description_fr: 'Prendre un selfie à Disneyland', difficulty: 3)
	master_three_book.challenges.create(point: 400, description_en: 'Take a selfie with your friend\'s mom ', description_fr: 'Prendre un selfie avec la mère de son ami', difficulty: 4)
	master_three_book.challenges.create(point: 400, description_en: 'Take a selfie at the finish line of the marathon', description_fr: 'Prendre un selfie à la ligne d\'arrivé d\'un marathon', difficulty: 4)
	master_three_book.challenges.create(point: 400, description_en: 'Take a selfie on top of the Empire State Building', description_fr: 'Prendre un selfie sur l\'Empire State Building', difficulty: 4)
	master_three_book.challenges.create(point: 500, description_en: 'Take a scuba diving selfie', description_fr: 'Prendre un selfie en plongée sous-marine', difficulty: 5)
	master_three_book.challenges.create(point: 500, description_en: 'Take a selfie getting married', description_fr: 'Prendre un selfie à son propre mariage', difficulty: 5)
	master_three_book.challenges.create(point: 500, description_en: 'Take a selfie with a famous basketball player', description_fr: 'Prendre un selfie avec un joueur de basketball professionnel', difficulty: 5)
end