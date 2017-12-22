class Invitation < ApplicationRecord
  belongs_to :patient
  belongs_to :campaign
end
