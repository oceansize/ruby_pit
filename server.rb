require 'sinatra'
require 'data_mapper'

env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/ruby_pit_#{env}")
# We're telling Datamapper to use a postgres database on localhost. The name will be "ruby_pit_test" or "ruby_pit_development" depending on the environment
# The second argument to setup() is called a connection string. It has the following format: type://user:password@hostname:port/databasename
# By default Postgres.app is configured to accept connections from a logged in user without the password, so we omit them. Since postgres is running on the default port 5432, it doesn't have to be specified either.

require './lib/link'
require './lib/tag'
# This needs to be done after DataMapper is initialized, and this reference to our models lets DataMapper know what data schema we have in our project (because we include DataMapper::Resource in every model).

# After declaring your models, you should finalise them check for consistency:
DataMapper.finalize

# However, the database tables don't exist yet. Let's tell DataMapper to create them:
DataMapper.auto_upgrade!

# Datamapper will not create the database for us. We need to do it ourselves. In the terminal run psql to connect to your database server.
get '/' do
  @links = Link.all
  erb :index
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

get '/tags/:text' do
  tag = Tag.first(:text => params[:text])
  @links = tag ? tag.links : []
  erb :index
end

