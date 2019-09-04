function canvasMousePosition(canvas, clientX, clientY) {
    var rect = canvas.getBoundingClientRect();
    return { x: clientX - rect.left, y: clientY - rect.top };
}

function setCanvasListeners(canvas) {
}

$('#drawing').on('mousemove', e => {
    let pos = canvasMousePosition(e.target, e.clientX, e.clientY);
    $('#position').text(`${pos.x}, ${pos.y}`);
});