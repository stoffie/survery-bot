require 'bot/classes/authenticator'

class Dispatcher
  attr_reader :message, :patient

  def initialize(message, patient)
    @message = message
    @patient = patient
  end

  # process the user state
  def process

    if @patient.nil?
      # user needs to log in
      Authenticator.new(@message, @user).manage
    else
      # dispatch in function of user state and text input
      aasm_state = @patient.aasm_state
      ap "CURRENT USER: #{@patient.id} STATE: #{aasm_state}"

      case aasm_state
        when 'idle'


        else # 'feedbacking'


      end

    end
  end

  def text
    @message[:message][:text]
  end

  def back_strings
    ['Indietro', 'indietro', 'basta', 'Torna Indietro', 'Basta', 'back', 'Torna al Menu', 'Rispondi piu\' tardi/Torna al Menu']
  end

  def tell_me_more_strings
    ['Dimmi di piu', 'ulteriori dettagli', 'dettagli', 'di piu', 'Ulteriori Dettagli']
  end


end