require 'bot/classes/dispatcher'

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def callback
    !webhook[:message].nil? ?  Dispatcher.new(webhook, patient).process : nil
    render json: nil, status: :ok
  end

  def patient
    @patient = Patient.find_by(telegram_id: from[:id])
  end

  def webhook
    params['webhook']
  end

  def from
    webhook[:message][:from]
  end

  private
  def all_params
    params.require(:webhook).permit!
  end

end