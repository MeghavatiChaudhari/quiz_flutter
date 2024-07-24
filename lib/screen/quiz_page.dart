import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz/services/api_services.dart';
import 'package:quiz/controllers/Score_controller.dart';
import 'package:quiz/screen/view_score.dart';

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
      var data = await ApiServices().Question(5);
      if (data != null) {
        quizController.questions.value = data;
        quizController.isLoading.value = false;
        quizController.shuffleAnswers(); // Shuffle answers initially
        quizController.startTimer();
      }
    } catch (e) {
      print("Error: $e");
      quizController.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Obx(() {
            if (quizController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else if (quizController.questions.value.isEmpty) {
              return Center(
                child: Text(
                  "Failed to load questions",
                  style: TextStyle(color: Colors.redAccent, fontSize: 20),
                ),
              );
            } else {
              return Column(
                children: [
                  SizedBox(height: 10),
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timer, color: Colors.white, size: 24),
                        SizedBox(width: 8),
                        Text(
                          '${quizController.timer.value}s',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  }),
                  Spacer(flex: 1),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Obx(() {
                      return Column(
                        children: [
                          Text(
                            'Question ${quizController.index.value + 1}',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            quizController.questions.value['results']
                                [quizController.index.value]['question'],
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 19.0,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    flex: 9,
                    child: Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: quizController.shuffledAnswers
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          String answer = entry.value;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                onPressed: quizController
                                            .selectedAnswer.value ==
                                        null
                                    ? () {
                                        quizController.checkAnswer(
                                            answer,
                                            quizController.questions.value[
                                                        'results']
                                                    [quizController.index.value]
                                                ['correct_answer']);
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 12.0),
                                  backgroundColor: quizController
                                              .selectedAnswer.value !=
                                          null
                                      ? (answer ==
                                              quizController.correctAnswer.value
                                          ? Colors.green
                                          : (quizController
                                                      .selectedAnswer.value ==
                                                  answer
                                              ? Colors.red
                                              : Colors.grey[800]))
                                      : Colors.grey[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  elevation: 5,
                                  shadowColor: Colors.black26,
                                  textStyle: GoogleFonts.roboto(
                                    fontSize: 18.0,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                child: Container(
                                  constraints: BoxConstraints(minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      if (quizController.selectedAnswer.value !=
                                          null)
                                        Icon(
                                          answer ==
                                                  quizController
                                                      .correctAnswer.value
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          color: Colors.white,
                                        ),
                                      SizedBox(width: 8),
                                      Text(
                                        '${index + 1}. $answer',
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ),
                  Spacer(flex: 1),
                  Obx(() {
                    return quizController.index.value ==
                            quizController.questions.value['results'].length - 1
                        ? ElevatedButton.icon(
                            onPressed: () {
                              print('submit button is pressed');
                              try {
                                Get.toNamed('/view_score');
                                quizController.index.value = 0;
                                quizController.selectedAnswer.value = null;
                              } catch (e) {
                                print('error occurred $e');
                              }
                            },
                            icon: Icon(Icons.send, color: Colors.white),
                            label: Text(
                              'Submit',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1,
                                fontSize: 18.0,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 25.0),
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              elevation: 5,
                              shadowColor: Colors.black26,
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: quizController.selectedAnswer.value !=
                                    null
                                ? () {
                                    quizController.nextQuestion(quizController
                                        .questions.value['results'].length);
                                    quizController.startTimer();
                                    quizController.selectedAnswer.value = null;
                                  }
                                : null,
                            icon:
                                Icon(Icons.navigate_next, color: Colors.white),
                            label: Text(
                              'Next',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1,
                                fontSize: 18.0,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 25.0),
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              elevation: 5,
                              shadowColor: Colors.black26,
                            ),
                          );
                  }),
                  SizedBox(height: 70), // Additional space at the bottom
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
