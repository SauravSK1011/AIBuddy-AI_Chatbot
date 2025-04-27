// import 'package:file_picker/file_picker.dart';

// class FilePickerService {
//   static Future<List<String>?> pickFiles({
//     FileType type = FileType.any,
//     List<String>? allowedExtensions,
//     bool allowMultiple = false,
//   }) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: type,
//         allowedExtensions: allowedExtensions,
//         allowMultiple: allowMultiple,
//       );

//       if (result != null) {
//         return result.paths.where((path) => path != null).map((path) => path!).toList();
//       }
//       return null;
//     } catch (e) {
//       print('Error picking files: $e');
//       return null;
//     }
//   }
// }
