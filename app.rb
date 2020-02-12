require 'sinatra'
require 'money'
require './models/plane'

I18n.enforce_available_locales = false

# todo: use a session store, not just stuff things into cookies
enable :sessions

# before filter to get cart
before do
	session[:cart] ||= []

	session[:error_msg] ||= []
	@error_msg = session[:error_msg].pop

	session[:success_msg] ||= []
	@success_msg = session[:success_msg].pop
end


get '/' do
  # todo: list all planes
  "hello world"
  @planes = Plane.all
	erb :index
end

post '/add-to-cart' do
	plane = Plane.find_by_id(params[:plane_id]) 

	# todo: validate id input field
	# if we don't have that plane, inventory check

  session[:cart].push(plane.id)

	# make sure total isn't over $999,999.99 (max Stripe charge amt)
	if Plane.total_cost_cents_usd(session[:cart]) > 9999999999
    session[:cart].pop

		session[:error_msg].push "You cannot add this item to your cart, as it makes the total cost larger than we can process. Purchase your cart first, and then purchase this item."
		redirect "/"
	else
		session[:success_msg].push "Added the #{plane.name} to your cart."
		redirect "/"
	end
end

get '/checkout' do
	if session[:cart].count.zero?
		session[:error_msg].push "You don't have anything in your cart. Add some planes!"
		redirect "/"
	else
		@planes = Plane.find_by_ids(session[:cart])
		erb :checkout
	end
end

get '/charge-intention-secret' do
  # todo: create stripe charge intent & return client secret
	"1234"
end

post '/checkout' do
	puts "checking out with charge_id = #{params[:charge_id]}"

  # todo: ensure a charge id is present, otherwise there were unchecked errors on the client

  # todo: redirect to /confirm with ids of planes bought & charge id.
	redirect "/confirm?charge_id=#{params[:charge_id]}"
end

get '/confirm' do
	@planes    = Plane.find_by_ids(session[:cart])
	@charge_id = params[:charge_id]

  # clear cart contents
	session[:cart] = []

	erb :confirm
end
