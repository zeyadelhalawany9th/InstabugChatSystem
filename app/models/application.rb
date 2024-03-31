class Application < ApplicationRecord
    has_secure_token :app_token
    has_many :chats, dependent: :destroy
    validates :app_name, presence: true
end

