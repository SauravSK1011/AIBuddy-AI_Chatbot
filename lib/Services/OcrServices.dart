import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'ImageCompressionService.dart';
import 'WebOcrService.dart';
import 'WebImageCompressionService.dart';

// Import ML Kit for non-web platforms
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrServices {
  // Use different implementations based on platform
  static TextRecognizer? _textRecognizer;

  // Initialize the text recognizer if not on web
  static void _initTextRecognizer() {
    if (_textRecognizer == null && !kIsWeb) {
      _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    }
  }

  /// Extract text from an image file using Google ML Kit or web alternative
  static Future<String> gettext(BuildContext context, File file) async {
    try {
      debugPrint("Processing file for OCR: ${file.path}");

      // Use web implementation if on web platform
      if (kIsWeb) {
        return await WebOcrService.gettext(context, file);
      }

      // Initialize recognizer if needed
      _initTextRecognizer();

      // Process the image with ML Kit
      final inputImage = InputImage.fromFilePath(file.path);
      final recognizedText = await _textRecognizer!.processImage(inputImage);

      if (recognizedText.text.isEmpty) {
        return "No text detected in the image.";
      }

      return recognizedText.text;
    } catch (e) {
      debugPrint("Error in OCR processing: $e");

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

  /// Compresses an image to under 1MB and then performs OCR
  static Future<String> compressAndOcr(BuildContext context, File file) async {
    try {
      // Use different compression based on platform
      File compressedFile;
      if (kIsWeb) {
        compressedFile = await WebImageCompressionService.compressImage(context, file);
        return await WebOcrService.compressAndOcr(context, compressedFile);
      } else {
        compressedFile = await ImageCompressionService.compressImage(context, file);
        return await gettext(context, compressedFile);
      }
    } catch (e) {
      debugPrint("Error in compress and OCR: $e");

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

  /// Clean up resources when done
  static void dispose() {
    if (!kIsWeb && _textRecognizer != null) {
      _textRecognizer!.close();
      _textRecognizer = null;
    }
  }
}
