require "sinatra/base"
require "sinatra/reloader"
require_relative "server"
require "bcrypt"
run Sinatra::Server
