import 'dart:io';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class OcrServices {
  static Future<String> gettext(BuildContext context, File file) async {
    try {
      print("file");
      print(file.path);
      var request = http.MultipartRequest(
          "POST", Uri.parse('https://ssk333.pythonanywhere.com/ocr'));
      request.files.add(http.MultipartFile(
          'file',
          File(file.path).readAsBytes().asStream(),
          File(file.path).lengthSync(),
          filename: file.path.split("/").last));
      var res = await request.send();

      print("res.body");
      var abc = await res.stream.bytesToString();
      print(abc);
      return abc;
    } catch (e) {
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
        backgroundColor: Color(0xFFe91e63),
      ));
      return e.toString();
    }
  }
}
