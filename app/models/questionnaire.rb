class Questionnaire < ApplicationRecord
	has_many :questions
	validates_uniqueness_of :title, message: 'Nome Questionario gia\' esistente. Scegliere un\'altro nome per favore.'
end
