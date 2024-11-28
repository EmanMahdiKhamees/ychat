const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');
const mysql = require('mysql');

const app = express();
app.use(cors());

const server = http.createServer(app);
const io = socketIo(server);

// MySQL connection
const db = mysql.createConnection({
    host: 'localhost', // Your MySQL host
    user: 'admin', // Your MySQL user
    password: 'Eman1234', // Your MySQL password
    database: 'chat_db' // Your database name
});

db.connect((err) => {
    if (err) throw err;
    console.log('MySQL Connected...');
});

io.on('connection', (socket) => {
    console.log('A user connected');

    // Fetch existing messages when a user connects
    db.query('SELECT * FROM messages ORDER BY created_at DESC', (err, results) => {
        if (err) throw err;
        socket.emit('previousMessages', results);
    });

    socket.on('message', (data) => {
        console.log('Message received: ', data);
        // Store message in the database
        db.query('INSERT INTO messages (text, sender) VALUES (?, ?)', [data.text, data.sender], (err, result) => {
            if (err) throw err;
            // Broadcast the message to all clients
            io.emit('message', data);
        });
    });

    socket.on('disconnect', () => {
        console.log('User disconnected');
    });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
