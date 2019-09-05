let ctx = $('#drawing')[0].getContext('2d');

function canvasMousePosition(canvas, clientX, clientY) {
    var rect = canvas.getBoundingClientRect();
    return { x: clientX - rect.left, y: clientY - rect.top };
}

/** Rendering/Drawing **/

// draws a path on the canvas from positions with styling
function drawStroke(ctx, positions, styles = { lineWidth: 10, lineCap: 'round', strokeStyle: 'pink' }) {
    $(ctx).attr(styles);
    ctx.beginPath();

    let initialPos = positions.shift();
    ctx.moveTo(initialPos.x, initialPos.y);

    positions.forEach(pos => ctx.lineTo(pos.x, pos.y));
    ctx.stroke();
}

// iteratively draw a single path with next position
class ContinuousDrawer {
    constructor(ctx) {
        this.ctx = ctx;
        this.lastPos;
    }

    draw(nextPos) {
        if (this.lastPos === undefined) this.lastPos = nextPos;
        drawStroke(this.ctx, [this.lastPos, nextPos]);
        this.lastPos = nextPos;
    }
}


/** WebSocket **/

const ws = new WebSocket(`ws://10.218.1.7:9292/drawing?id=${drawing_id}`);

ws.onmessage = msg => {
    console.log(msg);
    let strokes = JSON.parse(msg.data);
    strokes.forEach(stroke => drawStroke(ctx, stroke.positions, stroke.styles));
};



/** listeners **/

const canvas = $('#drawing');

let positions = []; // to be sent over websocket

canvas.on('mousedown', () => {
    let drawer = new ContinuousDrawer(ctx);
    canvas.on('mousemove', e => {
        let pos = canvasMousePosition(e.target, e.clientX, e.clientY);
        drawer.draw(pos);
        positions.push(pos);
    });
});

canvas.on('mouseup', () => {
    canvas.off('mousemove');
    let stroke = {
        positions: positions,
        styles:    {}
    };
    ws.send(JSON.stringify([stroke]));
    positions = [];
});