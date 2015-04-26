require './config/environment'
require './app/models/user'
require './app/models/message'
require './app/models/group'
require 'pry'
require 'sinatra'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
      enable :sessions
    set :session_secret, 'flatironrulz'
  end

  get '/' do
    erb :home
  end

 post '/login' do
    @user = User.find_by(:username => params[:username], :password => params[:password])
    if @user
      session[:user_id] = @user.id
      redirect('/user')
    else
      erb :login_error
    end
  end

  post '/signup' do
  	new_user = User.new(:username => params[:username], :password => params[:password], :email => [:email])
  	new_user.save
  	session[:user_id] = new_user.id
  	redirect ('/user')
  end

  get '/user' do
  	if session[:user_id]
  		@logged_in_user = User.find(session[:user_id])
  	end
  	erb :user
  end

   post '/create_group' do
    new_group = Group.new(:group_name => params[:group_name], :group_password => params[:group_password])
    new_group.save
    session[:group_id] = new_group.id
    redirect ('/group')
  end

  post '/grouplogin' do
    @group = Group.find_by(:group_name =>params[:group_name], :group_password => params[:group_password])
    if @group
      session[:group_id] = @group.id
      redirect('/group')
    else
      erb :group_error
    end
  end

  get '/group' do
    if session[:user_id]
      @logged_in_user = User.find(session[:user_id])
    end
    if session[:group_id]
      @logged_in_group = Group.find(session[:group_id])
    end
    erb :group
  end

  post '/messages' do
  new_message = Message.new(:user_id => params[:user_id], :message => params[:message])
    new_message.save
    redirect ('/group')
  end

end
