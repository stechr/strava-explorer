require 'json'
require 'rest-client'

class StravaLib

	@@BASE_URL = "https://www.strava.com/api/v3/"

	def get_request(url)
		document = nil
		RestClient.get(@@BASE_URL+url, {:authorization =>"Bearer #{@access_token}"}) { |response, request, result, &block|				
			document = response
		}
		return document
	end

	def initialize(access_token)
        @access_token = access_token
    end  

    def set_access_token(access_token)
    	@access_token = access_token
    end

	def get_current_athlete()
		get_request("athlete")
	end

	def get_athlete(athlete_id)
		get_request("athletes/"+athlete_id)
	end

	def get_friends_of_current_athlete()
		get_request("athlete/friends")
	end

	def get_friends(athlete_id)
		get_request("athletes/#{athlete_id}/friends")
	end

	def get_followers_of_current_athlete()
		get_request("athlete/followers")
	end

	def get_followers(athlete_id)
		get_request("athletes/#{athlete_id}/followers")
	end

	def get_mutual_followers(athlete_id)
		get_request("athletes/#{athlete_id}/both-following")
	end
	
	def get_koms_of_current_athlete()
		# not supported by the API
		get_request("athlete/koms")
	end

	def get_koms(athlete_id)
		get_request("athletes/#{athlete_id}/koms")	
	end

	def get_activities_of_current_athlete()
		get_request("athlete/activities")
	end

	def get_activities_of_friends_of_current_athlete()
		get_request("activities/following")
	end

	def get_activity(activitiy_id)
		get_request("activities/#{activitiy_id}")
	end

	def get_activity_laps(activitiy_id)
		get_request("activities/#{activitiy_id}/laps")
	end

	def get_activity_zones(activity_id)
		get_request("activities/#{activity_id}/zones")
	end
end
