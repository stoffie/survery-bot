require 'bot/classes/dialogue'

class Authenticator
  attr_reader :message, :patient

  def initialize(message, patient)
    @message = message
    @patient = patient
  end

  # process the user state
  def manage
    case text
      when /\A\/start/
        Dialogue.new(@patient).welcome(chat_id)
      else
        contact.nil? ? phone_number = nil : phone_number = contact_phone_number
        if valid(phone_number)
          init_user
        else
          Dialogue.new(@patient).send_not_allowed(chat_id)
        end
    end
  end

  def init_user
    @patient.telegram_id = chat_id
    dialogue = Dialogue.new(@patient)
    if @patient.save
      dialogue.send_logged_in
    else
      dialogue.error
    end
  end

  def valid(phone_number)
    patient = Patient.find_by_phoneno(phone_number)
    if patient.nil? || phone_number.nil?
      false
    else
      @patient = patient
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