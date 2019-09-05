require 'sinatra'
require 'sinatra-websocket'
require 'active_record'
require 'sinatra/activerecord'
require 'require_all'
require 'json'
require 'pry'

require_all './app/models/'

class Server < Sinatra::Base
    set :sockets, []

    get '/' do
        puts 'ok'
        if request.websocket?
            puts 'websocket initialize'

            request.websocket do |ws|
                p 'creating listeners'
                ws.onopen do
                    puts 'opened'
                    settings.sockets << ws
                end

                ws.onmessage do |msg|
                    settings.sockets.reject { |s| s == ws }.each { |s| s.send(msg) }
                end

                ws.onclose do
                    puts 'closed'
                    settings.sockets.delete ws
                end
            end
        end
    end

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