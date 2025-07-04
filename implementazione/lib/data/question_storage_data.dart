class QuestionStorage {
  static final List<Map<String, String>> baseQuestions = [
    {
      "text": "Come hanno costruito il Colosseo i romani?",
      "period": "Impero Romano",
    },
    {
      "text": "Come hanno costruito il Foro i romani?",
      "period": "Impero Romano",
    },
    {"text": "Dove è nato Giulio Cesare?", "period": "Impero Romano"},
  ];

  static final Map<String, List<Map<String, String>>> _classQuestions = {};

  static List<Map<String, String>> getQuestionsForClass(String className) {
    if (!_classQuestions.containsKey(className)) {
      _classQuestions[className] = List.from(baseQuestions);
    }
    return _classQuestions[className]!;
  }

  static void updateQuestionsForClass(
    String className,
    List<Map<String, String>> updatedQuestions,
  ) {
    _classQuestions[className] = updatedQuestions;
  }
}
