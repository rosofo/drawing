require 'sinatra'
require 'sinatra-websocket'
require 'active_record'
require 'sinatra/activerecord'
require 'require_all'
require 'json'

require 'pg'

require_all './app/models/'


class Server < Sinatra::Base
    set :sockets, {}

    def initialize
        @drawings = Drawing.all.to_a
        @websocket_domain = ENV['WEBSOCKET_DOMAIN']

        if @websocket_domain.nil? || @websocket_domain.empty?
            raise "Please set WEBSOCKET_DOMAIN in the environment" 
        end

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

                    unless settings.sockets[id].nil?
                        settings.sockets[id] << ws
                    else
                        settings.sockets[id] = [ws]
                    end

                    ws.send(drawing.strokes.to_json)
                end

                ws.onmessage do |msg|
                    foo = drawing.strokes.to_s
                    drawing.strokes += JSON.parse(msg)
                    bar = drawing.strokes.to_s

                    sockets = settings.sockets[id].reject { |s| s == ws }
                    sockets.each { |s| s.send(msg) }
                    p msg
                end

                ws.onclose do
                    puts 'closed'
                    settings.sockets[id].delete ws

                    if settings.sockets[id].empty?
                        drawing.save
                    end
                end
            end
        else
            erb :drawing, locals: { drawing: drawing, websocket_domain: @websocket_domain }
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