require 'sinatra'
require 'data_mapper'

env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/ruby_pit_#{env}")

require './lib/link'
require './lib/tag'
require './lib/user'
require './lib/helpers'
set :public_folder, Proc.new { File.join(root, 'Static') }
enable :sessions
set :session_secret, 'super secret'

# After declaring your models, you should finalise them check for consistency:
DataMapper.finalize

# However, the database tables don't exist yet. Let's tell DataMapper to create them:
DataMapper.auto_upgrade!


get '/' do
  @links = Link.all
  erb :index
end

# save user ID in the session after it's created:
post '/users' do
  user = User.create(:email => params[:email],
                     :password => params[:password])
  session[:user_id] = user.id
  redirect to '/'
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

post '/users' do
  User.create(:email => params[:email],
              :password => params[:password])
  redirect to '/'
end

get '/tags/:text' do
  tag = Tag.first(:text => params[:text])
  @links = tag ? tag.links : []
  erb :index
end

get '/users/new' do
  # we need the quotes because otherwise
  # ruby would divide the symbol :users by the
  # variable new (which makes no sense)
  erb :"users/new"
end