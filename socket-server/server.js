// socket-server/server.js
const express = require('express');
const http = require('http');
const socketIo = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

// Serve static files (like HTML, CSS, JS) if needed
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html'); // Create an index.html in the socket-server folder
});

io.on('connection', (socket) => {
    console.log('A user connected');

    socket.on('message', (msg) => {
        console.log('Message received: ' + msg);
        io.emit('message', msg); // Broadcast the message to all clients
    });

    socket.on('disconnect', () => {
        console.log('User disconnected');
    });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});

