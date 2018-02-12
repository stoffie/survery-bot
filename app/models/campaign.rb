class Campaign < ApplicationRecord
	belongs_to :questionnaire
	has_many :invitations
	has_many :patients, through: :invitations
	validates :tag_list, presence: { message: "Devi Scegliere dei tag per creare una campagna!" }
	acts_as_taggable
end
