class Payment < ActiveRecord::Base
  attr_accessible :email, :stripe_card_token, :amount
  attr_accessor :amount
  attr_accessor :stripe_card_token

  
 #manditory fields
 validates_presence_of :email, :message => "must be provided so we can link payment to an individual"
  validates_presence_of :amount, :message => "must be provided so we can link payment to an individual"
 #validates_presence_of :foodbank_id, :message => "Please select to which food giving partner you would like to dedicate your donation."
 #validates_presence_of :stripe_card_token, :message => "Our apologies, there was a failure in processing your payment card."
 
 # email should read like an email address; this check isn't exhaustive,
# but it's a good start
  validates_format_of :email, 
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => "doesn't look like a proper email address"
    
    
 #Custom Methods
 
 
 #Save_with_Payment handles special saving of payment token information in the database
 def save_with_payment
    if valid?
      @amount = (amount * 100)
      customer = Stripe::Customer.create(description: email, card: stripe_card_token)
      charge = Stripe::Charge.create(
          :customer    => customer.id,
          :amount      => @amount,
          :description => 'Food bank donation',
          :currency    => 'usd'
       )
      self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end
  
  
end
