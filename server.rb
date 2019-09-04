require 'sinatra'
require 'active_record'
require 'sinatra/activerecord'
require 'require_all'
require 'json'
require 'pry'

require_all './app/models/'

class Server < Sinatra::Base
    get '/drawing' do
        erb :drawing, locals: { drawing: params['id'] }
    end

    get '/drawings/all' do
        drawings = Drawing.all.map do |drawing|
            { name: drawing.name, strokes: drawing.strokes }
        end

        drawings.to_json
    end

    get '/drawings/:id' do |id|
        drawing = Drawing.find_or_initialize_by(id: id)
        { name: drawing.name, strokes: drawing.strokes }.to_json
    end

    post '/drawings/:id' do
        data = JSON.read(params['drawing'])
        drawing = Drawing.find(id)
        drawing.name    = data['name']
        drawing.strokes = data['strokes']
    end

    post '/drawings/new' do
        data = JSON.read(params['drawing'])
        drawing = Drawing.create(name: data['name'], strokes: data['strokes'])
    end
end