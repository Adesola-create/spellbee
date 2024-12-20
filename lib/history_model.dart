import 'dart:convert';

class QuizHistory {
  final String date;
  final String grade;
  final String module;
  final double percentScore;
  final int length;
  bool sentStatus;
  int timeSpent; 

  QuizHistory({
    required this.date,
    required this.grade,
    required this.module,
    required this.percentScore,
    required this.length,
    this.sentStatus = false,
    required this.timeSpent,
  });

  // Convert to Map for saving
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'grade': grade,
      'module': module,
      'percentScore': percentScore,
      'length': length,
      'sentStatus': sentStatus,
      'timeSpent': timeSpent,
    };
  }

  // Create from Map for reading
  factory QuizHistory.fromMap(Map<String, dynamic> map) {
    return QuizHistory(
      date: map['date'],
      grade: map['grade'],
      module: map['module'],
      percentScore: map['percentScore'],
      length: map['length'],
      sentStatus: map['sentStatus'],
      timeSpent: map['timeSpent'],
    );
  }

  // Encode as JSON string
  String toJson() => json.encode(toMap());

  // Decode from JSON string
  factory QuizHistory.fromJson(String source) =>
      QuizHistory.fromMap(json.decode(source));
}
