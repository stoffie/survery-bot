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
									:guard => Proc.new {|*args| questionnaire_finished?(*args)}
			transitions :from => :questionnaires, :to => :questionnaires,
									:after => Proc.new {|*args| inform_wrong_questionnaire(*args)}
		end

		event :cancel do
			transitions :from => :questionnaires, :to => :idle, :after => :back_to_menu
			transitions :from => :responding, :to => :idle, :after => :back_to_menu
		end
	end

	private

	def inform_wrong_questionnaire(text)
		Dialogue.new(self).inform_wrong_questionnaire(text)
	end

	def ask_question(questionnaire)
		Manager.new(self).ask_question(questionnaire)
	end

	def questionnaire_finished?(questionnaire)
		Manager.new(self).questionnaire_finished?(questionnaire)
	end

	def show_questionnaires
		Manager.new(self).show_questionnaires
	end

	def has_questionnaires?
		Manager.new(self).has_questionnaires?
	end

	def back_to_menu
		Dialogue.new(self).back_to_menu_with_menu
	end

	def inform_no_questionnaires
		Dialogue.new(self).inform_no_questionnaires
	end
end
