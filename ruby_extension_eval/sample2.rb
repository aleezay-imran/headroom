require 'stripe'

class PaymentProcessor
  def initialize(api_key)
    @client = Stripe::Client.new(api_key)
  end

  def charge(amount, currency, card_token)
    begin
      charge = @client.charges.create(
        amount: amount,
        currency: currency,
        source: card_token
      )
      log_transaction(charge)
      return charge
    rescue Stripe::CardError => e
      handle_card_error(e)
    rescue Stripe::APIError => e
      handle_api_error(e)
    end
  end

  def refund(charge_id, amount = nil)
    params = { charge: charge_id }
    params[:amount] = amount if amount
    @client.refunds.create(params)
  end

  private

  def log_transaction(charge)
    puts "Transaction logged: #{charge.id}"
  end

  def handle_card_error(error)
    puts "Card declined: #{error.message}"
  end

  def handle_api_error(error)
    puts "API error: #{error.message}"
  end
end
