import 'dart:io';

import 'package:flutter/material.dart';

import '../Constants/MyColors.dart';
import '../Constants/MyFontSizes.dart';
import '../Services/CameraService.dart';
import '../Services/FileServices.dart';
import '../Services/WebServices.dart';
import '../widgets/background.dart';
import '../widgets/box.dart';

class FileSummary extends StatefulWidget {
  const FileSummary({super.key});

  @override
  State<FileSummary> createState() => _FileSummaryState();
}

class _FileSummaryState extends State<FileSummary> {
  List convertation = [];
  bool loded = true;
  int lodedsreen = 0;

  late File file;
  void getfile() async {
    // Use camera to take a photo
    File? capturedImage = await CameraService.takePhoto(context);

    if (capturedImage != null) {
      file = capturedImage;
      setState(() {
        lodedsreen = 2; // Show loading indicator
      });

      // Process the image with File Summary service using compression
      String summery = await FileServices.compressAndSendSummary(context, file);
      convertation.add(summery);

      setState(() {
        lodedsreen = 1; // Show results
      });
    } else {
      // User canceled or there was an error
      setState(() {
        lodedsreen = 0; // Return to initial state
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No image was captured. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    TextEditingController promptController = TextEditingController();
    String textinput = "";
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          background(screenWidth, screenHeight),
          Container(
            width: screenWidth,
            height: screenHeight,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51), // 0.2 opacity = 51 alpha
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                      ),
                      height: MyFontSizes.appnamesize + 25,
                      width: screenWidth,
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
                  SizedBox(
                    height: screenHeight / 40,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "File Summary",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  lodedsreen == 0
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              lodedsreen = 2;
                            });
                            getfile();
                          },
                          child: boxw(screenWidth + screenWidth / 1.5, screenHeight - 100,
                              "camera.png", "Take Photo", ""),
                        )
                      : Container(),
                  lodedsreen == 1
                      ? Expanded(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  // OpenFilex.open(file.path) is disabled due to compatibility issues
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('File opening is disabled due to compatibility issues'),
                                    ),
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.file_copy,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        file.path.substring(51),
                                        style: TextStyle(
                                            color: Mycolors.textcolor,
                                            fontSize: MyFontSizes.textsixe),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: convertation.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withAlpha(51), // 0.2 opacity = 51 alpha
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15.0)),
                                          ),
                                          // height: MyFontSizes.appnamesize + 25,
                                          width: screenWidth,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  index % 2 == 1
                                                      ? Icons.person
                                                      : Icons.smart_toy,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    convertation[index],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: MyFontSizes
                                                            .textsixe),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              SizedBox(
                                height: 100,
                              ),
                            ],
                          ),
                        )
                      : lodedsreen == 2
                          ? Center(child: CircularProgressIndicator())
                          : Center(),
                ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  width: screenWidth,
                  height: 75,
                  child: Row(children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(hintText: "Enter Prompt"),
                        controller: promptController,
                        onChanged: (text) {
                          textinput = text;
                        },
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () async {
                          promptController.clear();
                          convertation.add(textinput);
                          setState(() {
                            loded = false;
                          });
                          String output = "";
                          if (convertation.length == 1 ||
                              convertation[convertation.length - 1]
                                  .toString()
                                  .contains("www")) {
                            output = await WebServices.websummary2(
                                context, textinput);
                          } else {
                            String text = "";

                            if (convertation[0].toString().length > 3000) {
                              text = convertation[0].toString().substring(
                                  convertation[0].toString().length - 3000);
                            } else {
                              text = convertation[0].toString();
                            }

                            output = await WebServices.webferthercon(context,
                                text, convertation[convertation.length - 1]);
                          }

                          convertation.add(output);

                          setState(() {
                            loded = true;
                          });
                        },
                        child: loded
                            ? Icon(
                                Icons.send,
                                color: Colors.black,
                              )
                            : CircularProgressIndicator()),
                    SizedBox(
                      width: 10,
                    )
                  ]),
                )),
          )
        ],
      ),
    ));
  }
}
