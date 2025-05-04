import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "../Services/ChatService.dart";

class WebServices {
  // Use a free API to fetch and summarize web content
  static Future<String> websummary2(BuildContext context, String url) async {
    try {
      debugPrint("Processing URL: $url");

      // First, fetch the content of the URL
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        return "Error: Could not fetch the URL. Status code: ${response.statusCode}";
      }

      // Extract text content from HTML (simple approach)
      String htmlContent = response.body;
      String textContent = _extractTextFromHtml(htmlContent);

      // Truncate content if it's too long
      if (textContent.length > 8000) {
        textContent = textContent.substring(0, 8000);
      }

      // Use the ChatService to summarize the content
      String prompt = "Summarize the following web content in a concise way:\n\n$textContent";
      String summary = await ChatService.chatWithAI(context, "", prompt);

      return summary;
    } catch (e) {
      debugPrint("Error in websummary2: $e");

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

      return "Error processing URL: $e";
    }
  }

  // Ask questions about web content
  static Future<String> webferthercon(
      BuildContext context, String text, String question) async {
    try {
      debugPrint("Processing question about web content");

      // Use the ChatService to answer questions about the content
      String prompt = "Based on the following web content, $question\n\nContent: $text";
      String answer = await ChatService.chatWithAI(context, "", prompt);

      return answer;
    } catch (e) {
      debugPrint("Error in webferthercon: $e");

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

      return "Error processing question: $e";
    }
  }

  // Helper method to extract text from HTML
  static String _extractTextFromHtml(String html) {
    // Remove script tags and their content
    var withoutScripts = html.replaceAll(RegExp(r'<script[^>]*>[\s\S]*?</script>'), '');

    // Remove style tags and their content
    var withoutStyles = withoutScripts.replaceAll(RegExp(r'<style[^>]*>[\s\S]*?</style>'), '');

    // Remove HTML tags
    var withoutTags = withoutStyles.replaceAll(RegExp(r'<[^>]*>'), ' ');

    // Replace multiple spaces with a single space
    var singleSpaced = withoutTags.replaceAll(RegExp(r'\s+'), ' ');

    // Decode HTML entities
    var decoded = _decodeHtmlEntities(singleSpaced);

    return decoded.trim();
  }

  // Helper method to decode HTML entities
  static String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
  }
}
