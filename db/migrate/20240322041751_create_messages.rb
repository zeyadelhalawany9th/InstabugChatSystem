class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.integer :message_number, index: true
      t.text :body 
      t.references :chat, foreign_key: true, index: true
      t.references :application, foreign_key: true, index: true

      t.timestamps
    end
  end
end