class Admin::PaymentsController < AdminController
  def index
    @payments = Payment.last(25).reverse
  end
end
