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

# =============================================
# главная страница, на ней отображаем все написанные ранее посты
# =============================================
get '/' do
  redirect to '/posts/1'
end

# для следующих страниц(по 5 постов)
get '/posts/:page_id' do
  @page_id = params[:page_id]

  @posts = Post.order('created_at DESC').limit(5).offset((@page_id.to_i - 1) * 5) 
  @comment_counter = Comment.all  # для счетчика комментариев
	
	@page_counter = (Post.all.size / 5.0).ceil # общее число страниц(для переключателя) относительно постов
	erb :index			
end

# =============================================
# страница для создания нового поста
# =============================================
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

# =============================================
# страницы отдельных постов и коментариев к ним
# =============================================
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