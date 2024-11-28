// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/io.dart';
//
// class WebSocketService {
//   final String url;
//   late WebSocketChannel channel;
//
//   WebSocketService(this.url) {
//     channel = IOWebSocketChannel.connect(url);
//   }
//
//   void sendMessage(String message) {
//     channel.sink.add(message);
//   }
//
//   Stream get stream => channel.stream;
//
//   void dispose() {
//     channel.sink.close();
//   }
// }