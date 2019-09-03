# drawing
Collaborative online drawing using HTML5 canvas

## User Stories
### Create a new drawing
1. Enter drawing name
2. Click create drawing button
3. Presented with new canvas

### Visit an existing drawing
1. View list of existing drawings
2. Click on one
3. Presented with a canvas rendered with stored drawing

### Draw
1. Visit a drawing
2. Presented with canvas
    - Choose brush size and color
    - Click and drag to draw
    - See changes by other users in realtime

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
- Render `stroke`s onto canvas
- List existing drawings

## Controller
- Javascript:
    - Create strokes from mouse input
    - Send and receive strokes via web socket
    - Pass new strokes to View

- Ruby:
    - Broadcast received strokes to appropriate sockets
    - Regularly save `Drawing`s
