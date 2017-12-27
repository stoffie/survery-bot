class RemovePointerFromInvitations < ActiveRecord::Migration[5.1]
  def change
		remove_column :answers, :patient_id
  end
end
