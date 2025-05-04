import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Constants/ApiConstants.dart';

class ChatService {
  static Future<String> chatWithAI(
      BuildContext context, String history, String prompt) async {
    try {
      debugPrint("Sending chat request with prompt: $prompt");

      // Prepare the content for Gemini API
      // The format for Gemini API is different from ChatGPT

      // Create a simple text prompt
      String fullPrompt = prompt;

      // Add history if it exists
      if (history.isNotEmpty) {
        fullPrompt = "Previous conversation: $history\n\n$prompt";
      }

      // Prepare the request body for Google's Generative AI API
      final body = {
        'contents': [
          {
            'parts': [
              {
                'text': fullPrompt
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 1024,
        }
      };

      // Make the API request
      final url = '${ApiConstants.googleGenerativeAI}/models/${ApiConstants.geminiModel}:generateContent?key=${ApiConstants.googleAIApiKey}';
      final response = await http.post(
        Uri.parse(url),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      // Log response status
      debugPrint("Chat response received with status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Extract the response text from the API response
        if (jsonResponse.containsKey('candidates') &&
            jsonResponse['candidates'].isNotEmpty &&
            jsonResponse['candidates'][0].containsKey('content') &&
            jsonResponse['candidates'][0]['content'].containsKey('parts') &&
            jsonResponse['candidates'][0]['content']['parts'].isNotEmpty) {

          return jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        } else {
          return "Sorry, I couldn't generate a response. Please try again.";
        }
      } else {
        // If API key is not set, provide a fallback response
        if (ApiConstants.googleAIApiKey == 'YOUR_GOOGLE_AI_API_KEY') {
          return "This is a simulated response. To get real AI responses, please set up your Google AI API key in ApiConstants.dart.";
        }

        debugPrint("Error response: ${response.body}");
        return "Error: ${response.statusCode}. ${response.body}";
      }
    } catch (e) {
      debugPrint("Exception in chatWithAI: $e");

      // If API key is not set, provide a fallback response
      if (ApiConstants.googleAIApiKey == 'YOUR_GOOGLE_AI_API_KEY') {
        return "This is a simulated response. To get real AI responses, please set up your Google AI API key in ApiConstants.dart.";
      }

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      var message = e.toString();
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFe91e63),
      ));
      return "Error: $e";
    }
  }
}
