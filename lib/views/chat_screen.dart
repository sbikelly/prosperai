//filepath: lib/views/chat_screen.dart

import 'package:flutter/material.dart';

import '../models/chat_session.dart';
import '../utils/constants.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../widgets/input_field.dart';
import '../widgets/message_bubble.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'user_management_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatViewModel chatViewModel;
  final AuthViewModel authViewModel;

  const ChatScreen({super.key, required this.chatViewModel, required this.authViewModel});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProsperAI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppConstants.primaryColor,
        actions: [
          if (widget.chatViewModel.currentSession != null) _addChatButton(),
        ],
      ),
      drawer: _buildDrawer(),
      body: widget.chatViewModel.currentSession == null
          ? const Center(child: Text('No chat selected'))
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.secondaryColor,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.chatViewModel.currentSession!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: widget.chatViewModel.messages.length + (widget.chatViewModel.isStreaming ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < widget.chatViewModel.messages.length) {
                        final message = widget.chatViewModel.messages[index];
                        return MessageBubble(
                          text: message.text,
                          isUser: message.isUser,
                          onDelete: () => widget.chatViewModel.deleteMessage(index),
                          onUpdate: (newText) => widget.chatViewModel.updateMessage(index, newText),
                          onResend: () => widget.chatViewModel.resendMessage(index),
                        );
                      }
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),
                InputField(
                  onSend: widget.chatViewModel.sendMessage,
                  enabled: widget.chatViewModel.chatSessions.isNotEmpty || !widget.chatViewModel.isStreaming,
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    widget.chatViewModel.removeListener(_update);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.chatViewModel.addListener(_update);
    // Defer initialization until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (widget.chatViewModel.chatSessions.isEmpty) {
          await widget.chatViewModel.createChatSession('Default Chat');
        }
        widget.chatViewModel.selectSession(widget.chatViewModel.chatSessions.first.id);
      } catch (e) {
        if (mounted) { // Ensure the widget is still mounted before showing SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Initialization error: $e')),
          );
        }
      }
    });
  }

  Widget _addChatButton() {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            String name = '';
            return AlertDialog(
              title: const Text('New Chat'),
              content: TextField(
                onChanged: (value) => name = value,
                decoration: const InputDecoration(hintText: 'Chat Name'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (name.isNotEmpty) {
                      widget.chatViewModel.createChatSession(name);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('New Chat'),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppConstants.primaryColor),
            child: const Text(
              'ProsperAI',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ...widget.chatViewModel.chatSessions.map(
            (session) => ListTile(
              title: Text(session.name),
              onTap: () {
                widget.chatViewModel.selectSession(session.id);
                Navigator.pop(context);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _renameSession(session),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.chatViewModel.deleteChatSession(session.id);
                      if (widget.chatViewModel.chatSessions.isNotEmpty) {
                        widget.chatViewModel.selectSession(widget.chatViewModel.chatSessions.first.id);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Profile'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(authViewModel: widget.authViewModel))),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
          ListTile(
            title: const Text('Manage Users'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserManagementScreen(databaseService: widget.chatViewModel.dbService))),
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              widget.authViewModel.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }

  void _renameSession(ChatSession session) {
    String newName = session.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Chat'),
        content: TextField(
          onChanged: (value) => newName = value,
          controller: TextEditingController(text: session.name),
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.chatViewModel.renameChatSession(session.id, newName);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _update() {
    setState(() {
      if (widget.chatViewModel.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.chatViewModel.errorMessage!)),
        );
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}