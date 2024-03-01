import 'dart:ui';

import 'package:flutter/material.dart';

import '../Constants/MyColors.dart';
import '../Constants/MyFontSizes.dart';
import '../Services/WebServices.dart';
import '../widgets/background.dart';

class WebPageSummary extends StatefulWidget {
  const WebPageSummary({super.key});

  @override
  State<WebPageSummary> createState() => _WebPageSummaryState();
}

class _WebPageSummaryState extends State<WebPageSummary> {
  @override
  List convertation = [];
  bool loded = true;
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
                  Expanded(
                    child: ListView.builder(
                        itemCount: convertation.length,
                        itemBuilder: (context, index) {
                          return Padding(
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
                                child: Row(
                                  children: [
                                    Icon(
                                      index % 2 == 0
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
                                            fontSize: MyFontSizes.textsixe),
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
                        decoration: InputDecoration(hintText: "Enter Url"),
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

                            if (convertation[1].toString().length > 3000) {
                              text = convertation[1].toString().substring(
                                  convertation[1].toString().length - 3000);
                            } else {
                              text = convertation[1].toString();
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
