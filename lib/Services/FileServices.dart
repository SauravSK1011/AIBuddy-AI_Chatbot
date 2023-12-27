import "dart:io";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;

class FileServices {
  static Future<String> myfilesummary(BuildContext context, File file) async {
    try {
      print("file");
      print(file.path);
      String question = "generate summary of this text";
      var request = http.MultipartRequest(
          "POST", Uri.parse('https://ssk333.pythonanywhere.com/upload'));
      request.fields['question'] = question;
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
          style: TextStyle(
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
