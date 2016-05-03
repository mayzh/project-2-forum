require 'pry'
require 'bcrypt'
require 'pg'

module Sinatra
  class Server < Sinatra::Base
      enable :sessions

    def current_user
      @current_user ||= conn.exec("SELECT * FROM user_data WHERE id=#{session[:id]}")
    end

    def logged_in?
      current_user
    end

    get "/" do
      @topics = conn.exec("SELECT * FROM topic_data ORDER BY id DESC")
      erb :index
    end

    get "/signup" do
      erb :signup
    end

    post '/signup' do
      puts params
      @email = params[:email]
      @username = params[:username]
      @password = BCrypt::Password.create(params[:password])
      conn.exec_params("INSERT INTO user_data (username, email, password) VALUES ($1,$2,$3)", [@username, @email, @password])
      redirect "/"
    end

    get "/login" do
      erb :login
    end

    post "/login" do
      @email = params[:email]
      @password = params[:password]
      @user = conn.exec_params(
        "SELECT * FROM user_data WHERE email=$1 LIMIT 1",
        [@email]
      ).first

      if @user && BCrypt::Password::new(@user["password"]) == params[:password]
        session[:id] = @user["id"]
        redirect '/'
      else
        "Incorrect email or password!"
      end
    end

    get '/logout' do
      session.clear
      redirect '/'
    end

=begin

    get "/profile" do
      @topicposts = conn.exec("SELECT * FROM topics")
      @userposts = conn.exec("SELECT * FROM post_data")
      erb :profile
    end

    get "/topicpost" do
        if logged_in?
        erb :topicpost
        else
        "Please log in first."
      end
    end

    post "/topicpost" do
      @title = params[:title]
      @body = params[:body]
      conn.exec_params("INSERT INTO topics (title, body) VALUES ($1,$2)", [@title, @body])
      redirect '/'
    end

    get "/topicselect/:id" do
      theID = params[:id]
      @topic = conn.exec("SELECT * FROM topics WHERE id =#{theID}").first
      @comments = conn.exec("SELECT * FROM post_data WHERE topicID =#{theID}")
      erb :topicselect
    end

    post "/comment/:id" do
      if logged_in?
        @currUser = conn.exec("SELECT username FROM contact_data WHERE id=#{session[:id]}")
        @theID = params[:id]
        @comment = params[:comment]
        @topic = conn.exec("SELECT * FROM topics WHERE id =#{@theID}").first
        conn.exec("INSERT INTO post_data (username,topicID, posts) VALUES ($1,$2, $3)",[@currUser, @theID, @comment])
        redirect "/"
      else
        "Please log in to comment."
      end
    end
=end

    def conn
      if ENV["RACK_ENV"] == "production"
        PG.connect(
            dbname: ENV["POSTGRES_DB"],
            host: ENV["POSTGRES_HOST"],
            password: ENV["POSTGRES_PASS"],
            user: ENV["POSTGRES_USER"]
          )
      else
      PG.connect(dbname: "news")
      end
    end

  end
end
