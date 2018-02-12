class AddTypeToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :q_type, :integer
  end
end
