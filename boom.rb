require 'sinatra'
require 'stripe'
require 'haml'
require 'freshdesk'


enable :logging

set :stripe_publishable_key, "pk_test_CFehYFpcPnoGuWeZwA6TqrWS"
set :stripe_secret_key, "sk_test_3UqpOIA4twxvA33Y1VQmLjOq"

# set :stripe_publishable_key, "pk_test_CFehYFpcPnoGuWeZwA6TqrWS"
# set :stripe_secret_key, "sk_test_8CTp0hYKpOziGUCBSqQKRdux"


get '/' do
  haml :form, :layout => :main
end



post '/promo' do

  if params[:promo]
    if params[:promocode] == "22"
      client.post_tickets(:email => params[:email], :description => ticket, :name => "Customer Name", :source => 2, :priority => 2, :name => "Joshua Siler")
      haml :response, :layout => :main
    else
      haml :badcode, :layout => :main
    end
  end
end

post '/charge' do
  begin
    create_charge
    create_ticket
  rescue Exception => e
    logger.error e
  end
  haml :response, :layout => :main
end

error Stripe::CardError do
  haml :badcode
end

def create_charge
  Stripe.api_key = settings.stripe_secret_key
  logger.info "Stripe api key"
  logger.info Stripe.api_key
  charge = Stripe::Charge.create(
    :amount => 2000,
    :currency => "usd",
    :card => params[:stripeToken],
    :description => "Boom! Headline."
  )
  logger.info "Charge record"
  logger.info charge.inspect
end

def create_ticket
  ticket = "\n\n\n"
  ticket += "Their line: #{params[:line]}"
  ticket += "\n\n\n\n"
  ticket += "Wants them to: #{params[:what]}"
  ticket += "\n\n\n"
  ticket += "Is writing for: #{params[:who]}"
  ticket += "\n\n\n"
  ticket += "With this kind of tone: #{params[:tone]}"
  ticket += "\n\n\n"
  ticket += "Wants them to: #{params[:what]}"
  ticket += "\n\n\n"
  ticket += "And consider this: #{params[:whatelse]}"
  ticket += "\n\n\n"

  fd = Freshdesk.new(
    "http://boomheadline.freshdesk.com/",
    "patrickemclean@gmail.com",
    "boompassword"
  )
  ticket = fd.post_tickets(
    :email => params[:email],
    :description => ticket,
    :name => params[:name],
    :source => 2,
    :priority => 2
  )

  logger.info ticket.inspect
end


__END__





