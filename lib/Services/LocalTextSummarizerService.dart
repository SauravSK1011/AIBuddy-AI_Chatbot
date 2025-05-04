

class LocalTextSummarizerService {
  /// Summarize text using a simple extractive algorithm
  /// This is a basic implementation of the TextRank algorithm
  static String summarizeText(String text, {int maxSentences = 5}) {
    if (text.isEmpty) {
      return '';
    }

    // Split text into sentences
    final sentences = _splitIntoSentences(text);

    if (sentences.length <= maxSentences) {
      return text; // Return original text if it's already short enough
    }

    // Calculate sentence scores based on word frequency
    final wordFrequency = _calculateWordFrequency(text);
    final sentenceScores = _scoreSentences(sentences, wordFrequency);

    // Get top sentences
    final topSentenceIndices = _getTopSentenceIndices(sentenceScores, maxSentences);

    // Sort indices to maintain original order
    topSentenceIndices.sort();

    // Build summary
    final summary = topSentenceIndices.map((i) => sentences[i]).join(' ');

    return summary;
  }

  /// Split text into sentences
  static List<String> _splitIntoSentences(String text) {
    // Simple sentence splitting by punctuation
    final sentenceEnders = RegExp(r'[.!?]');
    final sentences = text.split(sentenceEnders)
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim() + '.')
        .toList();

    return sentences;
  }

  /// Calculate word frequency in the text
  static Map<String, int> _calculateWordFrequency(String text) {
    // Convert to lowercase and remove punctuation
    final cleanText = text.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');

    // Split into words
    final words = cleanText.split(RegExp(r'\s+'));

    // Count word frequency
    final wordFrequency = <String, int>{};
    for (final word in words) {
      if (word.isNotEmpty && !_isStopWord(word)) {
        wordFrequency[word] = (wordFrequency[word] ?? 0) + 1;
      }
    }

    return wordFrequency;
  }

  /// Score sentences based on word frequency
  static List<double> _scoreSentences(List<String> sentences, Map<String, int> wordFrequency) {
    final scores = <double>[];

    for (final sentence in sentences) {
      final words = sentence.toLowerCase().split(RegExp(r'\s+'));
      var score = 0.0;

      for (final word in words) {
        final cleanWord = word.replaceAll(RegExp(r'[^\w]'), '');
        if (cleanWord.isNotEmpty && !_isStopWord(cleanWord)) {
          score += wordFrequency[cleanWord] ?? 0;
        }
      }

      // Normalize by sentence length to avoid bias towards longer sentences
      score = words.isNotEmpty ? score / words.length : 0;
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
