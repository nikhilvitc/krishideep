class FAQ {
  final String id;
  final String question;
  final String questionHindi;
  final String answer;
  final String answerHindi;
  final String category;

  FAQ({
    required this.id,
    required this.question,
    required this.questionHindi,
    required this.answer,
    required this.answerHindi,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'questionHindi': questionHindi,
      'answer': answer,
      'answerHindi': answerHindi,
      'category': category,
    };
  }

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'],
      question: json['question'],
      questionHindi: json['questionHindi'],
      answer: json['answer'],
      answerHindi: json['answerHindi'],
      category: json['category'],
    );
  }
}
