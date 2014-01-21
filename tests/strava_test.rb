require_relative '../libs/strava_lib.rb'

def pretty_print(document)
	my_hash = JSON.parse(document)
	puts "#{JSON.pretty_generate(my_hash)}"
end

def write_to_file(document, filename)
	aFile = File.new("./data/"+filename, "w")
	aFile.write(document)
	aFile.close
end

def process_result(document, outputname)
	puts outputname + ":"
	pretty_print document
	write_to_file document, outputname+".json"
end


unless ENV["STRAVA_ACCESS_TOKEN"]
  abort("missing env vars: please set STRAVA_ACCESS_TOKEN")
end

sl= StravaLib.new ENV['STRAVA_ACCESS_TOKEN']

current_athlete = sl.get_current_athlete 
process_result current_athlete, "current_athlete"
me = JSON.parse(current_athlete)['id'].to_s

process_result sl.get_athlete(me), "athlete_#{me}"

process_result sl.get_friends_of_current_athlete, "friends_of_current_athlete"

process_result sl.get_friends(me), "friends_of_athlete_#{me}"

process_result sl.get_followers_of_current_athlete, "followers_of_current_ahtlete"

process_result sl.get_followers(me), "followers_of_athlete_#{me}"

process_result sl.get_mutual_followers(me), "mutual_followers_of_athlete_#{me}"

process_result sl.get_koms(me), "koms_of_athlete_#{me}"

activities = sl.get_activities_of_friends_of_current_athlete
process_result activities, "activities_of_friends_of_current_athlete"
activity_id = JSON.parse(activities)[0]['id'].to_s

process_result sl.get_activity(activity_id), "activity_#{activity_id}"

process_result sl.get_activity_laps(activity_id), "activity_laps"

process_result sl.get_activity_zones(activity_id), "activity_zones"