require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'json'
require 'haml'

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

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do 
	send_file 'public/index.html'
end

post '/route' do
	@json  = params[:json]
	@route = Route.from_json(@json)
	erb :'route.html'
end

post '/route.gpx' do
	@json  = params[:json]
	@route = Route.from_json(@json)
	attachment   "#{@route.title}.gpx"
	content_type 'application/gpx+xml', :charset => 'utf-8'
	haml :'route.gpx'
end
