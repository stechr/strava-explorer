require 'rubygems'
require 'sinatra'

require 'omniauth'
require 'omniauth-strava'


require_relative './libs/strava_lib.rb'


unless ENV["STRAVA_CLIENT_ID"] && ENV["STRAVA_CLIENT_SECRET"]
  abort("missing env vars: please set STRAVA_CLIENT_ID and STRAVA_CLIENT_SECRET with your app credentials")
end

configure do
  set :sessions, true
  set :inline_templates, true
  set :sl, StravaLib.new(nil)
end

#TODO read keys from configuration
use OmniAuth::Builder do
    provider :strava, ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET'] 
end

before '/views/*' do
  puts "checking"
  if !session[:authenticated] then
    erb "<h1> You need to login first </h1>"
  end
    settings.sl.set_access_token(session[:access_token])
end

get '/' do
  erb "<h1>Login and have a view ...</h1>"
end

get '/auth/:provider/callback' do
    session[:authenticated] = true
    session[:access_token] = request.env['omniauth.auth']['credentials']['token']
    settings.sl.set_access_token(session[:access_token])
    erb "<h1>Authentication was successful</h1>"
end

get '/views/me' do
  me = settings.sl.get_current_athlete
  my_hash = JSON.parse(me)

  erb :data_view, :locals => {:data => JSON.pretty_generate(my_hash), :title => "Me"}, :layout => :layout 
end

get '/views/friends' do
  friends = settings.sl.get_friends_of_current_athlete
  my_hash = JSON.parse(friends)

  erb :data_view, :locals => {:data => JSON.pretty_generate(my_hash), :title => "My Friends"}, :layout => :layout
end

get '/views/koms' do
  me = JSON.parse (settings.sl.get_current_athlete)

  koms = settings.sl.get_koms(me['id'])
  my_hash = JSON.parse(koms)

  erb :data_view, :locals => {:data => JSON.pretty_generate(my_hash), :title => "My Koms"}, :layout => :layout  
end

get '/views/activities' do
  activities = settings.sl.get_activities_of_current_athlete
  my_hash = JSON.parse(activities)

  erb :data_view, :locals => {:data => JSON.pretty_generate(my_hash), :title =>"My Activities"}, :layout => :layout
end

get'/views/followers' do
  followers = settings.sl.get_friends_of_current_athlete
  my_hash = JSON.parse(followers)

  erb :data_view, :locals => {:data => JSON.pretty_generate(my_hash), :title =>"My Followers"}
end