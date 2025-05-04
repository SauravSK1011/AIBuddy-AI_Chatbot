import 'package:flutter/material.dart';

import 'widgets/background.dart';

import 'Constants/MyColors.dart';
import 'Constants/MyFontSizes.dart';
import 'Screens/ImageRecognition.dart';
import 'Screens/WebPageSummary.dart';
import 'Screens/fileSummary.dart';
import 'Screens/ocr.dart';
import 'Screens/LocalQuestionAnsweringScreen.dart';
import 'widgets/box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}




class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Initialize the ML Kit image labeler
    _initializeMLServices();
  }

  @override
  void dispose() {
    // Clean up ML Kit resources
    _disposeMLServices();
    super.dispose();
  }

  // Initialize ML Kit services
  void _initializeMLServices() {
    // Nothing to initialize for the image labeler as it's created on demand
    debugPrint('ML Kit services initialized');
  }

  // Dispose ML Kit services
  void _disposeMLServices() {
    // Clean up resources
    try {
      // This will be called when the app is closed
      debugPrint('Cleaning up ML Kit resources');
    } catch (e) {
      debugPrint('Error disposing ML Kit resources: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;


    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            background(screenW, screenH),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                width: screenW,
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
                        width: screenW,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        // AI Features Section
                        Container(
                          width: screenW / 1.2,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withAlpha(100),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "AI Features",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),

                              // Chat Interface
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LocalQuestionAnsweringScreen(),
                                    ),
                                  );
                                },
                                child: boxw(screenW, screenH, "ai-application.png", "Chat Interface", "Talk with AI assistant"),
                              ),
                              const SizedBox(height: 15),

                              // Image Recognition
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ImageRecognition(),
                                    ),
                                  );
                                },
                                child: boxw(screenW, screenH, "picture.png", "Image Recognition", "Identify objects in images"),
                              ),
                              const SizedBox(height: 15),

                              // URL Summarization
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const WebPageSummary(),
                                    ),
                                  );
                                },
                                child: boxw(screenW, screenH, "web-link.png", "URL Summarization", "Summarize web content"),
                              ),
                              const SizedBox(height: 15),

                              // OCR
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const OcrScreen(),
                                    ),
                                  );
                                },
                                child: boxw(screenW, screenH, "camera.png", "OCR", "Extract text from images"),
                              ),
                              const SizedBox(height: 15),

                              // File Summary
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FileSummary(),
                                    ),
                                  );
                                },
                                child: boxw(screenW, screenH, "file-and-folder.png", "File Summary", "Summarize document content"),
                              ),
                            ],
                          ),
                        ),

                        // Add padding at the bottom for better scrolling
                        const SizedBox(height: 30),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



