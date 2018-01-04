require 'bot/classes/authenticator'
require 'bot/classes/dialogue'

class Dispatcher
  attr_reader :message, :patient

  def initialize(message, patient)
    @message = message
    @patient = patient
  end

  # process the user state
  def process
    if @patient.nil?
      # patient needs to log in
      Authenticator.new(@message, @patient).manage
    else
      # when user is logged in save his input text
      Dialogue.new(@patient).save_patient_reply(text)

      # dispatch in function of user state and text input
      aasm_state = @patient.aasm_state

      case aasm_state
        when 'idle'
          manage_idle(text)

        when 'questionnaires'
          manage_questionnaires(text)

        else # 'responding'
          manage_responding(text)

      end

    end
  end

  def manage_idle(text)
    case text
      when 'Ho da fare dei questionari?'
        @patient.start_questionnaires!
      else
        @patient.no_action!
    end
  end

  def manage_questionnaires(text)
    case text
      when *back_strings
        @patient.cancel!
      else
        @patient.start_responding!(text)
    end
  end

  def manage_responding(text)
    case text
      when *back_strings
        @patient.cancel!
      else
        @patient.respond!(text)
    end
  end

  def text
    @message[:message][:text]
  end

  def back_strings
    ['Indietro', 'indietro', 'basta', 'Torna Indietro', 'Basta', 'back',
     'Torna al Menu', 'Rispondi piu\' tardi/Torna al Menu', 'stop']
  end

  def tell_me_more_strings
    ['Dimmi di piu', 'ulteriori dettagli', 'dettagli', 'di piu', 'Ulteriori Dettagli']
  end


end