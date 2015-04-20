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
      erb :error
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
  	new_group = Group.new(:group_name => params[:group_name])
  	new_group.save
  	redirect ("group/#{new_group: group.id}")
  end

  get '/groups/:id' do
  	Group.find(params[:id])
  	erb :group
  end

end
