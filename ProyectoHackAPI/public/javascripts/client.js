var socket = io('localhost:3000');

function sendAlert() {
    var user = "Username"
    socket.emit('sendAlert', user);
}

socket.on('sendInfo', (data) => {
    console.log(data);
});