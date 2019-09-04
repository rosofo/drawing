let ctx = $('#drawing')[0].getContext('2d');

function canvasMousePosition(canvas, clientX, clientY) {
    var rect = canvas.getBoundingClientRect();
    return { x: clientX - rect.left, y: clientY - rect.top };
}

// draws a path on the canvas from a `stroke`
function drawStroke(ctx, positions, styles = { lineWidth: 10, lineCap: 'round', strokeStyle: 'pink' }) {
    $(ctx).attr(styles);
    ctx.beginPath();

    let initialPos = positions.pop();
    ctx.moveTo(initialPos.x, initialPos.y);

    positions.forEach(pos => ctx.lineTo(pos.x, pos.y));
    ctx.stroke();
}

class Drawer {
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

let drawing = $('#drawing');
drawing.on('mousedown', () => {
    let drawer = new Drawer(ctx);
    drawing.on('mousemove', e => {
        let pos = canvasMousePosition(e.target, e.clientX, e.clientY);
        drawer.draw(pos);
    });
});
drawing.on('mouseup',   () => drawing.off('mousemove'));


let ws = new WebSocket('ws://localhost:9292');

ws.onmessage = msg => {
    let strokes = JSON.parse(msg.data);
    strokes.forEach(stroke => drawStroke(ctx, stroke.positions, stroke.styles));
};