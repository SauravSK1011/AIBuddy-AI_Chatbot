import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class CameraService {
  static Future<File?> takePhoto(BuildContext context) async {
    try {
      // Request camera permission if needed
      // This is handled internally by image_picker

      // Initialize image picker
      final ImagePicker picker = ImagePicker();

      // Take a picture
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // Adjust quality as needed
      );

      if (photo != null) {
        // On web, we need to handle XFile differently
        if (kIsWeb) {
          // For web, we create a dummy File object
          // In a real implementation, you would handle the XFile data differently
          return File(photo.path);
        } else {
          return File(photo.path);
        }
      } else {
        // User canceled the camera
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image was captured'),
          ),
        );
        return null;
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accessing camera: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint('Error taking photo: $e');
      return null;
    }
  }

  // Alternative method to pick from gallery if needed
  static Future<File?> pickFromGallery(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        // On web, we need to handle XFile differently
        if (kIsWeb) {
          // For web, we create a dummy File object
          // In a real implementation, you would handle the XFile data differently
          return File(image.path);
        } else {
          return File(image.path);
        }
      } else {
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image was selected'),
          ),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accessing gallery: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint('Error picking from gallery: $e');
      return null;
    }
  }
}
