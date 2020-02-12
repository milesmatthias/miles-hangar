require 'sinatra'
require 'money'
require './models/plane'

I18n.enforce_available_locales = false

# todo: use a session store, not just stuff things into cookies
enable :sessions

# before filter to get cart
before do
	session[:cart] ||= []
	@cart = session[:cart]

	session[:error_msg] ||= []
	@error_msg = session[:error_msg].pop
end


get '/' do
  # todo: list all planes
  "hello world"
  @planes = Plane.all
	erb :index
end

post '/add-to-cart' do
	if @cart.include?(params[:id])	
		# if it is, tell user to checkout first before buying more
		"You already have this in your cart."
	else
		@cart.push(params[:id]) 
	end

	# todo: make sure total isn't over $999,999.99 (max Stripe charge amt)
	if Plane.total_cost_cents_usd(@cart) > 9999999999
		session[:error_msg].push "You cannot add this item to your cart, as it makes the total cost larger than we can process. Purchase your cart first, and then purchase this item."

		redirect "/", 400
	else
		redirect "/view-cart", 200
	end
end

get '/view-cart' do
	@planes = Plane.find_by_ids(@cart)
	erb :view_cart
end

get '/charge-intention-secret' do
  # todo: create stripe charge intent & return client secret
	"1234"
end

post '/checkout' do
  # todo: ensure a charge id is present, otherwise there were unchecked errors on the client


	# todo
	charge_id = 1

  # todo: redirect to /confirm with ids of planes bought & charge id.
	redirect "/confirm?charge_id=#{charge_id}", 200
end

get '/confirm' do
	@planes    = Plane.find_by_ids(@cart)
	@charge_id = params[:charge_id]

  # clear cart contents
	# FIXME
	@cart = []
end
