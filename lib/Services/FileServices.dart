import "dart:io";
import "package:flutter/material.dart";
import "../Services/ChatService.dart";
import "../Services/OcrServices.dart";
import "../Services/LocalTextSummarizerService.dart";
import "ImageCompressionService.dart";

class FileServices {
  /// Process a text file and generate a summary
  static Future<String> myfilesummary(BuildContext context, File file) async {
    try {
      debugPrint("Processing file: ${file.path}");

      // Read the file content
      String fileContent = await file.readAsString();

      // If the file is small, use local summarization
      if (fileContent.length < 10000) {
        return LocalTextSummarizerService.summarizeText(fileContent, maxSentences: 5);
      } else {
        // For larger files, use the ChatService
        String prompt = "Summarize the following text in a concise way:\n\n$fileContent";
        return await ChatService.chatWithAI(context, "", prompt);
      }
    } catch (e) {
      debugPrint("Error in file summary: $e");

      // Try OCR if the file couldn't be read as text (might be an image)
      try {
        return await processImageFile(context, file);
      } catch (innerError) {
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
        return "Error processing file: $e";
      }
    }
  }

  /// Process an image file that contains text
  static Future<String> processImageFile(BuildContext context, File file) async {
    try {
      // First compress the image
      File compressedFile = await ImageCompressionService.compressImage(context, file);

      // Extract text using OCR
      String extractedText = await OcrServices.gettext(context, compressedFile);

      // If OCR found text, summarize it
      if (extractedText.isNotEmpty && extractedText != "No text detected in the image.") {
        if (extractedText.length < 5000) {
          return "Extracted text from image:\n\n$extractedText";
        } else {
          // For longer text, generate a summary
          String summary = LocalTextSummarizerService.summarizeText(extractedText, maxSentences: 5);
          return "Summary of text from image:\n\n$summary\n\nFull extracted text:\n$extractedText";
        }
      } else {
        return "No text could be extracted from this image.";
      }
    } catch (e) {
      debugPrint("Error in image file processing: $e");
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
      return "Error processing image: $e";
    }
  }

  /// Compresses an image and processes it for text extraction and summarization
  static Future<String> compressAndSummarize(BuildContext context, File file) async {
    try {
      return await processImageFile(context, file);
    } catch (e) {
      debugPrint("Error in compress and summarize: $e");
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
      return "Error processing file: $e";
    }
  }

  /// Backward compatibility method - now uses the new processImageFile method
  static Future<String> compressAndSendSummary(BuildContext context, File file) async {
    try {
      return await processImageFile(context, file);
    } catch (e) {
      debugPrint("Error in compress and send summary: $e");
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
      return "Error processing file: $e";
    }
  }
}
