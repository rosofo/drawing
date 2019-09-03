require 'sinatra'
require 'active_record'
require 'sinatra/activerecord'
require 'require_all'
require_all './app/models/'

class Server < Sinatra::Base
    get '/' do
    end
end