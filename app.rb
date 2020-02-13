require 'sinatra'
require 'stripe'
require 'money'
require './models/plane'

# todo: don't ever check creds into repo, but this is just a demo.
Stripe.api_key = "sk_test_E6AlymrUvOrMWjkO68dg6lcK00tZUoHOLm"

# Money gem setting since we're not using locales
I18n.enforce_available_locales = false

# todo: use a session store, not just stuff things into cookies
enable :sessions


#####################
# session mgmt stuff
#####################
before do
  session[:cart] ||= []

  session[:error_msg] ||= []
  @error_msg = session[:error_msg].pop

  session[:success_msg] ||= []
  @success_msg = session[:success_msg].pop
end


#####################
# home page, view some planes
#####################
get '/' do
  @planes = Plane.all
  erb :index
end


#####################
# add a plane to my cart
#####################
post '/add-to-cart' do
  plane = Plane.find_by_id(params[:plane_id]) 

  # todo: validate id input field: if we don't have that plane, inventory check, etc.

  session[:cart].push(plane.id)

  # make sure total isn't over $999,999.99 (max Stripe charge amt)
  if Plane.total_cost_cents_usd(session[:cart]) > 99999999
    session[:cart].pop

    session[:error_msg].push "You cannot add this item to your cart, as it makes the total cost larger than we can process. Purchase your cart first, and then purchase this item."
    redirect "/"
  else
    session[:success_msg].push "Added the #{plane.name} to your cart."
    redirect "/"
  end
end


#####################
# view my cart to checkout
#####################
get '/checkout' do
  if session[:cart].count.zero?
    session[:error_msg].push "You don't have anything in your cart. Add some planes!"
    redirect "/"
  else
    @planes = Plane.find_by_ids(session[:cart])
    erb :checkout
  end
end


#####################
# get needed Stripe PaymentIntent id
# (need to set amount on server to avoid client side manipulation)
# these planes aren't free :)
# note: ideally this returns JSON, but again, this is just a demo.
#####################
get '/charge-intention-secret' do
  begin

    intent = Stripe::PaymentIntent.create({
      amount: Plane.total_cost_cents_usd(session[:cart]),
      currency: 'usd',
    })
    intent.client_secret

  rescue Exception => e
    status 500
    "Uh oh, something went wrong: Code #{e.error.code} Message #{e.error.respond_to?(:message) ? e.error.message : "(no message)"}"
  end
end


#####################
# process successful payment checkout
#####################
post '/checkout' do
  begin
    charge_id = Stripe::PaymentIntent.retrieve(params[:pi_id]).charges.data.last.id
  rescue Stripe::StripeError => e
    puts "Uh oh, something went wrong: Code #{e.error.code} Message #{e.error.respond_to?(:message) ? e.error.message : "(no message)"}"
  rescue Exception => e
    puts "Error happened: #{e.msg}"
  ensure
    charge_id ||= "missing right now, but your payment was successful. We'll email you a better receipt soon."
  end

  # todo: store the customer & charge data here in our db someday

  redirect "/confirm?charge_id=#{charge_id}"
end


#####################
# show purchase receipt
#####################
get '/confirm' do
  # show the user what they bought
  @planes               = Plane.find_by_ids(session[:cart])
  @charge_id            = params[:charge_id]

  # clear cart contents
  session[:cart] = []

  erb :confirm
end
