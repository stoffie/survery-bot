require 'bot/classes/dialogue'

class Manager
  attr_reader :patient

  def initialize(patient)
    @patient = patient
  end

  def is_last_question?
    bot_command_data = JSON.parse(Dialog.where('patient_id = ? AND bot_command_data IS NOT NULL', @patient.id).last.bot_command_data)
    questionnaire = Questionnaire.find(bot_command_data['responding']['questionnaire_id'])
    invitation = Invitation.find(bot_command_data['responding']['invitation_id'])
    if questionnaire.questions.count-1 == invitation.answers.count
      true
    else
      false
    end
  end

  def ask_last_question_again
    bot_command_data = JSON.parse(Dialog.where('patient_id = ? AND bot_command_data IS NOT NULL', @patient.id).last.bot_command_data)
    question = Question.find(bot_command_data['responding']['question_id'])
    invitation = Invitation.find(bot_command_data['responding']['invitation_id'])
    dialog_manager = Dialogue.new(@patient)
    dialog_manager.inform_wrong_response
    dialog_manager.ask_question(question, invitation)
  end

  def register_response(response)
    bot_command_data = JSON.parse(Dialog.where('patient_id = ? AND bot_command_data IS NOT NULL', @patient.id).last.bot_command_data)
    Answer.create(invitation_id: bot_command_data['responding']['invitation_id'],
                  question_id: bot_command_data['responding']['question_id'], text: response)
    Dialogue.new(@patient).send_response_saved
  end

  def is_response?(response)
    bot_command_data = JSON.parse(Dialog.where('patient_id = ? AND bot_command_data IS NOT NULL', @patient.id).last.bot_command_data)
    question = Question.find(bot_command_data['responding']['question_id'])
    options = question.options.map(&:text)
    options.include?(response) ? true : false
  end

  def ask_question(q_name)
    ap "IN ask_question(q_name='#{q_name}')"

    invitations = Invitation.where(patient_id: @patient.id)
    invitations.each do |invitation|
      questionnaire = Questionnaire.where(id: invitation.campaign.questionnaire_id, title: q_name).first
      ap "QUESTIONNAIRE="
      ap questionnaire
      unless questionnaire.nil?
        question = questionnaire.questions[invitation.answers.count]
        Dialogue.new(@patient).ask_question(question, invitation)
      end
    end
  end

  def questionnaire_is_not_finished?(q_name)
    invitations = Invitation.where(patient_id: @patient.id)
    invitations.each do |invitation|
      questionnaire = Questionnaire.where(id: invitation.campaign.questionnaire_id, title: q_name).first
      unless questionnaire.nil?
        if invitation.answers.count < questionnaire.questions.count
          return true
        end
      end
    end
    false
  end

  def has_questionnaires?
    invitations = Invitation.where(patient_id: @patient.id)
    invitations.each do |invitation|
      questionnaire = Questionnaire.where(id: invitation.campaign.questionnaire_id).first
      if invitation.answers.count < questionnaire.questions.count
        return true
      end
    end
    false
  end

  def show_questionnaires
    invitations = Invitation.where(patient_id: @patient.id)
    questionnaires = []
    invitations.each do |invitation|
      questionnaire = Questionnaire.where(id: invitation.campaign.questionnaire_id).first
      if invitation.answers.count < questionnaire.questions.count
        questionnaires.push questionnaire
      end
    end
    Dialogue.new(@patient).send_questionnaires(questionnaires)
  end
end