import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/services/api_services.dart';
import 'package:quiz/controllers/Score_controller.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizController quizController = Get.put(QuizController());

  @override
  void initState() {
    getQuizQuestions();
    super.initState();
  }

  Future<void> getQuizQuestions() async {
    try {
      var data = await ApiServices().Question(10);
      if (data != null) {
        quizController.questions.value = data;
        quizController.isLoading.value = false;
      }
    } catch (e) {
      print("Error: $e");
      quizController.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.lightBlueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Obx(() {
            if (quizController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else if (quizController.questions.value.isEmpty) {
              return Center(
                child: Text(
                  "Failed to load questions",
                  style: TextStyle(color: Colors.redAccent, fontSize: 18),
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Obx(() {
                      return Text(
                        'Question ${quizController.index.value + 1}: ${quizController.questions.value['results'][quizController.index.value]['question']}',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }),
                  ),
                  SizedBox(height: 30),
                  Obx(() {
                    List<String> answers = List.from(
                        quizController.questions.value["results"]
                            [quizController.index.value]["incorrect_answers"]);
                    answers.add(quizController.questions.value['results']
                        [quizController.index.value]['correct_answer']);
                    answers.shuffle();
                    return Column(
                      children: answers.map((answer) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              quizController.checkAnswer(
                                  answer,
                                  quizController.questions.value['results']
                                          [quizController.index.value]
                                      ['correct_answer']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text(
                              answer,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  SizedBox(height: 30),
                  Obx(() => Text(
                        'Score: ${quizController.score.value}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(height: 20),
                  Obx(() {
                    return quizController.index.value ==
                            quizController.questions.value['results'].length - 1
                        ? ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Quiz Completed'),
                                  content: Text(
                                      'Your score is ${quizController.score.value}'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        quizController.resetScore();
                                        quizController.index.value = 0;
                                      },
                                      child: Text('Restart Quiz'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              quizController.nextQuestion(quizController
                                  .questions.value['results'].length);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                  }),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
