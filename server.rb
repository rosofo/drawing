require 'sinatra'
require 'sinatra-websocket'
require 'active_record'
require 'sinatra/activerecord'
require 'require_all'
require 'json'
require 'pry'

require_all './app/models/'


$test_drawing = Drawing.create(name: 'bar', strokes: [])

class Server < Sinatra::Base
    set :sockets, []

    get '/drawing' do
        id = params['id']
        drawing = $test_drawing

        puts 'ok'
        if request.websocket?
            puts 'websocket initialize'

            request.websocket do |ws|
                p 'creating listeners'
                ws.onopen do
                    puts 'opened'
                    settings.sockets << ws
                    ws.send(drawing.strokes.to_json)
                end

                ws.onmessage do |msg|
                    settings.sockets.reject { |s| s == ws }.each { |s| s.send(msg) }
                    drawing.strokes += JSON.parse(msg)
                end

                ws.onclose do
                    puts 'closed'
                    settings.sockets.delete ws
                end
            end
        else
            erb :drawing, locals: { id: id }
        end
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