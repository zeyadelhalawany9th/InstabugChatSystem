class ChatsController < ApplicationController
  before_action :set_application

  def index
    @chats = Chat.where(application_id: @application.id)
    render json: @chats.as_json(except: [:id, :application_id])
  end

  def show
    @chat = @application.chats.find_by!(chat_number: params[:chat_number])
    render json: {chat_number: @chat.chat_number, app_token: @application.app_token, messages_count: @chat.messages_count}
  end

  def create
    chat_number = $redis.incr("chat_number_#{@application.app_token}")
    chat_parameters = {
      chat_number: chat_number,
      application_id: @application.id,
      messages_count: 0
    }
    handler = PublishHandler.new
    handler.send_message($chatQueue, chat_parameters)
    render json: {chat_number: chat_number, app_token: @application.app_token, messages_count: 0}
  end

  def update
    if @chat.update(chat_params)
      render json: @chat.as_json(except: [:id, :application_id])
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @application.chats.find_by(chat_number: params[:chat_number]).destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.find_by!(app_token: params[:application_id])
  end

  # Only allow a trusted parameter "white list" through.
  def chat_params
    params.permit(:application_id)
  end
end