import 'package:flutter/material.dart';
import '../Constants/MyFontSizes.dart';
import '../Services/LocalQuestionAnsweringService.dart';
import '../widgets/background.dart';

class LocalQuestionAnsweringScreen extends StatefulWidget {
  const LocalQuestionAnsweringScreen({super.key});

  @override
  State<LocalQuestionAnsweringScreen> createState() => _LocalQuestionAnsweringScreenState();
}

class _LocalQuestionAnsweringScreenState extends State<LocalQuestionAnsweringScreen> {
  final TextEditingController _contextController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  String _answer = '';
  bool _isProcessing = false;

  @override
  void dispose() {
    _contextController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  void _processQuestion() {
    final contextText = _contextController.text;
    final questionText = _questionController.text;

    if (contextText.isEmpty || questionText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide both context and question')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Use a small delay to show the processing state
    Future.delayed(const Duration(milliseconds: 500), () {
      final answer = LocalQuestionAnsweringService.answerQuestion(contextText, questionText);

      setState(() {
        _answer = answer;
        _isProcessing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                  // App header
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                      ),
                      height: MyFontSizes.appnamesize + 25,
                      width: screenWidth,
                      child: Center(
                        child: Text(
                          "AIBuddy",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MyFontSizes.appnamesize
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight / 40),

                  // Screen title
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Local Question Answering",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Main content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Context input
                          const Text(
                            "Context:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _contextController,
                            maxLines: 5,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Enter the text context here...",
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Question input
                          const Text(
                            "Question:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _questionController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Ask a question about the context...",
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send, color: Colors.white),
                                onPressed: _processQuestion,
                              ),
                            ),
                            onSubmitted: (_) => _processQuestion(),
                          ),

                          const SizedBox(height: 30),

                          // Answer section
                          if (_isProcessing)
                            const Center(child: CircularProgressIndicator())
                          else if (_answer.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.deepPurple.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Answer:",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _answer,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 20),

                          // Example section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Example:",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Context: Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase. Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Question: What is Flutter?",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    _contextController.text = "Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase. Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.";
                                    _questionController.text = "What is Flutter?";
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text("Use Example"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
