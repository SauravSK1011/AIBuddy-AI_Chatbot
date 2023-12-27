import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../Constants/MyColors.dart';
import '../Constants/MyFontSizes.dart';
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
  @override
  List convertation = [];
  bool loded = true;
  int lodedsreen = 0;
  late File file;
  void getfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }
    String summery = await OcrServices.gettext(context, file);
    convertation.add(summery);
    setState(() {
      lodedsreen = 1;
    });
  }

  Widget build(BuildContext context) {
    double screen_w = MediaQuery.of(context).size.width;
    double screen_h = MediaQuery.of(context).size.height;
    String textinput = "";
    TextEditingController promptController = TextEditingController();
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
                          child: boxw(screen_w + screen_w / 1.5, screen_h - 100,
                              "add.png", "Add Image", ""),
                        )
                      : Container(),
                  lodedsreen == 1
                      ? Expanded(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  OpenFilex.open(file.path);
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
                                                Colors.white.withOpacity(0.2),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15.0)),
                                          ),
                                          // height: MyFontSizes.appnamesize + 25,
                                          width: screen_w,
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
                              )
                            ],
                          ),
                        )
                      : lodedsreen == 2
                          ? Center(child: CircularProgressIndicator())
                          : Center(),
                ]),
          ),
        lodedsreen==2||lodedsreen==1  ?Align(
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a Prompt',
                        ),
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
          ):Container()
        ],
      ),
    ));
  }
}
