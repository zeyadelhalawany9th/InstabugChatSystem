class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :app_token, index: true
      t.string :app_name
      t.integer :chats_count

      t.timestamps
    end
  end
end