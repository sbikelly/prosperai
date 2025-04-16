//filepath: lib/widgets/message_bubble.dart

import 'package:flutter/material.dart';

import '../utils/constants.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final VoidCallback onDelete;
  final Function(String) onUpdate;
  final VoidCallback onResend;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isUser,
    required this.onDelete,
    required this.onUpdate,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showModalBottomSheet(
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUser)
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      String newText = text;
                      return AlertDialog(
                        title: const Text('Edit Message'),
                        content: TextField(
                          controller: TextEditingController(text: text),
                          onChanged: (value) => newText = value,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              onUpdate(newText);
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                onDelete();
                Navigator.pop(context);
              },
            ),
            if (isUser)
              ListTile(
                leading: const Icon(Icons.send),
                title: const Text('Resend'),
                onTap: () {
                  onResend();
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser ? AppConstants.primaryColor.shade300 : AppConstants.secondaryColor.shade500,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}