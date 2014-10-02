require 'sinatra'
require "sinatra/activerecord"
require_relative 'team'

set :database, {
  adapter: "postgresql",
  database: "chchruby-speed-golf",
}

get '/' do
  @holes = 1..5
  @teams = Team.order(:total)
  erb :leaderboard
end
