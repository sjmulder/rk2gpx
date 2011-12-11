require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'rack-canonical-host'
require 'sinatra/r18n'
require './rk2gpx'

HOST = nil

if settings.environment == :production
	HOST = 'rk2gpx.hyzkia.com'
end

use Rack::CanonicalHost, HOST unless HOST.nil?

set :erb, :layout => :'layout.html'
set :default_locale, 'en'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def host
  	settings.environment == :production ?
  		'rk2gpx.hyzkia.com' :
  		'localhost:9292'
  end

  def bookmarklet
  	"(function(){var d=document,s=d.createElement('script');s.setAttribute('src','http://#{host}/bm.js');d.body.appendChild(s);})()"
  end

  def with_route
  	@json = params[:json]
  	@route = @json.nil? ? nil : Route.from_json(@json)
  end
end

get '/' do 
	erb :'index.html'
end

get '/bm.js' do
	erb :'bm.js', :layout => false
end

post '/route' do
	with_route
	erb :'route.html'
end

post '/route.gpx' do
	with_route
	content_type 'application/gpx+xml', :charset => 'utf-8'
	attachment   "#{@route.title}.gpx"
	haml :'route.gpx'
end
