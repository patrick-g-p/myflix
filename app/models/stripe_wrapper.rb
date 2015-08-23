module StripeWrapper
  class Charge
    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          :amount => options[:amount],
          :currency => "usd",
          :source => options[:token],
          :description => "Registration charge for #{options[:user_email]}"
        )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def successful?
      status == :success
    end

    def error_message
      response.message
    end
  end

  class Customer
    attr_reader :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:errors]
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          :source => options[:token],
          :plan => 'myflix_base',
          :email => options[:user].email,
          :description => "Monthly charge for #{Time.now.month}/#{Time.now.year}"
        )
        new(response: response)
      rescue Stripe::CardError => e
        new(errors: e.message)
      end
    end

    def successful?
      response.present?
    end
  end
end
