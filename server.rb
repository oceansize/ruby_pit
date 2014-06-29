require 'sinatra'
require 'sinatra/flash'
require 'data_mapper'
require 'launchy'
require './lib/link'
require './lib/tag'
require './lib/user'
require './app/helpers/helpers'
require_relative './app/data_mapper_setup'
require_relative './app/helpers/helpers'

set :public_folder, Proc.new { File.join(root, 'public') }
set :views, Proc.new { File.join(root, 'app','views') }

enable :sessions
set :session_secret, 'my unique encryption key!'

# ///////////////////
# GET
# ///////////////////

get '/' do
  @links = Link.all
  erb :index
end

get '/tags/:text' do
  tag = Tag.first(:text => params[:text])
  @links = tag ? tag.links : []
  erb :index
end

get '/users/new' do
  @user = User.new
  # we need the quotes because otherwise
  # ruby would divide the symbol :users by the
  # variable new (which makes no sense)
  erb :"users/new"
end

# ///////////////////
# POST
# ///////////////////

# save user ID in the session after it's created:
post '/users' do
  # Here we just initialize the object without saving it.
  # It may be invalid, and refreshing the page will lose the data.
  @user = User.create(:email => params[:email],
                     :password => params[:password],
                     :password_confirmation => params[:password_confirmation])
  # the user.id will be nil if the user wasn't saved
  # because of password mismatch - let's try saving it
  if @user.save
    session[:user_id] = @user.id
    redirect to '/'
  # if the data is not valid, we'll show the same form again:
  else
    # http://www.lynda.com/Ruby-Rails-tutorials/Flash-hash/139989/159120-4.html
    flash.now[:notice] = "Sorry, your passwords don't match"
    erb :"users/new"
  end
end

post '/links' do
  url = params['url']
  title = params['title']
  tags = params['tags'].split(' ').map do |tag|
    # this will either find this tag or create
    # it if it doesn't exist already
    Tag.first_or_create(:text => tag)
  end
  Link.create(:url => url, :title => title, :tags => tags)
  redirect to '/'
end