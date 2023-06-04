require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, { adapter: 'sqlite3', database: 'leprosorium.db' }

class Post < ActiveRecord::Base
end

class Comment < ActiveRecord::Base
end

get '/' do
  @posts = Post.order('created_at DESC') 
  erb :index
end