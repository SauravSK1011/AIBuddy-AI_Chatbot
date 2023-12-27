import 'dart:io';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:cloudinary/cloudinary.dart';

class ImageRecognitionServices {
  static Future<String> Recognize(BuildContext context, File file) async {
    try {
      final cloudinary = Cloudinary.signedConfig(
        apiKey: "538483726846567",
        apiSecret: "pN4v-PM_tmbzdirmEkcqYU19hCI",
        cloudName: "dm77rbalw",
      );
      final response = await cloudinary.upload(
          file: file.path,
          fileBytes: file.readAsBytesSync(),
          resourceType: CloudinaryResourceType.image,
          folder: "chatfolio-image",
          fileName: 'some-name',
          progressCallback: (count, total) {
            print('Uploading image from file with progress: $count/$total');
          });
      print(response.secureUrl);

      var map = new Map<String, dynamic>();
      map['imageurl'] = response.secureUrl;
      http.Response res = await http.post(
          Uri.parse('https://ssk333.pythonanywhere.com/imagerecognition'),
          body: map);
      print("res.body");
      print(res.body);
      return res.body;
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
