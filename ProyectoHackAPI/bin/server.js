var io = require('socket.io')();

io.sockets.on('connection', function(socket) {
    
    console.log("Nuevo cliente conectado con id: " + socket.id);
    
    socket.on('sendAlert', function(data) {
        socket.emit('sendInfo', data);
    });
});

module.exports = io;