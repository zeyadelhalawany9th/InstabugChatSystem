class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.integer :number, index: true
      t.references :application, foreign_key: true, index: true
      t.integer :message_count

      t.timestamps
    end
  end
end