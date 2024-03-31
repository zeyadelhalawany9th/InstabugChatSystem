Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :applications do
    resources :chats , param: :chat_number do 
      resources :messages, param: :message_number do 
        collection do
          get :search
        end
      end
    end
  end

end
