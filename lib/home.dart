import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'widgets/background.dart';

import 'Constants/MyColors.dart';
import 'Constants/MyFontSizes.dart';
import 'Screens/ImageGen.dart';
import 'Screens/ImageRecognition.dart';
import 'Screens/WebPageSummary.dart';
import 'Screens/fileSummary.dart';
import 'Screens/ocr.dart';
import 'widgets/box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}




class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    double screen_w = MediaQuery.of(context).size.width;
    double screen_h = MediaQuery.of(context).size.height;


    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            background(screen_w, screen_h),
            Container(
              width: screen_w,
              height: screen_h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                      ),
                      height: MyFontSizes.appnamesize + 25,
                      width: screen_w,
                      child: Center(
                        child: Text(
                          MyStr.appname,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: MyFontSizes.appnamesize),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: screen_w / 15,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WebPageSummary()),
                              );
                            },
                            child: boxw(screen_w, screen_h, "web-link.png",
                                "Web Page Summary", ""),
                          ),
                          SizedBox(
                            width: screen_w / 15,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ImageRecognition()),
                              );
                            },
                            child: boxw(screen_w, screen_h, "picture.png",
                                "Image Recognition", ""),
                          ),
                          SizedBox(
                            width: screen_w / 15,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: screen_w / 15,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const OcrScreen()),
                                );
                              },
                              child: boxw(
                                  screen_w, screen_h, "camera.png", "Text to Image", "")),
                          SizedBox(
                            width: screen_w / 15,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FileSummary()),
                              );
                            },
                            child: boxw(screen_w, screen_h,
                                "file-and-folder.png", "Files Summary", ""),
                          ),
                          SizedBox(
                            width: screen_w / 15,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ImageGen()),
                          );
                        },
                        child: boxwlong(screen_w, screen_h,
                            "ai-application.png", "Image Generator", ""),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Widget boxwlong(double screenW, double screenH, String imageName,
    String oprationName, String description) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withAlpha(50),
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
    ),
    width: screenW / 1.2,
    height: screenH / 7.5,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 10,
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
        )
      ],
    ),
  );
}
