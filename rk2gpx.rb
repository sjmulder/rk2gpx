require 'json'

class Route
	attr :title,  true
	attr :points, true

	def self.from_json(json)
		model = JSON.parse(json)
		route = Route.new
		route.title  = model['title']
		route.points = model['points'].map do |dp|
			wp = Waypoint.new
			wp.lat  = dp['latitude']
			wp.long = dp['longitude']
			wp.elevation = dp['altitude']
			wp
		end
		route
	end
end

class Waypoint
	attr :lat, true
	attr :long, true
	attr :elevation, true
end
