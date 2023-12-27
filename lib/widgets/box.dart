import 'package:flutter/material.dart';

import '../Constants/MyColors.dart';
import '../Constants/MyFontSizes.dart';

Widget boxw(double screenW, double screenH, String imageName,
    String oprationName, String description) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
    ),
    width: screenW / 2.5,
    height: screenH / 5,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Image.asset("assets/images/$imageName", width: screenW / 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            oprationName,
            style: TextStyle(
                color: Mycolors.textcolor, fontSize: MyFontSizes.titletextsize),
          ),
        ),
        Text(
          description,
          style: TextStyle(
              color: Mycolors.textcolor, fontSize: MyFontSizes.textsixe),
        ),
      ],
    ),
  );
}
