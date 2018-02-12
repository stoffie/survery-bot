class Questionnaire < ApplicationRecord
	has_many :questions, :dependent => :destroy
	validates_uniqueness_of :title, message: 'Nome Questionario gia\' esistente. Scegliere un\'altro nome per favore.'
	accepts_nested_attributes_for :questions, allow_destroy: true, :reject_if => lambda { |attributes| attributes[:text].blank? }
end
