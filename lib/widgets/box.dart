import 'package:flutter/material.dart';

import '../Constants/MyColors.dart';
import '../Constants/MyFontSizes.dart';

Widget boxw(double screenW, double screenH, String imageName,
    String oprationName, String description) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
    ),
    width: screenW / 2.5,
    height: screenH / 5,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        Image.asset("assets/images/$imageName",
          width: screenW / 8,
          height: screenH / 15,
          fit: BoxFit.contain,
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            oprationName,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Mycolors.textcolor, fontSize: MyFontSizes.titletextsize),
          ),
        ),
        if (description.isNotEmpty)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    color: Mycolors.textcolor, fontSize: MyFontSizes.textsixe),
              ),
            ),
          ),
      ],
    ),
  );
}
