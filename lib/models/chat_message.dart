import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 1)
class ChatMessage {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
        text: map['text'],
        isUser: map['isUser'],
      );

  Map<String, dynamic> toMap() => {'text': text, 'isUser': isUser};
}