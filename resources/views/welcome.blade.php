<!-- resources/views/welcome.blade.php -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laravel and Socket.IO</title>
    <script src="/socket.io/socket.io.js"></script>
</head>
<body>
<h1>Welcome to Laravel with Socket.IO</h1>
<input id="messageInput" type="text" placeholder="Type a message">
<button onclick="sendMessage()">Send</button>
<ul id="messages"></ul>

<script>
    const socket = io('http://localhost:3000'); // Change to your Node.js server URL

    socket.on('connect', () => {
        console.log('Connected to Socket.IO server');
    });

    socket.on('message', (msg) => {
        const messagesList = document.getElementById('messages');
        const newMessage = document.createElement('li');
        newMessage.textContent = msg;
        messagesList.appendChild(newMessage);
    });

    function sendMessage() {
        const input = document.getElementById('messageInput');
        const msg = input.value;
        socket.emit('message', msg);
        input.value = ''; // Clear input field
    }
</script>
</body>
</html>

