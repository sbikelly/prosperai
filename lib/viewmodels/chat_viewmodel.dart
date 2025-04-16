//filepath: lib/viewmodels/chat_viewmodel.dart

import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import 'auth_viewmodel.dart';

class ChatViewModel with ChangeNotifier {
  final ApiService _apiService;
  final DatabaseService _dbService;
  final AuthViewModel _authViewModel;
  ChatSession? _currentSession;
  bool _isStreaming = false;
  String _partialResponse = '';
  String? _errorMessage;

  ChatViewModel(this._apiService, this._dbService, this._authViewModel);

  List<ChatSession> get chatSessions => _dbService.getChatSessions(_authViewModel.currentUser!.username);
  ChatSession? get currentSession => _currentSession;
  DatabaseService get dbService => _dbService;
  String? get errorMessage => _errorMessage;
  bool get isStreaming => _isStreaming;
  List<ChatMessage> get messages => _currentSession?.messages ?? [];

  Future<void> createChatSession(String name) async {
    try {
      final session = await _dbService.createChatSession(_authViewModel.currentUser!.username, name);
      selectSession(session.id);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to create chat: ${e.toString().replaceAll('DatabaseException: ', '')}';
      notifyListeners();
    }
  }

  Future<void> deleteChatSession(String id) async {
    try {
      await _dbService.deleteChatSession(_authViewModel.currentUser!.username, id);
      if (_currentSession?.id == id) _currentSession = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete chat: ${e.toString().replaceAll('DatabaseException: ', '')}';
      notifyListeners();
    }
  }

  Future<void> deleteMessage(int index) async {
    try {
      if (_currentSession == null || index >= messages.length) return;
      _currentSession!.messages = List.from(_currentSession!.messages)..removeAt(index);
      await _dbService.updateChatSession(_authViewModel.currentUser!.username, _currentSession!);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete message: ${e.toString().replaceAll('DatabaseException: ', '')}';
      notifyListeners();
    }
  }

  Future<void> renameChatSession(String id, String newName) async {
    try {
      final session = chatSessions.firstWhere((s) => s.id == id);
      session.name = newName;
      await _dbService.updateChatSession(_authViewModel.currentUser!.username, session);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to rename chat: ${e.toString().replaceAll('DatabaseException: ', '')}';
      notifyListeners();
    }
  }

  Future<void> resendMessage(int index) async {
    try {
      if (_currentSession == null || index >= messages.length) return;
      final message = messages[index];
      if (message.isUser) await sendMessage(message.text);
    } catch (e) {
      _errorMessage = 'Failed to resend message: ${e.toString().replaceAll('DatabaseException: ', '')}';
      notifyListeners();
    }
  }

  void selectSession(String sessionId) {
    try {
      final matchingSession = chatSessions.firstWhere(
        (s) => s.id == sessionId,
        orElse: () => chatSessions.isNotEmpty ? chatSessions.first : throw Exception('No chat sessions available'),
      );
      _currentSession = matchingSession;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to select chat: $e';
      _currentSession = chatSessions.isNotEmpty ? chatSessions.first : null;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text) async {
    if (_currentSession == null || _isStreaming) return;
    _isStreaming = true;
    _errorMessage = null;
    notifyListeners();

    try {
      //debugPrint('sending message');
      final String username = _authViewModel.currentUser?.username ?? 'Guest';
      final userMessage = ChatMessage(text: text, isUser: true);
      _currentSession!.messages = List.from(_currentSession!.messages)..add(userMessage);
      await _dbService.updateChatSession(_authViewModel.currentUser!.username, _currentSession!);
      //debugPrint('message updated to the chatsession $username, $text');
      notifyListeners();

      // Convert previous messages to the expected format: List<Map<String, String>>
      final conversationHistory = _currentSession!.messages.map((msg) => {
            'role': msg.isUser ? 'user' : 'assistant',
            'content': msg.text,
          }).toList();

      //debugPrint('previous conversation ${conversationHistory.toString()}');
      _partialResponse = '';
      ChatMessage? botMessage;
      await for (final chunk in _apiService.streamMessage(username, text, conversationHistory)) {
        _partialResponse = chunk;
        if (botMessage == null) {
          botMessage = ChatMessage(text: _partialResponse, isUser: false);
          _currentSession!.messages = List.from(_currentSession!.messages)..add(botMessage);
        } else {
          botMessage = ChatMessage(text: _partialResponse, isUser: false);
          _currentSession!.messages = List.from(_currentSession!.messages)
            ..[_currentSession!.messages.length - 1] = botMessage;
        }
        await _dbService.updateChatSession(_authViewModel.currentUser!.username, _currentSession!);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error Sending Message: ${e.toString()}');
      _errorMessage = 'Message error: ${e.toString().replaceAll(RegExp(r'(ApiException|DatabaseException): '), '')}';
      debugPrint('Error Message: $_errorMessage');
      if (_currentSession != null) {
        debugPrint('Adding error message to chat session');
        _currentSession!.messages = List.from(_currentSession!.messages)
          ..add(ChatMessage(text: _errorMessage!, isUser: false));
        debugPrint('Error Message added to chat session');
      }
      notifyListeners();
    }
    _isStreaming = false;
    notifyListeners();
  }

  Future<void> updateMessage(int index, String newText) async {
    try {
      if (_currentSession == null || index >= messages.length) return;
      final message = messages[index];
      if (message.isUser) {
        _currentSession!.messages = List.from(_currentSession!.messages)
          ..[index] = ChatMessage(text: newText, isUser: true);
        await _dbService.updateChatSession(_authViewModel.currentUser!.username, _currentSession!);
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update message: ${e.toString().replaceAll('DatabaseException: ', '')}';
      notifyListeners();
    }
  }
}