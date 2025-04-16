//filepath: lib/widgets/input_field.dart

import 'package:flutter/material.dart';

import '../utils/constants.dart';

class InputField extends StatefulWidget {
  final Function(String) onSend;
  final bool enabled;

  const InputField({super.key, required this.onSend, this.enabled = true});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.enabled ? 'Type your message...' : 'Waiting for response...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              enabled: widget.enabled,
              onSubmitted: (_) => widget.enabled ? _sendMessage() : null,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: widget.enabled ? AppConstants.primaryColor: AppConstants.primaryColor.shade200),
            onPressed: widget.enabled ? _sendMessage : null,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }
}