class AddTelegramIdToPatients < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :telegram_id, :string
  end
end
