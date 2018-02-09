# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: 'user@example.com', password: '12345678')

nametable = ["Giuseppe", 'Giovanni', 'Andrea', 'Roberto', 'Carlo']
surnametable = ['Giovanni', 'Andrea', 'Roberto', 'Carlo', 'Carli']

5.times do |i|
	Patient.create(name: nametable[i], surname: surnametable[i], phoneno: "+123456#{i}")
end

1.times do
	questionnaire = Questionnaire.create(title: 'Indagine sulla soddisfazione professionale')
	1.times do
		question = questionnaire.questions.create(text: 'Con quale frequenza ti è consentito di prendere decisioni indipendenti sul lavoro?')
		question.options.create(text: 'Sempre')
		question.options.create(text: 'Quasi sempre')
		question.options.create(text: 'Molto spesso')
		question.options.create(text: 'Spesso')
		question.options.create(text: 'Quasi mai')
		question.options.create(text: 'Mai')

		question = questionnaire.questions.create(text: ' Quanto sono ripetitivi i compiti del tuo lavoro?')
		question.options.create(text: 'Molto')
		question.options.create(text: 'Normale')
		question.options.create(text: 'Molto Poco')
		question.options.create(text: 'Poco')
	end
end

title = %Q(Sondaggio sulle attività culturali di comunità)
question_hash = {
	%Q(Pensi che la tua comunità locale sia socialmente "viva"?) => ["Si","No","Qualche volta"],
	%Q(Quanto spesso partecipi agli eventi culturali nella tua comunita'?) => ["Spesso","Qualche volta","Mai","Raramente"],
	%Q(Sei soddisfatto della promozione culturale nella tua area?) => ["Si","No"],
	%Q(Chi organizza la maggior parte degli eventi culturali nella tua area?) => ["La comunità", "Ditte locali o compagnie specifiche", "Persone specifiche"],
	%Q(Vengono mai organizzati concerti nella tua area?) => ["Mai","Raramente","Qualche volta","Spesso"]
}

questionnaire = Questionnaire.create(title: title)

question_hash.each { |key, value|
	question = questionnaire.questions.create(text: key)
	value.each { |e|
		question.options.create(text: e)
	}
}

campaign = Campaign.create(questionnaire: questionnaire)
Patient.all.each do |p|
	invite = campaign.invitations.create(patient: p)
	questionnaire.questions.each do |q|
		Answer.create(invitation: invite, question: q, text: q.options.first.text)
	end
end

p = Patient.create(name: 'Marian', surname: 'Diaconu', telegram_enabled: false, phoneno: '3405124016')
title = %Q(Sondaggio sulla sanita mentale)
question_hash = {
		%Q(Pensi che la tua comunità locale sia socialmente "viva"?) => ["Si","No","Qualche volta"],
		%Q(Quanto spesso partecipi agli eventi culturali nella tua comunita'?) => ["Spesso","Qualche volta","Mai","Raramente"],
		%Q(Sei soddisfatto della promozione culturale nella tua area?) => ["Si","No"],
		%Q(Chi organizza la maggior parte degli eventi culturali nella tua area?) => ["La comunità", "Ditte locali o compagnie specifiche", "Persone specifiche"],
		%Q(Vengono mai organizzati concerti nella tua area?) => ["Mai","Raramente","Qualche volta","Spesso"]
}

questionnaire = Questionnaire.create(title: title)

question_hash.each { |key, value|
	question = questionnaire.questions.create(text: key)
	value.each { |e|
		question.options.create(text: e)
	}
}

campaign = Campaign.create(questionnaire: questionnaire)
campaign.invitations.create(patient: p)

title = %Q(Impatto della matalttia sulla quotidianita')
question_hash = {
		%Q(Svolgi le normali attivita' quotidiane?) => ["Mai o raramente","Qualche volta","Spesso"],
		%Q(Partecipa ad attività culturali o di socializzazione (cinema, teatro, circoli ricreativi, associazioni, incontri di famiglia ecc.)?) => ["Mai o raramente","Qualche volta","Spesso"],
		%Q(Ti capita di sentirsi solo?) => ["Mai o raramente","Qualche volta","Spesso"],
		%Q(Pensa di aver perso interesse nei confronti del lavoro, delle attività di svago o del rapporto con gli altri?) => ["Mai o raramente","Qualche volta","Spesso"],
		%Q(Si preoccupa per questioni di poco conto?) => ["Mai o raramente","Qualche volta","Spesso"],
		%Q(Durante l'ultimo anno si è sentito triste, malinconico, depresso?) => ["Mai o raramente","Qualche volta","Spesso"],
		%Q(Ha mai dimenticato di assumere i farmaci?) => ["Si", "No"],
		%Q(E' indifferente agli orari in cui assume i farmaci?) => ["Si", "No"],
		%Q(Quando ti senti meglio ti capita di interrompere la terapia?) => ["Si", "No"],
		%Q(Quando ti senti peggio ti capita di interrompere la terapia?) => ["Si", "No"],
		%Q(Come valuti l'aderenza della tua dieta, per quanto riguarda le verdure?) => ["Scarsa", "Bassa","Moderata","Buona","Molto buona"],
		%Q(Come valuti l'aderenza della tua dieta, per quanto riguarda i legumi?) => ["Scarsa", "Bassa","Moderata","Buona","Molto buona"],
		%Q(Come valuti l'aderenza della tua dieta, per quanto riguarda la frutta?) => ["Scarsa", "Bassa","Moderata","Buona","Molto buona"],
		%Q(Come valuti l'aderenza della tua dieta, per quanto riguarda i formaggi?) => ["Scarsa", "Bassa","Moderata","Buona","Molto buona"],
		%Q(Come valuti l'aderenza della tua dieta, per quanto riguarda gli insaccati?) => ["Scarsa", "Bassa","Moderata","Buona","Molto buona"],
		%Q(Come valuti l'aderenza della tua dieta, per quanto riguarda il pesce?) => ["Scarsa", "Bassa","Moderata","Buona","Molto buona"],
		%Q(Come valuti l'aderenza della tua dieta, per quanto riguarda l'olio di oliva?) => ["Scarsa", "Bassa","Moderata","Buona","Molto buona"],
		%Q(Come valuti l'aderenza della tua dieta, per quanto riguarda l'olio di semi?) => ["Scarsa", "Bassa","Moderata","Buona","Molto buona"],
		%Q(Come valuti l'aderenza della tua dieta, per quanto riguarda il burro?) => ["Scarsa", "Bassa","Moderata","Buona","Molto buona"],
		%Q(Come valuti l'aderenza della tua dieta, per quanto riguarda il caffe'?) => ["Scarsa", "Bassa","Moderata","Buona","Molto buona"],
		%Q(Come valuti l'aderenza della tua dieta, per quanto riguarda il vino?) => ["Scarsa", "Bassa","Moderata","Buona","Molto buona"],
		%Q(Come valuti l'aderenza della tua dieta, per quanto riguarda la birra?) => ["Scarsa", "Bassa","Moderata","Buona","Molto buona"],
		%Q(Come valuti l'aderenza della tua dieta, per quanto riguarda i superalcolici?) => ["Scarsa", "Bassa","Moderata","Buona","Molto buona"],
		%Q(Hai fatto almeno mezz'ora di attivita' fisica leggera?) => ["Si","No"],
		%Q(Hai fatto almeno mezz'ora di attivita' fisica moderata?) => ["Si","No"],
		%Q(Hai fatto almeno mezz'ora di attivita' fisica intensa?) => ["Si","No"],

}

questionnaire = Questionnaire.create(title: title)

question_hash.each { |key, value|
	question = questionnaire.questions.create(text: key)
	value.each { |e|
		question.options.create(text: e)
	}
}
