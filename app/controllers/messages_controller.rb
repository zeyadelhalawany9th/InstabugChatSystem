class MessagesController < ApplicationController
  before_action :set_application
  before_action :set_chat

  def index
    @messages = Message.where(chat_id: @chat.id)
    render json: @messages.as_json(except: [:id, :chat_id, :application_id])
  end

  def show
    @message = @chat.messages.find_by!(message_number: params[:message_number])
    render json: {message_number: @message.message_number, chat_number: @chat.chat_number, app_token: @application.app_token, 
    body: @message.body}
  end

  def create
    puts params[:body]
    message_number = $redis.incr("message_number_#{@chat.chat_number}_#{@application.app_token}")
    message_params = {
      message_number: message_number,
      body: params[:body],
      chat_id: @chat.id,
      application_id: @application.id
    }
    handler = PublishHandler.new
    handler.send_message($messageQueue,  message_params)
    render json: {message_number: message_number, chat_number: @chat.chat_number, app_token: @application.app_token, 
    body: params[:body]}

  end

  def search
    @message = Message.search(params[:text], @chat.id)
    render json: @message.as_json(except: [:id, :chat_id, :application_id])
  end
  
  def update
    @message = @chat.messages.find_by!(message_number: params[:message_number])
    if @message.update({body: params[:body]})
      render json: {message_number: @message.message_number, chat_number: @chat.chat_number, app_token: @application.app_token, 
      body: params[:body]}
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @message = @chat.messages.find_by!(message_number: params[:message_number])
    @message.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.find_by!(app_token: params[:application_id])
  end
  def set_chat
    @chat = @application.chats.find_by!(chat_number: params[:chat_chat_number])
  end

  # Only allow a trusted parameter "white list" through.
  def message_params
    params.require(:application_id, :body)
  end
end