import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  Map<String, dynamic> statistics = {};

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final stats = await computeStatistics();
    setState(() {
      statistics = stats;
    });
  }

  Future<Map<String, dynamic>> computeStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    final historyData = prefs.getStringList('quizHistoryLog') ?? [];
    final List<Map<String, dynamic>> quizHistory =
        historyData.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

    final DateTime today = DateTime.now();
    //final past30Days = now.subtract(const Duration(days: 30));
    final DateTime past30Days = today.subtract(const Duration(days: 30));

    // Initialize statistics
    int totalTimeSpent = 0;
    double highestScore = double.negativeInfinity;
    double lowestScore = double.infinity;
    double totalScore = 0;
    int totalEntries = quizHistory.length;
    Set<String> uniqueGradeModules = {};
    Set<String> uniqueGradeWords = {};
    int totalWords = 0;
    List<DateTime> entryDates = [];

    double calculatePercentage(int x) {
      if (x < 0 || x > 30) {
        throw ArgumentError("x must be between 0 and 30.");
      }
      double y = (30 - x) / 30 * 100;

      return y;
    }

    double calculateSpeedPercentage(int x) {
      double y = x - 60;
      if (y <= 0) {
        y = 0;
      }
      if (y >= 100) {
        y = 90;
      }
      double z = (100 - y) / 100;
      // print('Yes $z');
      return z;
    }

    double calculateGradePercentage(int x) {
      if (x >= 1000) {
        x = 1000;
      }
      return (x / 1000);
    }

    for (final quiz in quizHistory) {
      totalTimeSpent += (quiz['timeSpent'] ?? 0) as int;

      highestScore = quiz['percentScore'] > highestScore
          ? quiz['percentScore']
          : highestScore;
      lowestScore = quiz['percentScore'] < lowestScore
          ? quiz['percentScore']
          : lowestScore;
      totalScore += quiz['percentScore'];
      uniqueGradeModules.add('${quiz['grade']}-${quiz['module']}');
      uniqueGradeWords
          .add('${quiz['grade']}-${quiz['module']}-${quiz['length']}');
      totalWords += (quiz['length'] ?? 0) as int;

      // Collect dates for consistency calculation
      entryDates.add(DateTime.parse(quiz['date']));
    }

    int totalLength = 0;
    for (String entry in uniqueGradeWords) {
      // Split the entry into components (grade, module, length)
      List<String> parts = entry.split('-');

      // Extract the length part and convert it to an integer
      if (parts.length == 3) {
        int length = int.tryParse(parts[2]) ?? 0;
        totalLength += length;
      }
    }

//print("Total Length: $totalLength");

    // Calculate average time spent per quiz
    int averageTime = totalEntries > 0 ? (totalTimeSpent ~/ totalEntries) : 0;

    // Calculate average score
    double averageScore = totalEntries > 0 ? (totalScore / totalEntries) : 0.0;

    // Calculate consistency (absent days in the last 30 days)
// Step 1: Filter dates within the past 30 days

// Filter quiz entries to include only those within the past 30 days
    List<DateTime> filteredDates = entryDates
        .where((date) => date.isAfter(past30Days) && date.isBefore(today))
        .toList();

// Step 2: Find the earliest date within the 30-day range
    DateTime startDate = filteredDates.isEmpty
        ? past30Days
        : filteredDates.reduce((a, b) => a.isBefore(b) ? a : b);

// Step 3: Generate all dates between the earliest date and today
    List<String> allDaysInRange = List.generate(
      today.difference(startDate).inDays + 2,
      (index) => startDate
          .add(Duration(days: index))
          .toIso8601String()
          .split('T')
          .first,
    );

// Step 4: Extract unique quiz entry days
    Set<String> uniqueDaysWithEntries = filteredDates
        .map((date) => date.toIso8601String().split('T').first)
        .toSet();

// Step 5: Calculate absent days
    int consistency = allDaysInRange.length - uniqueDaysWithEntries.length;

