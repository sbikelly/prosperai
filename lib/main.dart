
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/chat_message.dart';
import 'models/chat_session.dart';
import 'models/user.dart';
import 'services/api_service.dart';
import 'services/database_service.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/chat_viewmodel.dart';
import 'views/chat_screen.dart';
import 'views/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(ChatSessionAdapter());
  final dbService = DatabaseService();
  await dbService.init();
  runApp(MyApp(databaseService: dbService));
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;

  const MyApp({super.key, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    final authVM = AuthViewModel(databaseService);
    // input your GEMINI_API_KEY=your_gemini_api_key_here in the ApiService constructor placeholder
    // or use a secure method to store and retrieve it
    final geminiApiKey = 'your_gemini_api_key_here';
    final chatVM = ChatViewModel(ApiService(apiKey: geminiApiKey ), databaseService, authVM);

    return MaterialApp(
      title: 'ProsperAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(authViewModel: authVM),
        '/chat': (context) => ChatScreen(chatViewModel: chatVM, authViewModel: authVM),
      },
    );
  }
}