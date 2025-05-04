import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A web-compatible image compression service
class WebImageCompressionService {
  /// Simulates compressing an image for web platform
  /// Returns the original file since web doesn't support the same file operations
  static Future<File> compressImage(BuildContext context, File imageFile) async {
    try {
      if (kIsWeb) {
        // On web, we can't do the same file operations
        // Just return the original file
        debugPrint('Web platform detected, skipping compression');
        return imageFile;
      } else {
        // For non-web platforms, implement actual compression
        // This code won't be reached on web
        return imageFile;
      }
    } catch (e) {
      debugPrint('Error in web image compression: $e');
      _showErrorSnackBar(context, e.toString());
      return imageFile; // Return original if compression fails
    }
  }

  /// Shows an error message in a snackbar
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFe91e63),
      )
    );
  }
}
