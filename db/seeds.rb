# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: 'user@example.com', password: '12345678')

5.times do |i|
	Patient.create(name: 'Mario', surname: 'Rossi', phoneno: "+39123456#{i}")
end

5.times do |i|
	p = Patient.create(name: 'Mario', surname: 'Rossi', phoneno: "+39123456#{i}")
	p.dialogs.create(user_message: "Salve utente, hai bisogno di qualcosa?")
	p.dialogs.create(patient_reply: "Si, avrei bisogno di un parere medico")
	p.dialogs.create(user_message: "Di che tipo?")
	p.dialogs.create(patient_reply: "Riguardo ai capelli")
	p.dialogs.create(user_message: "Che problema hai?")
	p.dialogs.create(patient_reply: "Le doppiepunte!!")
	p.dialogs.create(user_message: "Ho capito")
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
