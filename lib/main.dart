import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Socket.IO Chat',
      home: ChatScreen(),
    );
  }
}

class Message {
  final String text;
  final String sender;

  Message({required this.text, required this.sender});
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String apiUrl = 'http://your-laravel-backend.test/api/messages';
  late List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();
  final String username = 'User1'; // Change this to distinguish users
  final int userId = 1; // This should be the ID of the user logged in

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          messages = (json.decode(response.body) as List)
              .map((data) => Message(text: data['text'], sender: data['user']['name']))
              .toList();
        });
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  Future<void> sendMessage() async {
    if (_controller.text.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'user_id': userId, 'text': _controller.text}),
        );
        if (response.statusCode == 201) {
          final newMessage = Message(text: _controller.text, sender: username);
          setState(() {
            messages.add(newMessage);
          });
          _controller.clear();
        } else {
          throw Exception('Failed to send message');
        }
      } catch (error) {
        print('Error sending message: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Application')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSender = message.sender == username;
                return ListTile(
                  title: Text(
                    message.text,
                    style: TextStyle(
                      color: isSender ? Colors.blue : Colors.black,
                      fontWeight: isSender ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    message.sender,
                    style: TextStyle(
                      color: isSender ? Colors.blue : Colors.grey,
                    ),
                  ),
                  tileColor: isSender ? Colors.lightBlue[100] : Colors.grey[200],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

