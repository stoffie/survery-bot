class Tag < ApplicationRecord
  has_and_belongs_to_many :patients#, inverse_of: :tags

  validates_uniqueness_of :name, message: 'Non possono esistere 2 Tag con lo stesso nome.'
end
