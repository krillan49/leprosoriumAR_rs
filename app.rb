require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, { adapter: 'sqlite3', database: 'leprosorium.db' }

class Post < ActiveRecord::Base
  validates :content, length: { minimum: 100 }
  validates :author, presence: true
end

class Comment < ActiveRecord::Base
end

get '/' do
  @posts = Post.order('created_at DESC') 
  erb :index
end

get '/new' do
  @post = Post.new
  erb :new
end

post '/new' do
  @post = Post.new(params[:post])
  if @post.save
    redirect to '/'
  else
    @error = @post.errors.full_messages
    erb :new
  end
end