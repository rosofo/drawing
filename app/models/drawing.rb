require 'active_record'

class Drawing < ActiveRecord::Base
    serialize :strokes, Array
end