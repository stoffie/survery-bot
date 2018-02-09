require 'net/http'

namespace :ngrock do
	task :webhook do
		unless ENV['BOT_TOKEN']
			$stderr << "Please set your BOT_TOKEN enviroment variable\n"
			exit
		end
		unless ENV['NGROCK_URL']
			$stderr << "Please set your NGROCK_URL enviroment variable\n"
			exit
		end
		token = ENV['BOT_TOKEN']
		ngrock = ENV['NGROCK_URL']
		url = "https://api.telegram.org/bot#{token}/setWebhook?url=#{ngrock}/webhooks/telegram_#{token}"
		uri = URI(url)
		puts url
		puts Net::HTTP.get(uri)
	end
end
