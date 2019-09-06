let ctx = $('#drawing')[0].getContext('2d');
let styles = { lineWidth: 10, lineCap: 'round', strokeStyle: 'pink' };

function canvasMousePosition(canvas, clientX, clientY) {
    var rect = canvas.getBoundingClientRect();
    return { x: clientX - rect.left, y: clientY - rect.top };
}

/** Rendering/Drawing **/

// draws a path on the canvas from positions with styling
function drawStroke(ctx, positions, styles = {}) {
    $(ctx).attr(styles);
    ctx.beginPath();

    let initialPos = positions.shift();
    ctx.moveTo(initialPos.x, initialPos.y);

    positions.forEach(pos => ctx.lineTo(pos.x, pos.y));
    ctx.stroke();
}

// iteratively draw a single path with next position
class ContinuousDrawer {
    constructor(ctx, styles) {
        this.ctx = ctx;
        this.styles = styles;
        this.lastPos;
    }

    draw(nextPos) {
        if (this.lastPos === undefined) this.lastPos = nextPos;
        drawStroke(this.ctx, [this.lastPos, nextPos], styles);
        this.lastPos = nextPos;
    }
}


/** WebSocket **/

const ws = new WebSocket(`ws://${websocket_domain}/drawing?id=${drawing_id}`);

ws.onmessage = msg => {
    console.log(msg);
    let strokes = JSON.parse(msg.data);
    strokes.forEach(stroke => drawStroke(ctx, stroke.positions, stroke.styles));
};



/** listeners **/

const canvas = $('#drawing');

let positions = []; // to be sent over websocket

canvas.on('mousedown', () => {
    let drawer = new ContinuousDrawer(ctx, styles);
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
        styles:    styles
    };
    ws.send(JSON.stringify([stroke]));
    positions = [];
});

/** UI **/
$('#size_display').text($('#size').value);
$('#size').on('input', e => $('#size_display').text(e.target.value));
$('#size').on('change', e => styles['lineWidth'] = e.target.value);
$('#color').on('change', e => styles['strokeStyle'] = e.target.value);