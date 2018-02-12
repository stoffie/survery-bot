class Question < ApplicationRecord
	belongs_to :questionnaire
	has_many :options
	enum q_type: [:multiple_choice, :yes_no, :numerical] # just numbers inside the db
	validates :q_type, presence: { message: 'Tipologia Questionnario non presente. Scegli una tipologia per il questionario.' }
end
