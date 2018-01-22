class CreatePatientsTags < ActiveRecord::Migration[5.1]
  def change
    create_table :patients_tags, id: false do |t|
      t.belongs_to :patient, index: true
      t.belongs_to :tag, index: true
    end
  end
end
