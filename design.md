# drawing
Collaborative online drawing using HTML5 canvas

## Model
- `stroke` objects/hashes with:
    - Mouse positions
    - Color
    - Brush size

- Javascript:
    - Array of `stroke`s (on individual drawing's page)

- Ruby:
    - `Drawing` class with `name` and `stroke`s
    - `Drawing` is an `ActiveRecord`
    - `active_drawings` instance variable (array)

## View
- Render strokes onto canvas
- List existing drawings

## Controller
- Javascript:
    - Create strokes from mouse input
    - Send and receive strokes via web socket
    - Pass new strokes to View

- Ruby:
    - Broadcast received strokes to appropriate sockets
    - Regularly save `Drawing`s