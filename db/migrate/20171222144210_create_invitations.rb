class CreateInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :invitations do |t|
      t.references :patient, foreign_key: true
      t.references :campaign, foreign_key: true

      t.timestamps
    end
  end
end
