require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, { adapter: 'sqlite3', database: 'leprosorium.db' }

class Post < ActiveRecord::Base
  validates :content, length: { minimum: 100 }
  validates :author, presence: true
end

class Comment < ActiveRecord::Base
  validates :content, presence: true
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
  @post = Post.new(params[:add_post])
  if @post.save
    redirect to '/'
  else
    @error = @post.errors.full_messages
    erb :new
  end
end

get '/details/:post_id' do
  @post = Post.find(params[:post_id])
  @comments = Comment.where("post_id = ?", params[:post_id])
  erb :details
end

post '/details/:post_id' do
  comment = Comment.new
  comment.content = params[:content]
  comment.post_id = params[:post_id]
  comment.save

  @post = Post.find(params[:post_id])
  @comments = Comment.where("post_id = ?", params[:post_id])
  erb :details
end