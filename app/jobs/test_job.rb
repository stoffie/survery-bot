class TestJob < ActiveJob::Base
	def perform
		# put you scheduled code here
		# Comments.deleted.clean_up...
		Welcome.create
	end
end
