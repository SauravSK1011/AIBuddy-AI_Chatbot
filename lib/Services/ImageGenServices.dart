import "dart:io";
import "dart:typed_data";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:permission_handler/permission_handler.dart";
import 'SimplePathProvider.dart';

class ImageGenServices1 {
  static Future<Uint8List> generateimage(
      BuildContext context, String prompt) async {
    try {
      print("prompt");
      print(prompt);
      var map = new Map<String, dynamic>();
      map['prompt'] = prompt;
      http.Response res = await http.post(
          Uri.parse('https://ssk333.pythonanywhere.com/generateimage'),
          body: map);
      print("res.body");
      final image = res.bodyBytes;
      return image;
    } catch (e) {
      Uint8List a = Uint8List.fromList([10, 1]);

      var message = e.toString();
      ScaffoldMessengerState().showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFe91e63),
      ));
      return a;
    }
  }
}

class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      final path = await SimplePathProvider.getTemporaryDirectory();
      _directory = Directory(path);
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<void> writeCounter(
      dynamic imageData, String name, BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final path = await _localPath;
      // Create a file for the path of
      // device and file name with extension
      File file = File('$path/$name');
      print("Save file");
      file.writeAsBytes(imageData);
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          "file Saved as $name",
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFe91e63),
      ));
      // Write the data in the file you have created
    } catch (e) {
      var message = e.toString();
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFe91e63),
      ));
    }
  }
}
