class QuestionnaireCell < Cell::ViewModel
	include Escaped
	property :email
	property :title

	def show(&block)
		render(&block)
	end
end
