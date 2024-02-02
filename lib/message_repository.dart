import 'dart:convert';

import 'package:chatgpt_image/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageRepository {
  static MessageRepository? _instance;

  MessageRepository._();

  static MessageRepository getInstance() {
    _instance ??= MessageRepository._();
    return _instance!;
  }

  // Save the message list to SharedPreferences.
  Future<void> saveMessageList(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final messageJsonList = messages.map((message) => jsonEncode(message.toJson())).toList();
    await prefs.setStringList('messages', messageJsonList);
  }

  // Get the message list from SharedPreferences.
  Future<List<Message>> getMessageList() async {
    final prefs = await SharedPreferences.getInstance();
    final messageJsonList = prefs.getStringList('messages') ?? [];
    return messageJsonList.map((messageJson) => Message.fromJson(jsonDecode(messageJson))).toList();
  }

  // Add a message to the list in SharedPreferences.
  Future<void> addMessage(Message message) async {
    final messages = await getMessageList();
    messages.add(message);
    await saveMessageList(messages);
  }

  // Delete a message from the list in SharedPreferences.
  Future<void> deleteMessage(int requestTime) async {
    final messages = await getMessageList();
    messages.removeWhere((m) => m.requestTime == requestTime);
    await saveMessageList(messages);
  }

  // clear all messages
  Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('messages');
  }
}