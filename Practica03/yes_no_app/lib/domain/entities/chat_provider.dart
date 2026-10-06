import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yes_no_app/domain/entities/message.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  final List<Message> messageList = [];

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messageList.add(Message(text: text, fromWho: FromWho.me));
    final responseIndex = messageList.length;
    messageList.add(
      Message(text: '', fromWho: FromWho.her, isLoading: true),
    );
    notifyListeners();
    moveScrollToBottom();

    try {
      final response = await http
          .get(Uri.https('yesno.wtf', ''))
          .timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) {
        throw Exception('La API respondió con código ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final answer = (data['answer'] as String).toLowerCase();
      if (!{'yes', 'no', 'maybe'}.contains(answer)) {
        throw FormatException('Respuesta desconocida de la API: $answer');
      }
      final imageUrl = data['image'] as String;
      final parsedImageUrl = Uri.tryParse(imageUrl);
      if (parsedImageUrl == null ||
          parsedImageUrl.scheme != 'https' ||
          parsedImageUrl.host.isEmpty) {
        throw const FormatException('La API devolvió una URL de imagen inválida');
      }
      final isMaybe = answer == 'maybe';

      messageList[responseIndex] = Message(
        text: isMaybe ? 'Tal vez' : (answer == 'yes' ? 'Sí' : 'No'),
        imageUrl: isMaybe
            ? 'https://media.tenor.com/R_m5yodt5mEAAAAM/crazy-love.gif'
            : imageUrl,
        fromWho: FromWho.her,
      );
    } catch (error, stackTrace) {
      developer.log(
        'No se pudo obtener la respuesta de yesno.wtf',
        error: error,
        stackTrace: stackTrace,
        name: 'ChatProvider',
      );
      messageList[responseIndex] = Message(
        text: 'Error al consultar yesno.wtf: $error',
        fromWho: FromWho.her,
      );
    }

    notifyListeners();
    moveScrollToBottom();
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!chatScrollController.hasClients) return;
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
