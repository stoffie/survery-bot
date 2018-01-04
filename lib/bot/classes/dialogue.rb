require 'telegram/bot'
require 'JSON'

class Dialogue
  attr_reader :patient, :api

  def initialize(patient)
    @patient = patient
    @api = ::Telegram::Bot::Api.new(Rails.application.secrets.bot_token)
  end

  def welcome(chat_id)
    @api.call('sendMessage', chat_id: chat_id,
              text: 'Condividi il tuo numero di telefono attraverso il bottone per continuare.',
              reply_markup: contact_request_markup)
  end

  def send_not_allowed(chat_id)
    @api.call('sendMessage', chat_id: chat_id,
              text: 'Numero di telefono non abilitato.')
    @api.call('sendMessage', chat_id: chat_id,
              text: 'Condividi il tuo numero di telefono attraverso il bottone per continuare.',
              reply_markup: contact_request_markup)
  end

  def error(chat_id)
    send_chat_action 'typing'
    @api.call('sendMessage', chat_id: chat_id,
              text: 'Errore Server, ci scusiamo per il disagio. La preghiamo di riprovare dopo.')
  end

  def send_logged_in
    send_chat_action 'typing'
    reply = "Benvenuto #{@patient.name}! Qui troverai tutti i questionari che dovrai fare."

    send_reply_with_keyboard reply, Dialogue.custom_keyboard([menu_button_text])
  end

  def send_questionnaires(questionnaires)
    # first lets save questionnaire list in bot command_data
    list = questionnaires.map(&:title)
    bot_command_data = {'questionnaires' => list}
    save_bot_command_data(bot_command_data)

    reply1 = "I questionari che hai da fare sono: \n\t-#{list.join("\n\t-")}"
    reply2 = 'Scegli un questionario per rispondere alle domande.'


    # then send bot's answer to patient
    send_reply reply1
    send_reply_with_keyboard reply2,
                             Dialogue.custom_keyboard(list.push(back_button_text))
  end

  def inform_wrong_questionnaire(text)
    bot_command_data = JSON.parse(Dialog.where('patient_id = ? AND bot_command_data IS NOT NULL', @patient.id).last.bot_command_data)
    reply1 = "Oups! '#{text}' non e' il titolo di nessun questionario che hai da fare."

    send_reply reply1
    reply2 = "I questionari che hai da fare sono: \n\t-#{bot_command_data['questionnaires'].join("\n\t-")} \n Scegli uno dei questionari indicati per rispondere alle domande."
    send_reply_with_keyboard reply2,
                             Dialogue.custom_keyboard(bot_command_data['questionnaires'].push(back_button_text))
  end

  def ask_question(question, invitation)
    # first lets save question data invitation on bot_command_data
    bot_command_data = JSON.parse(Dialog.where('patient_id = ? AND bot_command_data IS NOT NULL', @patient.id).last.bot_command_data)
    questionnaire = question.questionnaire
    bot_command_data['responding'] = {'question_id' => question.id,
                                      'invitation_id' => invitation.id,
                                      'questionnaire_id' => questionnaire.id}
    save_bot_command_data(bot_command_data)

    options = question.options.map(&:text)
    send_reply_with_keyboard question.text, Dialogue.custom_keyboard(options.push(back_button_text))
  end

  def inform_wrong_response
    send_reply 'Hai scelto un opzione non disponibile per questa domanda. Per favore scegli una delle opzioni disponibili.'
  end

  def send_response_saved
    send_reply 'Risposta Salvata!'
  end

  def send_questionnaire_finished
    bot_command_data = JSON.parse(Dialog.where('patient_id = ? AND bot_command_data IS NOT NULL', @patient.id).last.bot_command_data)
    questionnaire = Questionnaire.find(bot_command_data['responding']['questionnaire_id'])
    send_reply_with_keyboard "Hai finito il questionario '#{questionnaire.title}'. Per controllare se ci sono altri questionari chiedimi se hai altri questionari da fare.",
                             Dialogue.custom_keyboard([menu_button_text])
  end

  # data.class has to be Hash
  def save_bot_command_data(data)
    Dialog.create(patient_id: @patient.id, bot_command_data: data.to_json)
  end

  def save_dialogue_log(patient_reply, user_message, bot_command_data)
    Dialog.create(patient_reply: patient_reply, patient_id: @patient.id, bot_command_data: bot_command_data)
    Dialog.create(user_message: user_message, patient_id: @patient.id, bot_command_data: bot_command_data)
  end

  def save_patient_reply(patient_reply, bot_command_data)
    Dialog.create(patient_reply: patient_reply, patient_id: @patient.id, bot_command_data: bot_command_data)
  end

  def save_user_message(user_message, bot_command_data)
    Dialog.create(user_message: user_message, patient_id: @patient.id, bot_command_data: bot_command_data)
  end

  def contact_request_markup
    keyboard = [Telegram::Bot::Types::KeyboardButton.new(text: 'Condividi numero cellulare', request_contact: true)]
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: keyboard, one_time_keyboard: true)
  end

  def back_to_menu_with_menu
    send_chat_action 'typing'
    keyboard = Dialogue.custom_keyboard [menu_button_text]
    @api.call('sendMessage', chat_id: @patient.telegram_id,
              text: "Va bene! Quando avrai piu' tempo torna e chiedimi se hai da fare dei questionari.", reply_markup: keyboard)
  end

  def inform_no_questionnaires
    send_chat_action 'typing'
    keyboard = Dialogue.custom_keyboard ['Ho da fare dei Questionari?']
    @api.call('sendMessage', chat_id: @patient.telegram_id,
              text: "Non hai Questionari da completare oggi! Torna piu' tardi per ricontrollare.", reply_markup: keyboard)
  end

  def inform_no_action_received
    send_reply_with_keyboard 'Per favore usa i bottoni per interagire con il sistema.',
                             Dialogue.custom_keyboard([menu_button_text])
  end

  def send_chat_action(action)
    @api.call('sendChatAction', chat_id: @patient.telegram_id, action: action)
  end

  # static methods

  def self.custom_keyboard(keyboard_values)
    kb = Dialogue.slice_keyboard keyboard_values
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb, one_time_keyboard: true)
  end

  def self.slice_keyboard(values)
    values.length >= 4 ? values.each_slice(2).to_a : values
  end

  private

  def send_reply(reply)
    send_chat_action 'typing'
    @api.call('sendMessage', chat_id: @patient.telegram_id, text: reply)
  end

  def send_reply_with_keyboard(reply, keyboard)
    send_chat_action 'typing'
    @api.call('sendMessage', chat_id: @patient.telegram_id, text: reply, reply_markup: keyboard)
  end

  def menu_button_text
    'Ho da fare dei questionari?'
  end

  def back_button_text
    'Rispondi piu\' tardi/Torna al Menu'
  end
end
