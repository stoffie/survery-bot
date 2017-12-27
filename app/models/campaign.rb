class Campaign < ApplicationRecord
	belongs_to :questionnaire
	has_many :invitations
	has_many :patients, through: :invitations
end
