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
              text: 'Reinserisci il numero di telefono.',
              reply_markup: contact_request_markup)
  end

  def error
    send_chat_action 'typing'
    @api.call('sendMessage', chat_id: chat_id,
              text: 'Errore Server, ci scusiamo per il disagio. La preghiamo di riprovare dopo.')
  end

  def send_logged_in
    send_chat_action 'typing'
    reply = "Ciao #{@patient.name}! Qui troverai tutti i questionari che dovrai fare."
    save_dialogue_log 'Ha fornito il numero di telefono!',
                      reply,
                      {}.to_json
    send_reply_with_keyboard reply, Dialogue.custom_keyboard(['Ho dei Questionari da fare?'])
  end

  def send_questionnaires(questionnaires)
    # first lets save questionnaire list in bot command_data
    list = questionnaires.map(&:title)
    bot_command_data = {'questionnaires' => list}
    reply1 = "I questionari che hai da fare sono: \n\t-#{list.join("\n\t-")}"
    reply2 = 'Scegli un questionario per rispondere alle domande.'
    save_dialogue_log 'Ho da fare dei Questionari?',
                      reply1 + reply2,
                      bot_command_data.to_json

    # then send bot's answer to patient
    send_reply reply1
    send_reply_with_keyboard reply2,
                             Dialogue.custom_keyboard(list)
  end

  def inform_wrong_questionnaire(text)
    bot_command_data = JSON.parse(Dialog.where('patient_id = ? AND bot_command_data IS NOT NULL', @patient.id).last.bot_command_data)
    patient_reply = text
    reply1 = 'Sembra che tu abbia indicato il nome di un questionario non valido.'

    save_dialogue_log patient_reply, reply1, nil
    send_reply reply1
    reply2 = "I questionari che hai da fare sono: \n\t-#{bot_command_data['questionnaires'].join("\n\t-")} \n Scegli uno dei questionari indicati per rispondere alle domande."
    send_reply_with_keyboard reply2,
                             Dialogue.custom_keyboard(bot_command_data['questionnaires'])
    save_user_message reply2, nil
  end

  def ask_question(question, invitation)
    # first lets save question data invitation on bot_command_data
    bot_command_data = JSON.parse(Dialog.where(patient: @patient).last.bot_command_data)
    questionnaire = question.questionnaire
    bot_command_data['responding'] = {'question_id' => question.id,
                                      'invitation_id' => invitation.id,
                                      'questionnaire_id' => questionnaire.id}
    patient_reply = questionnaire.title
    user_message = question.text
    save_dialogue_log patient_reply, user_message, bot_command_data
    options = question.options.map(&:text)
    send_reply_with_keyboard question.text, Dialogue.custom_keyboard(options)
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
    keyboard = Dialogue.custom_keyboard ['Ho da fare dei Questionari?']
    @api.call('sendMessage', chat_id: @patient.telegram_id,
              text: "Va bene! Quando avrai piu' tempo torna e chiedimi se hai da fare dei questionari.", reply_markup: keyboard)
  end

  def inform_no_questionnaires
    send_chat_action 'typing'
    keyboard = Dialogue.custom_keyboard ['Ho da fare dei Questionari?']
    @api.call('sendMessage', chat_id: @patient.telegram_id,
              text: "Non hai Questionari da completare oggi! Torna piu' tardi per ricontrollare.", reply_markup: keyboard)
  end

  def send_chat_action(action)
    @api.call('sendChatAction', chat_id: @patient.telegram_id, action: action)
  end

  # static methods

  def self.menu_buttons
    %w[Ho da fare dei questionari?]
  end

  def self.custom_keyboard(keyboard_values)
    kb = Dialogue.slice_keyboard keyboard_values
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb, one_time_keyboard: true)
  end

  def self.slice_keyboard(values)
    values.length >= 4 ? values.each_slice(2).to_a : values
  end

  def self.menu_keyboard
    custom_keyboard menu_buttons
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
end
