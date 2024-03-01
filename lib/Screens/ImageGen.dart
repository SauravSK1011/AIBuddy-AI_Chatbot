import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../Constants/MyColors.dart';
import '../Constants/MyFontSizes.dart';
import '../Services/ImageGenServices.dart';
import '../widgets/background.dart';

class ImageGen extends StatefulWidget {
  const ImageGen({super.key});

  @override
  State<ImageGen> createState() => _ImageGenState();
}

class _ImageGenState extends State<ImageGen> {
  @override
  List imagelist = [];
  var imageData;
  bool load1 = true;
  bool loded = true;
  TextEditingController promptController = TextEditingController();
  Widget build(BuildContext context) {
    double screen_w = MediaQuery.of(context).size.width;
    double screen_h = MediaQuery.of(context).size.height;
    String textinput = "Type a Prompt";

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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
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
                  SizedBox(
                    height: screen_h / 40,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "AI Image Generator",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: imagelist.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15.0)),
                                  ),
                                  // height: MyFontSizes.appnamesize + 25,
                                  width: screen_w,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Image.memory(Uint8List.fromList(
                                            imagelist[index])),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              // ImageGenServices1.saveImage(
                                              //     context, imagelist[index]);
                                              var rng = Random();

                                              FileStorage.writeCounter(
                                                  imagelist[index],
                                                  "${rng.nextInt(100)}.png",
                                                  context);
                                            },
                                            child: Icon(
                                              Icons.download,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  SizedBox(
                    height: 100,
                  )
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
                  width: screen_w,
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
                          setState(() {
                            load1 = false;
                          });
                          FocusManager.instance.primaryFocus?.unfocus();
                          promptController.clear();

                          imageData = await ImageGenServices1.generateimage(
                              context, textinput);
                          imagelist.add(imageData);

                          setState(() {
                            load1 = true;
                          });
                        },
                        child: load1
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
