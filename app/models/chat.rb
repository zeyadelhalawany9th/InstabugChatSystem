class Chat < ApplicationRecord
    belongs_to :application
    has_many :messages, dependent: :destroy
    validates :chat_number, presence: true, uniqueness: { scope: :application_id }, 
    numericality: {only_integer: true, greater_than_or_equal_to: 1}
end
