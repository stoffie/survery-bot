class QuestionnaireCell < Cell::ViewModel
	include Escaped
	property :email
	property :title

	def navigation(&block)
		render(&block)
	end
end
