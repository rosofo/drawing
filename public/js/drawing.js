function canvasMousePosition(canvas, clientX, clientY) {
    var rect = canvas.getBoundingClientRect();
    return { x: clientX - rect.left, y: clientY - rect.top };
}

function setupCanvas(canvas) {
    return canvas.getContext('2d');
}


// draws a path on the canvas from 
function drawStroke(ctx, positions, styles = {}) {
    $(ctx).attr(styles);
    ctx.beginPath();

    let initialPos = positions.pop();
    ctx.moveTo(initialPos.x, initialPos.y);

    positions.forEach(pos => ctx.lineTo(pos.x, pos.y));
    ctx.stroke();
}

$('#drawing').on('mousemove', e => {
    let pos = canvasMousePosition(e.target, e.clientX, e.clientY);
    $('#position').text(`${pos.x}, ${pos.y}`);
});