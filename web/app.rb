require 'sinatra'

get '/' do
  @holes = 1..5
  @teams = {
    'DF' => {1 => 12, 4 => 5}
  }
  erb :leaderboard
end
