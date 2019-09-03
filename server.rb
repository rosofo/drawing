require 'sinatra'
require 'require_all'
require_all './app/models/'

class Server < Sinatra::Base
end