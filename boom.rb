require 'sinatra'
require 'stripe'
require 'haml'
require 'freshdesk'
# require 'httparty'
# require 'haml-contrib'


enable :logging

set :stripe_publishable_key, "pk_test_CFehYFpcPnoGuWeZwA6TqrWS"
set :stripe_secret_key, "sk_test_3UqpOIA4twxvA33Y1VQmLjOq"



get '/' do
  haml :home, :layout => :main
end

get '/form' do
  haml :form, :layout => :main
end


get '/blog' do

    send_file File.join(File.dirname(__FILE__), '/public/blog/_site/index.html')
end

get '/blog/:title' do

    post = File.basename(request.path)
    send_file File.join(File.dirname(__FILE__), "/public/blog/_site/blog/#{post}/index.html")
end

post '/entice' do
  haml :entice, :layout => :main
end

get '/entice' do
  haml :entice, :layout => :main
end

post '/promo' do

  if params[:promo]
    if code_is_valid?(params[:promocode])
      create_ticket
      haml :response, :layout => :main
    else
      haml :badcode, :layout => :main
    end
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

get '/error' do
  halt(404,haml(:error, :locals => {:error_message => request.env['sinatra.error'].to_s}))
end

def code_is_valid?(code)
  codesarray=[]
  codes=File.open('./codes.txt')

  codes.each do |line|
    codesarray.push(line.chomp)
  end

  codesarray.each do |validcode|
    if code == validcode
      return true
    end
  end
  return false
end 




__END__





