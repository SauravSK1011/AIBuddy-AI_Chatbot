import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloudinary/cloudinary.dart';
import "../Constants/ApiConstants.dart";
import "../Services/ChatService.dart";
import "ImageCompressionService.dart";
import "LocalImageLabelingService.dart";

class ImageRecognitionServices {

  /// Recognize objects in an image using Cloudinary and ChatGPT
  static Future<String> recognize(BuildContext context, File file) async {
    try {
      debugPrint("Processing image for recognition");

      // First, upload to Cloudinary to get a URL
      final cloudinary = Cloudinary.signedConfig(
        apiKey: ApiConstants.cloudinaryApiKey,
        apiSecret: ApiConstants.cloudinaryApiSecret,
        cloudName: ApiConstants.cloudinaryCloudName,
      );

      final response = await cloudinary.upload(
        file: file.path,
        fileBytes: file.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder: "aibuddy-images",
        fileName: 'image_${DateTime.now().millisecondsSinceEpoch}',
      );

      debugPrint("Image uploaded to: ${response.secureUrl}");

      // Use ChatGPT to analyze the image URL
      String prompt = "Analyze this image and tell me what objects or scenes you can identify in it. The image is available at: ${response.secureUrl}";
      String analysis = await ChatService.chatWithAI(context, "", prompt);

      return analysis;
    } catch (e) {
      debugPrint("Error in image recognition: $e");

      // If Cloudinary upload fails, use local object detection simulation
      try {
        return await _simulateLocalObjectDetection(context, file);
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
        return "Error recognizing image: $e";
      }
    }
  }

  /// Compresses an image and then recognizes objects in it
  static Future<String> compressAndRecognize(BuildContext context, File file) async {
    try {
      // First compress the image
      File compressedFile = await ImageCompressionService.compressImage(context, file);

      // Then recognize objects
      return await recognize(context, compressedFile);
    } catch (e) {
      debugPrint("Error in compress and recognize: $e");
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

  /// Perform local object detection using ML Kit when cloud services are unavailable
  static Future<String> _simulateLocalObjectDetection(BuildContext context, File file) async {
    try {
      debugPrint("Using ML Kit for local image labeling");

      // Use ML Kit to get actual image labels
      final labels = await LocalImageLabelingService.labelImage(file);

      // Format the results using the helper method
      return LocalImageLabelingService.formatLabelsAsString(labels);
    } catch (e) {
      debugPrint("Error in local image labeling: $e");

      // If ML Kit fails, fall back to the original simulation method
      // This is just a backup in case ML Kit has issues
      final buffer = StringBuffer();
      buffer.writeln("Image Analysis Results:");
      buffer.writeln();
      buffer.writeln("• Could not analyze image locally");
      buffer.writeln();
      buffer.writeln("Note: There was an error processing your image with the local analyzer.");

      return buffer.toString();
    }
  }
}
