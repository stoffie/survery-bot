require 'bot/classes/manager'
require 'bot/classes/dialogue'

class Patient < ApplicationRecord
	has_many :dialogs

	include AASM # Act As State Machine

	# default column: aasm_state
	# no direct assignment to aasm_state
	# return false instead of exceptions
	aasm  :whiny_transitions => false do
		state :idle, :initial => true
		state :questionnaires, :responding

		event :start_questionnaires do
			transitions :from => :idle, :to => :questionnaires,
									:after => :show_questionnaires,
									:guard => :has_questionnaires?
			transitions :from => :idle, :to => :idle,
									:after => :inform_no_questionnaires
		end

		event :start_responding do
			transitions :from => :questionnaires, :to => :responding,
									:after => Proc.new {|*args| ask_question(*args)},
									:guard => Proc.new {|*args| questionnaire_is_not_finished?(*args)}
			transitions :from => :questionnaires, :to => :questionnaires,
									:after => Proc.new {|*args| inform_wrong_questionnaire(*args)}
		end

		event :respond do
			transitions :from => :responding, :to => :idle,
									:after => Proc.new {|*args| register_last_response(*args)},
									:guard => Proc.new {|*args| is_last_question_and_is_response?(*args)}
			transitions :from => :responding, :to => :responding,
									:after => Proc.new {|*args| register_response(*args)},
									:guard => Proc.new {|*args| is_response?(*args)}
			transitions :from => :responding, :to => :responding,
									:after => :ask_last_question_again
		end

		event :cancel do
			transitions :from => :questionnaires, :to => :idle, :after => :back_to_menu
			transitions :from => :responding, :to => :idle, :after => :back_to_menu
		end

		event :no_action do
			transitions :from => :idle, :to => :idle,
									:after => :send_no_action_received
		end

	end

	private

	def register_last_response(response)
		Manager.new(self).register_response(response)
		Dialogue.new(self).send_questionnaire_finished
	end

	def is_last_question_and_is_response?(response)
		if is_response?(response) && Manager.new(self).is_last_question?
			true
		else
			false
		end
	end

	def ask_next_question
		bot_command_data = JSON.parse(Dialog.where('patient_id = ? AND bot_command_data IS NOT NULL', self.id).last.bot_command_data)
		Manager.new(self).ask_question(Questionnaire.find(bot_command_data['responding']['questionnaire_id']).title)
	end

	def ask_last_question_again
		Manager.new(self).ask_last_question_again
	end

	def register_response(response)
		Manager.new(self).register_response(response)
		ask_next_question
	end

	def is_response?(response)
		Manager.new(self).is_response?(response)
	end

	def inform_wrong_questionnaire(text)
		Dialogue.new(self).inform_wrong_questionnaire(text)
	end

	def ask_question(questionnaire)
		Manager.new(self).ask_question(questionnaire)
	end

	def questionnaire_is_not_finished?(questionnaire)
		Manager.new(self).questionnaire_is_not_finished?(questionnaire)
	end

	def show_questionnaires
		Manager.new(self).show_questionnaires
	end

	def has_questionnaires?
		Manager.new(self).has_questionnaires?
	end

	def send_no_action_received
		Dialogue.new(self).inform_no_action_received
	end

	def back_to_menu
		Dialogue.new(self).back_to_menu_with_menu
	end

	def inform_no_questionnaires
		Dialogue.new(self).inform_no_questionnaires
	end

	def no_action_received
		Dialogue.new(self).inform_no_action_received
	end
end
