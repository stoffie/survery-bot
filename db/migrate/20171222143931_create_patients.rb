class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t|
      t.string :name
      t.string :surname
      t.string :phoneno
      t.boolean :telegram_enabled

      t.timestamps
    end
  end
end
