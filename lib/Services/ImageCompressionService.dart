import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class ImageCompressionService {
  /// Compresses an image to be under 1MB
  static Future<File> compressImage(BuildContext context, File imageFile) async {
    try {
      // Get the original file size in KB
      int originalSizeKB = await imageFile.length() ~/ 1024;
      debugPrint('Original image size: $originalSizeKB KB');

      // If the image is already under 1MB, return it directly
      if (originalSizeKB < 1024) {
        debugPrint('Image already under 1MB, no compression needed');
        return imageFile;
      }

      // Get file extension
      String extension = path.extension(imageFile.path).toLowerCase();
      bool isJpeg = extension == '.jpg' || extension == '.jpeg';

      // Create a temporary file path for the compressed image
      String dir = path.dirname(imageFile.path);
      String newPath = path.join(dir, 'compressed_${path.basename(imageFile.path)}');

      // If not JPEG, convert to JPEG for better compression
      if (!isJpeg) {
        // Read the image file
        List<int> imageBytes = await imageFile.readAsBytes();
        img.Image? decodedImage = img.decodeImage(Uint8List.fromList(imageBytes));

        if (decodedImage != null) {
          // Encode as JPEG
          List<int> jpegBytes = img.encodeJpg(decodedImage, quality: 90);

          // Create a new file with JPEG extension
          newPath = path.join(dir, 'compressed_${path.basenameWithoutExtension(imageFile.path)}.jpg');
          File jpegFile = File(newPath);
          await jpegFile.writeAsBytes(jpegBytes);

          // Update the file reference
          imageFile = jpegFile;
          isJpeg = true;
        }
      }

      // Start with quality 90 and reduce if needed
      int quality = 90;
      File? compressedFile;

      // Try compressing with decreasing quality until file size is under 1MB
      while (quality >= 10) {
        compressedFile = await _compressImage(imageFile, newPath, quality);

        // Check the size of the compressed file
        int compressedSizeKB = await compressedFile.length() ~/ 1024;
        debugPrint('Compressed image size with quality $quality: $compressedSizeKB KB');

        if (compressedSizeKB < 1024) {
          // File is under 1MB, we can use it
          return compressedFile;
        }

        // Reduce quality and try again
        quality -= 10;
      }

      // If we couldn't compress enough with quality adjustments, try resizing
      compressedFile = await _resizeAndCompressImage(imageFile, newPath);

      return compressedFile;
    } catch (e) {
      debugPrint('Error in compressImage: $e');
      _showErrorSnackBar(context, e.toString());
      return imageFile; // Return original if compression fails
    }
  }
  /// Compresses an image to be under 1MB for OCR processing
  /// This method is kept for backward compatibility but now just returns the compressed image
  static Future<File> compressForOCR(BuildContext context, File imageFile) async {
    try {
      // Simply compress the image and return the file
      return await compressImage(context, imageFile);
    } catch (e) {
      debugPrint('Error in compressForOCR: $e');
      _showErrorSnackBar(context, e.toString());
      return imageFile; // Return original if compression fails
    }
  }

  /// Compresses an image with the specified quality
  static Future<File> _compressImage(File file, String targetPath, int quality) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      format: CompressFormat.jpeg,
    );

    return File(result!.path);
  }

  /// Resizes and compresses an image to reduce its file size
  static Future<File> _resizeAndCompressImage(File file, String targetPath) async {
    // Read the image file
    List<int> imageBytes = await file.readAsBytes();
    img.Image? decodedImage = img.decodeImage(Uint8List.fromList(imageBytes));

    if (decodedImage == null) {
      return file; // Return original if decoding fails
    }

    // Calculate new dimensions (reduce by 50%)
    int newWidth = decodedImage.width ~/ 2;
    int newHeight = decodedImage.height ~/ 2;

    // Resize the image
    img.Image resizedImage = img.copyResize(
      decodedImage,
      width: newWidth,
      height: newHeight,
    );

    // Encode as JPEG with low quality
    List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 70);

    // Write to file
    File compressedFile = File(targetPath);
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
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
