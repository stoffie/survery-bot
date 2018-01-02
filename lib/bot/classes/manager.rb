require 'bot/classes/dialogue'

class Manager
  attr_reader :patient

  def initialize(patient)
    @patient = patient
  end

  def ask_question(q_name)
    invitations = Invitation.where(patient_id: @patient.id)
    invitations.each do |invitation|
      questionnaire = Questionnaire.where(id: invitation.campaign.questionnaire_id, title: q_name).first
      question = questionnaire.questions[invitation.answers.count]
      Dialogue.new(@patient).ask_question(question, invitation)
    end
  end

  def questionnaire_finished?(q_name)
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