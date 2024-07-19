import 'package:flutter/material.dart';
import 'package:quiz/services/api_services.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Map<String, dynamic>? QuestionInfo;
  bool isLoading = true;
  int index = 0;

  Future<void> getQuizQuestions() async {
    try {
      var data = await ApiServices().Question(10);
      setState(() {
        QuestionInfo = data;
        print(QuestionInfo);
        isLoading = false;
      });
    } catch (e) {
      print("error is $e");
      isLoading = false;
    }
  }

  void nextQuestion() {
    setState(() {
      if (index < QuestionInfo!["results"].length - 1) {
        index++;
      } else {
        index = 0;
      }
    });
  }

  List<String> getOptions() {
    List<String> answers =
        List.from(QuestionInfo!["results"][index]["incorrect_answers"]);
    answers.add(QuestionInfo!['results'][index]['correct_answer']);

    answers.shuffle();
    return answers;
  }

  void initState() {
    getQuizQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : QuestionInfo == null
              ? Center(child: Text("Failed to load questions"))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Question ${index + 1}: ${QuestionInfo!["results"][index]["question"]}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: getOptions().map((answer) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: Text(
                                answer,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
