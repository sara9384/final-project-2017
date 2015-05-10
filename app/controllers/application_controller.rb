require './config/environment'
require './app/models/user'
require './app/models/message'
require './app/models/group'
require 'sinatra'
require 'bcrypt'

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
    @user = User.find_by(:username => params[:username])
    if @user.password == params[:password]
      session[:user_id] = @user.id
      redirect('/user')
    else
      erb :login_error
    end
  end

  post '/signup' do
    new_user = User.new(:username => params[:username], :email => params[:email])
    new_user.password = params[:password]
    new_user.save!
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
    new_group.password = params[:password]
    new_group.save!
    session[:group_id] = new_group.id
    redirect ("/group/#{new_group.id}")
  end

  post '/grouplogin' do
    @group = Group.find_by(:group_name =>params[:group_name])
    if @group.password == params[:password]
      session[:group_id] = @group.id
      redirect("/group/#{@group.id}")
    else
      erb :group_error
    end
  end

  get '/group/:id' do
    Group.find(params[:id])
      if session[:user_id]
      @logged_in_user = User.find(session[:user_id])
    end
    if session[:group_id]
      @logged_in_group = Group.find(session[:group_id])
    end
    @group = Group.find(session[:group_id])
    @messages = @group.messages
    @users = User.all
    erb :group
  end

  post '/messages' do
    new_message = Message.new(:user_id => params[:user_id], :group_id => params[:group_id], :message => params[:message])
    new_message.save
    redirect("/group/#{params[:group_id]}")
  end

  get '/forgot' do
    erb :forgot
  end

  post '/forgot_password' do
    @user = User.find_by_email(params[:email])
    random_password = Array.new(10).map { (65 + rand(58)).chr }.join
    @user.temp_password = random_password
    @user.save!
    RestClient.post "https://api:key-03ddff059dae45d8bb16221abff9736d"\
      "@api.mailgun.net/v3/sandbox8dd8b1ae6fb6478fb2b5812bd92bb78a.mailgun.org/messages",
      :from => "Mailgun Sandbox <postmaster@sandbox8dd8b1ae6fb6478fb2b5812bd92bb78a.mailgun.org>",
    :to => "#{@user.email}",
    :subject => "Temporary Password",
    :text => "Your temporary password is: #{@user.temp_password}"
    redirect('/reset')
  end

  post '/reset' do
    @user = User.find_by_temp_password(params[:temp_password])
    @user.password = params[:password]
    @user.save!
    redirect('/')
  end

  get '/reset' do
    erb :reset
  end
end
