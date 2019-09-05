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

    def initialize
        @drawings = Drawing.all.to_a
        super
    end

    get '/' do
        erb :index, locals: { drawings: @drawings }
    end

    get '/drawing' do
        id = params['id']
        drawing = @drawings.find { |drawing| drawing.id == id.to_i }

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
                    drawing.strokes += JSON.parse(msg)
                    settings.sockets.reject { |s| s == ws }.each { |s| s.send(msg) }
                    p drawing
                    p msg
                end

                ws.onclose do
                    puts 'closed'
                    settings.sockets.delete ws
                end
            end
        else
            erb :drawing, locals: { drawing: drawing }
        end
    end

    post '/drawings/create' do
        name = params['name']
        drawing = Drawing.create(name: name, strokes: [])
        @drawings << drawing

        redirect "/drawing?id=#{drawing.id}"
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

end