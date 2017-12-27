class Invitation < ApplicationRecord
  belongs_to :patient
  belongs_to :campaign
	has_many :answers
end
