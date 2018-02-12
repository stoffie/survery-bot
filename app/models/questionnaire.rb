class Questionnaire < ApplicationRecord
	validates_uniqueness_of :title, message: 'Nome Questionario gia\' esistente. Scegliere un\'altro nome per favore.'
	has_many :questions
end
