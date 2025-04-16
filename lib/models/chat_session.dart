import 'package:hive/hive.dart';

import 'chat_message.dart';

part 'chat_session.g.dart';

@HiveType(typeId: 2)
class ChatSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<ChatMessage> messages;

  ChatSession({required this.id, required this.name, this.messages = const []});
}