require_relative '../app/models/drawing.rb'

strokes = [
    {
        positions: [[1,2],[2,2],[3,2]],
        color:     'black',
        size:      '10'
    },
    {
        positions: [[1,3],[2,3],[3,3]],
        color:     'grey',
        size:      '9'
    }
]

foo = Drawing.create(name: 'foo', strokes: strokes)