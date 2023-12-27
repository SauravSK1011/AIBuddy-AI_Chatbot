import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;

class WebServices {
  static Future<String> websummary2(BuildContext context, String url) async {
    try {
      print("url");
      print(url);
      var map = new Map<String, dynamic>();
      map['url'] = url;
      http.Response res = await http
          .post(Uri.parse('https://ssk333.pythonanywhere.com/url'), body: map);
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

  static Future<String> webferthercon(
      BuildContext context, String text, String question) async {
    try {
      print("text");
      print(text);
      var map = new Map<String, dynamic>();
      map['question'] = question + " give ins in 50 words";
      map['text'] = text;

      http.Response res = await http
          .post(Uri.parse('https://ssk333.pythonanywhere.com/qna'), body: map);
      print("res.body");
      print(res.body);
      String ans = jsonDecode(res.body)["ans"];
      print(ans);
      return ans;
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
