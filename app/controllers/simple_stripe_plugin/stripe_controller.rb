require 'simple_stripe_plugin/base_controller'

module SimpleStripePlugin
  class StripeController < BaseController
    def charge
      # Set your secret key: remember to change this to your live secret key in production
      # See your keys here https://manage.stripe.com/account
      Stripe.api_key = "sk_test_rVS3V1DCFTmn6XJ7OSkSyguR"

      # Get the credit card details submitted by the form
      token = params[:stripeToken]
      amount = params[:amount].to_f * 100
      description = params[:name] + " for " + params[:period]

      @response = {}

      # Charge the Customer instead of the card
      begin
        Stripe::Charge.create(
          :amount => amount.to_i, # in cents
          :currency => "cad",
          :card => token,
          :description => description,
        )
        @response = {success: true}
      rescue Stripe::CardError => e
        #Deal With Errors
        body = e.json_body
        err  = body[:error]

        @response = {error: {message: err[:message]}}
      end
      render json: @response
    end
  end
end