// Debugging/Logging
//print("All days in range: $allDaysInRange");
//print("Unique quiz days: $uniqueDaysWithEntries");
//print("Absent days: $consistency");
    //void main() {
    double percentageConsist = calculatePercentage(consistency) / 100;
    double speedPercentage = calculateSpeedPercentage(averageTime);
    double gradePercentage = calculateGradePercentage(totalLength);

    double averageAttempt = totalEntries / uniqueGradeModules.length;

    //}
    String consistencyRemark = 'Fantastic Commitment';
    if (percentageConsist < 0.5) {
      consistencyRemark = 'Keep Practicing';
    } else if (percentageConsist < 0.75) {
      consistencyRemark = 'Good Job';
    }
    String performanceRemark =
        'Well done! Great performance, keep up the good work!';
    if (averageScore < 50) {
      performanceRemark =
          'Keep practicing regularly, you have the potential to improve!';
    } else if (averageScore < 75) {
      performanceRemark =
          'Good job! With more effort, you can achieve even better results!';
    }

    String speedRemark =
        'Well done! Great performance, your speed is impressive!';
    if (averageScore < 50) {
      speedRemark =
          'Keep practicing regularly, you have the potential to improve!';
    } else if (averageScore < 75) {
      speedRemark =
          'Great! With more effort, you can achieve even better results!';
    }

    return {
      'totalTimeSpent': totalTimeSpent,
      'averageTime': averageTime,
      'highestScore': highestScore,
      'lowestScore': lowestScore,
      'averageScore': averageScore,
      'totalEntries': totalEntries,
      'uniqueGradeModules': uniqueGradeModules.length,
      'totalWords': totalWords,
      'uniqueGradeWords': totalLength,
      'consistency': percentageConsist,
      'consistencydays': consistency,
      'consistencyRemark': consistencyRemark,
      'performanceRemark': performanceRemark,
      'speedRemark': speedRemark,
      'speedPercentage': speedPercentage,
      'gradePercentage': gradePercentage,
      'averageAttempt': averageAttempt
    };
  }

  @override
  Widget build(BuildContext context) {
   // print('yes ${statistics['speedPercentage']}');
   // double number = statistics['gradePercentage'] * 100;
   // double roundedNumber = 0.0;//double.parse(number.toStringAsFixed(1));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Dark background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Learning Insight',
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: statistics.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Overall Score Display
                    Center(
                      child: CircularPercentIndicator(
                        radius: 108.0,
                        lineWidth: 18.0,
                        percent: (statistics['averageScore'] ?? 0) / 100,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${statistics['averageScore']?.toStringAsFixed(1) ?? "0"}%",
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Overall Score",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        progressColor: Colors.purple,
                        backgroundColor: Colors.grey[400]!,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    ),

                    const SizedBox(height: 34),
                    // Statistics Cards
                    SizedBox(
                      height: 100,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            StatisticsCard(
                                title: "Total Time",
                                value:
                                    "${(statistics['totalTimeSpent'] ~/ 60)} min"),
                            StatisticsCard(
                                title: "Average Time",
                                value: "${statistics['averageTime']} sec"),
                            StatisticsCard(
                                title: "High Score",
                                value:
                                    "${statistics['highestScore']?.toStringAsFixed(1) ?? "0"}%"),
                            StatisticsCard(
                                title: "Low Score",
                                value:
                                    "${statistics['lowestScore']?.toStringAsFixed(1) ?? "0"}%"),
                            StatisticsCard(
                                title: "Total Words",
                                value: "${statistics['totalWords']}"),
                            StatisticsCard(
                                title: "Unique Words",
                                value: "${statistics['uniqueGradeWords']}"),
                            StatisticsCard(
                                title: "Total Entries",
                                value: "${statistics['totalEntries']}"),
                            StatisticsCard(
                                title: "Unique Modules",
                                value: "${statistics['uniqueGradeModules']}"),
                            StatisticsCard(
                                title: "Average Attempts",
                                value:
                                    "${double.parse(statistics['averageAttempt'].toStringAsFixed(1))}"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FeedbackCard(
                      title: "Practice Consistency",
                      description:
                          "${statistics['consistencyRemark']}! You have missed ${statistics['consistencydays']} days within the last 30 days.",
                      percentage: statistics['consistency'],
                      percentageText:
                          "${(statistics['consistency'] * 100).toInt()}%",
                      progressColor: Colors.orange,
                    ),
                    FeedbackCard(
                      title: "Learning Performance",
                      description: "${statistics['performanceRemark']}",
                      percentage: statistics['averageScore'] / 100,
                      percentageText:
                          "${statistics['averageScore'].toInt() ?? "0"}%",
                      progressColor: Colors.redAccent,
                    ),
                    FeedbackCard(
                      title: "Quiz Speed",
                      description: "${statistics['speedRemark']}",
                      percentage: statistics['speedPercentage'],
                      percentageText:
                          "${(statistics['speedPercentage'] * 100).toInt()}%",
                      progressColor: Colors.green,
                    ),

                    FeedbackCard(
                      title: "Grade Progress",
                      description:
                          "You have completed ${statistics['uniqueGradeWords']} grade words out of 1,000 total words",
                      percentage: statistics['gradePercentage'],
                      percentageText: "${statistics['gradePercentage'].toStringAsFixed(1)}%",
                      progressColor: Colors.blue,
                    ),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ),
    );
  }
}

// Statistics Card Widget
class StatisticsCard extends StatelessWidget {
  final String title;
  final String value;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      margin: const EdgeInsets.only(right: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Feedback Card Widget
class FeedbackCard extends StatelessWidget {
  final String title;
  final String description;
  final double percentage;
  final String percentageText;
  final Color progressColor;

  const FeedbackCard({
    super.key,
    required this.title,
    required this.description,
    required this.percentage,
    required this.percentageText,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color:  Colors.grey[200], // Card background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Circular Progress Indicator
            CircularPercentIndicator(
              radius: 36.0,
              lineWidth: 8.0,
              percent: percentage,
              center: Text(
                percentageText,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              progressColor: progressColor,
              backgroundColor: Colors.grey[500]!,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(width: 12.0),

            // Feedback Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 14,
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
