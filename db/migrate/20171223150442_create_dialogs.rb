class CreateDialogs < ActiveRecord::Migration[5.1]
  def change
    create_table :dialogs do |t|
      t.references :patient, foreign_key: true
      t.string :user_message
      t.string :patient_reply

      t.timestamps
    end
  end
end
