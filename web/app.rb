require 'sinatra'
require "sinatra/activerecord"
require_relative 'team'
require_relative '../config'

set :database, {
  adapter: "postgresql",
  database: "chchruby-speed-golf",
}

get '/' do
  @holes = HOLES
  @teams = Team.order('total DESC')
  erb :leaderboard
end
