require 'sinatra'
require 'stripe'
require 'rubygems'
require 'haml'
require 'freshdesk'
require 'sinatra/formkeeper'

enable :logging

set :publishable_key, 'pk_test_CFehYFpcPnoGuWeZwA6TqrWS'
set :secret_key, 'sk_test_8vCYhVcbcpt0KlxTxIEjgnvA'

Stripe.api_key = 'sk_test_8vCYhVcbcpt0KlxTxIEjgnvA'

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

	client = Freshdesk.new("http://boomheadline.freshdesk.com/", "patrickemclean@gmail.com", "boompassword") 


	client.post_tickets(:email => params[:email], :description => ticket, :name => params[:name], :source => 2, :priority => 2, :name => "Joshua Siler")


	customer = Stripe::Customer.create(:email => params[:stripeEmail], :card  => params[:stripeToken])

	charge = Stripe::Charge.create(:amount => 2000, :currency => "usd", :card => params[:stripeToken], :description => "Boom! Headline.")

	haml :response, :layout => :main
end

error Stripe::CardError do
  haml :badcode
end



__END__





