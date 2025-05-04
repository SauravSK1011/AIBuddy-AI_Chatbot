

class LocalQuestionAnsweringService {
  /// Answer a question based on the provided context
  /// This is a simple implementation that uses keyword matching and sentence relevance
  static String answerQuestion(String context, String question) {
    if (context.isEmpty || question.isEmpty) {
      return 'Please provide both context and question.';
    }

    // Preprocess the question and context
    final processedQuestion = _preprocessText(question);
    final sentences = _splitIntoSentences(context);

    if (sentences.isEmpty) {
      return 'Unable to find an answer in the provided context.';
    }

    // Extract keywords from the question
    final questionKeywords = _extractKeywords(processedQuestion);

    // Score sentences based on relevance to the question
    final sentenceScores = _scoreSentencesByRelevance(sentences, questionKeywords);

    // Get the most relevant sentences
    final topSentenceIndices = _getTopSentenceIndices(sentenceScores, 3);
    final relevantSentences = topSentenceIndices.map((i) => sentences[i]).toList();

    // Determine the answer type based on the question
    final answerType = _determineAnswerType(processedQuestion);

    // Generate the answer
    return _generateAnswer(relevantSentences, questionKeywords, answerType);
  }

  /// Preprocess text by converting to lowercase and removing extra whitespace
  static String _preprocessText(String text) {
    return text.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Split text into sentences
  static List<String> _splitIntoSentences(String text) {
    // Simple sentence splitting by punctuation
    final sentenceEnders = RegExp(r'[.!?]');
    final sentences = text.split(sentenceEnders)
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .toList();

    return sentences;
  }

  /// Extract keywords from text by removing stop words
  static List<String> _extractKeywords(String text) {
    // Convert to lowercase and remove punctuation
    final cleanText = text.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');

    // Split into words
    final words = cleanText.split(RegExp(r'\s+'));

    // Filter out stop words
    final keywords = words.where((word) => !_isStopWord(word) && word.isNotEmpty).toList();

    return keywords;
  }

  /// Score sentences based on relevance to the question keywords
  static List<double> _scoreSentencesByRelevance(List<String> sentences, List<String> questionKeywords) {
    final scores = <double>[];

    for (final sentence in sentences) {
      final sentenceWords = _extractKeywords(sentence);
      var score = 0.0;

      // Count matching keywords
      for (final keyword in questionKeywords) {
        if (sentenceWords.contains(keyword)) {
          score += 1.0;
        }
      }

      // Normalize by the number of keywords
      score = questionKeywords.isNotEmpty ? score / questionKeywords.length : 0;

      scores.add(score);
    }

    return scores;
  }

  /// Get indices of top scoring sentences
  static List<int> _getTopSentenceIndices(List<double> scores, int maxSentences) {
    // Create a list of (index, score) pairs
    final indexedScores = List<Map<String, dynamic>>.generate(
      scores.length,
      (i) => {'index': i, 'score': scores[i]},
    );

    // Sort by score (descending)
    indexedScores.sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));

    // Get indices of top sentences
    return indexedScores
        .take(maxSentences)
        .map((item) => item['index'] as int)
        .toList();
  }

  /// Determine the type of answer expected based on the question
  static String _determineAnswerType(String question) {
    if (question.startsWith('what is') || question.startsWith('what are')) {
      return 'definition';
    } else if (question.startsWith('how to')) {
      return 'procedure';
    } else if (question.startsWith('why')) {
      return 'explanation';
    } else if (question.startsWith('when')) {
      return 'time';
    } else if (question.startsWith('where')) {
      return 'location';
    } else if (question.startsWith('who')) {
      return 'person';
    } else {
      return 'general';
    }
  }

  /// Generate an answer based on relevant sentences and question type
  static String _generateAnswer(List<String> relevantSentences, List<String> questionKeywords, String answerType) {
    if (relevantSentences.isEmpty) {
      return 'I couldn\'t find information related to your question in the provided context.';
    }

    // Join the relevant sentences
    final combinedAnswer = relevantSentences.join(' ');

    // Add an appropriate prefix based on the answer type
    switch (answerType) {
      case 'definition':
        return 'Based on the context, $combinedAnswer';
      case 'procedure':
        return 'The process involves: $combinedAnswer';
      case 'explanation':
        return 'The reason is: $combinedAnswer';
      case 'time':
        return 'According to the context: $combinedAnswer';
      case 'location':
        return 'The location mentioned is: $combinedAnswer';
      case 'person':
        return 'The person referred to is: $combinedAnswer';
      default:
        return combinedAnswer;
    }
  }

  /// Check if a word is a stop word (common words with little meaning)
  static bool _isStopWord(String word) {
    const stopWords = {
      'a', 'an', 'the', 'and', 'or', 'but', 'is', 'are', 'was', 'were',
      'in', 'on', 'at', 'to', 'for', 'with', 'by', 'about', 'of',
      'this', 'that', 'these', 'those', 'it', 'its', 'they', 'them',
      'their', 'he', 'she', 'his', 'her', 'i', 'me', 'my', 'we', 'us', 'our',
      'you', 'your', 'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would',
      'shall', 'should', 'can', 'could', 'may', 'might', 'must', 'be', 'been',
      'being', 'as', 'if', 'then', 'else', 'when', 'where', 'why', 'how',
      'all', 'any', 'both', 'each', 'few', 'more', 'most', 'some', 'such',
      'no', 'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very',
    };

    return stopWords.contains(word.toLowerCase());
  }
}
