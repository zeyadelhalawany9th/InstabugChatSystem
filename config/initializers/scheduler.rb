require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.every '15m' do
    Rails.logger.info "here"
    Application.all.each do |application|
        application.chats_count = Chat.where(application_id: application.id).length()
        application.save
    end

    Chat.all.each do |chat|
        chat.messages_count = Message.where(chat_id: chat.id).length()
        chat.save
    end

end

