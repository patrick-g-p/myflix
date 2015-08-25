class PaymentsController < ApplicationController
  before_action :require_user

  def show
    @payments = Payment.where(user: current_user)
  end
end
