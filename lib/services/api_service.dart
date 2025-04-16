//filepath: lib/services/api_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class ApiService {
  final String apiKey;
  final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

  ApiService({required this.apiKey});

  /// Sends a message to the Gemini API and returns the bot's response.
  Future<String> sendMessage(String username, String userMessage, List<Map<String, String>> conversationHistory) async {
    // App-specific context to inject into every message
    var appDescription = "You are ProsperAI, ProsperAI is an innovative, cross-platform educational AI assistant designed to empower users with knowledge and task support. Developed by Adokweb Solutions, a leading software firm,  inspired by NANTEL FACHAK WUYEP a final year student being an intern of the company, as part of his requirement for the fulfilement of the partical requiremnt for the award of bachelors of science degree from Federal University of education, Pankshin. under the guidance of Adokwe Ishaq Badamasi, a seasoned programmer and data analyst with a Computer Science degree from Nasarawa State University, Keffi. ProsperAI combines cutting-edge technology with a user-friendly experience. Adokwe who is married to Saudat Adamu Jibrin (Oneshi), is currently a Program Analyst at the Federal University of Education, Pankshin, Nigeria, brings his expertise in custom software development and IT consultancy to create a tool that helps users learn, solve problems, and explore educational content. Whether you’re seeking answers, managing tasks, or discovering app features, ProsperAI is your reliable companion. For support, contact info@adokwebsolutions.com.ng, or visit the company sit at https://adokweb-solutions.b12sites.com";

    String augmentedUserMessage = userMessage;
    if (userMessage.toLowerCase().contains("help") ||
        userMessage.toLowerCase().contains("feature") ||
        userMessage.toLowerCase().contains("setting")) {
      augmentedUserMessage = "Considering this query in the context of ProsperAI: $userMessage";
    }

    // Construct the conversation history for the prompt
    String historyString = '';
    for (var message in conversationHistory) {
      historyString += 'Role: ${message['role']}, Content: ${message['content']}\n';
    }

    String combinedMessage = '$appDescription\n$historyString\nUser: $augmentedUserMessage';

    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': combinedMessage}
              ]
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        try {
          final textResponse = data['candidates'][0]['content']['parts'][0]['text'] as String;
          return textResponse;
        } catch (e) {
          throw ApiException("Sorry, I couldn't understand the response: $e");
        }
      } else {
        throw ApiException('Failed to send message: Server returned ${response.statusCode}');
      }
    } on http.ClientException {
      throw ApiException('Network error: Please check your internet connection');
    } on FormatException {
      throw ApiException('Invalid response from server');
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  /// Streams the response from the Gemini API.
  Stream<String> streamMessage(String username, String message, List<Map<String, String>> conversationHistory) async* {
    try {
      final fullResponse = await sendMessage(username, message, conversationHistory);
      final words = fullResponse.split(' ');
      for (var i = 0; i < words.length; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        yield words.sublist(0, i + 1).join(' ');
      }
    } catch (e) {
      throw ApiException('Streaming failed: $e');
    }
  }
}