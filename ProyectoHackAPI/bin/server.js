var io = require('socket.io')();

io.sockets.on('connection', function(socket) {
    
    console.log("Nuevo cliente conectado con id: " + socket.id);
    
    socket.on('sendData', function(data) {
        
    });
});

module.exports = io;