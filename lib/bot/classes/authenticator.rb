require 'bot/classes/dialogue'

class Authenticator
  attr_reader :message, :user, :api

  def initialize(message, user)
    @message = message
    @user = user
    token = Rails.application.secrets.bot_token
    @api = ::Telegram::Bot::Api.new(token)
  end

  # process the user state
  def manage
    case text
      when /\A\/start/
        Dialog.new(@user).welcome(chat_id)
      else
        contact.nil? ? phone_number = '' : phone_number = contact_phone_number
        if valid(phone_number)
          init_user
        else
          Dialog.new(@user).send_not_allowed(chat_id)
        end
    end
  end

  def init_user
    @user.telegram_id = chat_id
    dialog = Dialog.new(@user)
    if user.save
      dialog.send_logged_in
    else
      dialog.error
    end
  end

  def valid(phone_number)
    user = User.find_by_cellphone(phone_number)
    if user.nil?
      false
    else
      @user = user
      true
    end
  end

  def contact_phone_number
    # phone number without prefix
    @message[:message][:contact][:phone_number][2,12]
  end

  def contact
    @message[:message][:contact]
  end

  def from
    @message[:message][:from]
  end

  def chat_id
    @message[:message][:from][:id]
  end

  def text
    @message[:message][:text]
  end
end