import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/entities/message.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> message = [
    Message(text: 'Hola Amor ❤️', fromWho: FromWho.me ),
    Message(text: 'Ya regresaste a la casa?', fromWho: FromWho.me ),
  ];

  List<Message> get messageList => message;

  Future<void> sendMessage( String text ) async {
    //
  }
}