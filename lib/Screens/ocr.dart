import 'dart:io';

import 'package:flutter/material.dart';

import '../Constants/MyColors.dart';
import '../Constants/MyFontSizes.dart';
import '../Services/CameraService.dart';
import '../Services/OcrServices.dart';
import '../Services/WebServices.dart';
import '../widgets/background.dart';
import '../widgets/box.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key});

  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
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

      // Process the image with OCR using compression
      String summery = await OcrServices.compressAndOcr(context, file);
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
    String textinput = "";
    TextEditingController promptController = TextEditingController();
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
                      "Image To Text",
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
                          child: boxw(screenWidth, screenHeight / 4,
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
                                        file.path.substring(53),
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
                              // Add padding at the bottom to prevent overlap with the input bar
                              const SizedBox(
                                height: 70,
                              )
                            ],
                          ),
                        )
                      : lodedsreen == 2
                          ? const Center(child: CircularProgressIndicator())
                          : const Center(),
                ]),
          ),
        lodedsreen==2||lodedsreen==1 ? SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  width: screenWidth,
                  height: 60, // Reduced height
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type a Prompt',
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                            ),
                            controller: promptController,
                            onChanged: (text) {
                              textinput = text;
                            },
                          ),
                        )
                      ),
                      const SizedBox(width: 5),
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
                            ? const Icon(
                                Icons.send,
                                color: Colors.black,
                              )
                            : const CircularProgressIndicator()
                      ),
                      const SizedBox(width: 10),
                    ]
                  ),
                )
              ),
            ),
          ) : Container()
        ],
      ),
    ));
  }
}
