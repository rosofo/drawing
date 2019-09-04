function canvasMousePosition(canvas, clientX, clientY) {
    var rect = canvas.getBoundingClientRect();
    return { x: clientX - rect.left, y: clientY - rect.top };
}

$('#drawing').on('mousemove', e => {
    console.log(canvasMousePosition(e.target, e.clientX, e.clientY));
});