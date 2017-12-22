class PatientsTableCell < Cell::ViewModel
	include Escaped

	def show(&block)
		render(&block)
	end
end
