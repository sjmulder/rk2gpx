require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'rack-canonical-host'
require 'app/rk2gpx'

set :root, File.dirname(__FILE__) + '/..'
set :erb, :layout => :'layout.html'

if settings.environment == :production
	use Rack::CanonicalHost, 'rk2gpx.hyzkia.com'
end

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
end

get '/' do 
	erb :'index.html'
end

get '/bm.js' do
	erb :'bm.js', :layout => false
end

post '/route' do
	@json  = params[:json]
	@route = Route.from_json(@json)
	erb :'route.html'
end

post '/route.gpx' do
	@json  = params[:json]
	@route = Route.from_json(@json)
	content_type 'application/gpx+xml', :charset => 'utf-8'
	attachment   "#{@route.title}.gpx"
	haml :'route.gpx'
end
