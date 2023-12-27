import 'dart:ui';

import 'package:flutter/material.dart';

Widget background(double screen_w, double screen_h) {
  return Stack(
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(left: 200),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade700, Colors.orange.shade500],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(100)),
          ),
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(right: 270),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade700, Colors.orange.shade500],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(100)),
          )
        ],
      ),
      Center(
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              width: screen_w,
              height: screen_h,
              decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.shade200.withOpacity(0.1)),
            ),
          ),
        ),
      ),
    ],
  );
}
