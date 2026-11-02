class GrammarCheckerService {
  static Map<String, dynamic> check(String text) {
    String corrected = text;

    List<String> suggestions = [];

    if (corrected.contains("My name ")) {
      corrected = corrected.replaceFirst(
        "My name ",
        "My name is ",
      );

      suggestions.add("Add 'is' after 'My name'.");
    }

    if (corrected.contains("I live ")) {
      corrected = corrected.replaceFirst(
        "I live ",
        "I live in ",
      );

      suggestions.add("Add 'in' before your location.");
    }

    double score = 10;

    score -= suggestions.length * 1.0;

    if (score < 5) {
      score = 5;
    }

    return {
      "original": text,
      "corrected": corrected,
      "score": score,
      "suggestions": suggestions,
    };
  }
}