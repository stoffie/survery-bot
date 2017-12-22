# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: 'user@example.com', password: '12345678')

5.times do
	questionnaire = Questionnaire.create(title: 'Indagine sulla soddisfazione professionale')
	5.times do
		question = questionnaire.questions.create(text: 'Con quale frequenza ti è consentito di prendere decisioni indipendenti sul lavoro?')
		question.options.create(text: 'Sempre')
		question.options.create(text: 'Quasi sempre')
		question.options.create(text: 'Molto spesso')
		question.options.create(text: 'Spesso')
		question.options.create(text: 'Quasi mai')
		question.options.create(text: 'Mai')

		question = questionnaire.questions.create(text: ' Quanto sono ripetitivi i compiti del tuo lavoro?')
		question.options.create(text: 'Sempre')
		question.options.create(text: 'Quasi sempre')
		question.options.create(text: 'Molto spesso')
		question.options.create(text: 'Spesso')
		question.options.create(text: 'Quasi mai')
		question.options.create(text: 'Mai')
	end
end
