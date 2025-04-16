// lib/services/database_service.dart
import 'package:hive/hive.dart';

import '../models/chat_session.dart';
import '../models/user.dart';

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}

class DatabaseService {
  static const String userBoxName = 'users';
  static const String sessionBoxName = 'chatSessions';

  Future<ChatSession> createChatSession(String username, String name) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final session = ChatSession(id: id, name: name);
      final box = Hive.box<Map<String, List<ChatSession>>>(sessionBoxName);
      final userSessions = box.get(username, defaultValue: {}) ?? {};
      userSessions[username] = (userSessions[username] ?? [])..add(session);
      await box.put(username, userSessions);
      return session;
    } catch (e) {
      throw DatabaseException('Failed to create chat session: $e');
    }
  }

  Future<void> deleteChatSession(String username, String id) async {
    try {
      final box = Hive.box<Map<String, List<ChatSession>>>(sessionBoxName);
      final userSessions = box.get(username, defaultValue: {}) ?? {};
      final sessions = userSessions[username] ?? [];
      sessions.removeWhere((s) => s.id == id);
      userSessions[username] = sessions;
      if (sessions.isEmpty) {
        await box.delete(username);
      } else {
        await box.put(username, userSessions);
      }
    } catch (e) {
      throw DatabaseException('Failed to delete chat session: $e');
    }
  }

  Future<void> deleteUser(String username) async {
    try {
      await Hive.box<User>(userBoxName).delete(username);
      await Hive.box<Map<String, List<ChatSession>>>(sessionBoxName).delete(username);
    } catch (e) {
      throw DatabaseException('Failed to delete user: $e');
    }
  }

  List<User> getAllUsers() {
    try {
      return Hive.box<User>(userBoxName).values.toList();
    } catch (e) {
      throw DatabaseException('Failed to get all users: $e');
    }
  }

  List<ChatSession> getChatSessions(String username) {
    try {
      final box = Hive.box<Map<String, List<ChatSession>>>(sessionBoxName);
      return box.get(username, defaultValue: {})?[username] ?? [];
    } catch (e) {
      throw DatabaseException('Failed to get chat sessions: $e');
    }
  }

  User? getUser(String username) {
    try {
      return Hive.box<User>(userBoxName).get(username);
    } catch (e) {
      throw DatabaseException('Failed to get user: $e');
    }
  }

  Future<void> init() async {
    try {
      await Hive.openBox<User>(userBoxName);
      await Hive.openBox<Map<String, List<ChatSession>>>(sessionBoxName);
    } catch (e) {
      throw DatabaseException('Failed to initialize database: $e');
    }
  }

  Future<void> saveUser(User user) async {
    try {
      await Hive.box<User>(userBoxName).put(user.username, user);
    } catch (e) {
      throw DatabaseException('Failed to save user: $e');
    }
  }

  Future<void> updateChatSession(String username, ChatSession session) async {
    try {
      final box = Hive.box<Map<String, List<ChatSession>>>(sessionBoxName);
      final userSessions = box.get(username, defaultValue: {}) ?? {};
      final sessions = userSessions[username] ?? [];
      final index = sessions.indexWhere((s) => s.id == session.id);
      if (index != -1) {
        sessions[index] = session;
      } else {
        sessions.add(session);
      }
      userSessions[username] = sessions;
      await box.put(username, userSessions);
    } catch (e) {
      throw DatabaseException('Failed to update chat session: $e');
    }
  }
}