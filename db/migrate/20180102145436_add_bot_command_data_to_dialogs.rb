class AddBotCommandDataToDialogs < ActiveRecord::Migration[5.1]
  def change
    add_column :dialogs, :bot_command_data, :string
  end
end
