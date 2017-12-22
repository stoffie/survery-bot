class NavigationCell < Cell::ViewModel
	#include Devise::Controllers::Helpers
	include Escaped
	property :email
	property :title

	def navigation(&block)
		render(&block)
	end
end
