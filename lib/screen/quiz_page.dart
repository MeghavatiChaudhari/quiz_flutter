import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz/controllers/Score_controller.dart';

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.put(QuizController());

    return Scaffold(
      backgroundColor: Colors.grey[900],
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: GetX<QuizController>(
            builder: (controller) {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.questions.value.isEmpty) {
                return const Center(
                  child: Text(
                    "Failed to load questions",
                    style: TextStyle(color: Colors.redAccent, fontSize: 20),
                  ),
                );
              } else {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          '${controller.timer.value}s',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 1),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.white,
                            blurRadius: 8.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Question ${controller.index.value + 1}',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            controller.questions.value['results']
                                [controller.index.value]['question'],
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 19.0,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      flex: 9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.shuffledAnswers
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
                                onPressed: () {
                                  controller.checkAnswer(
                                      answer,
                                      controller.questions.value['results']
                                              [controller.index.value]
                                          ['correct_answer']);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 12.0),
                                  backgroundColor: Colors.grey[800],
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
                                  constraints:
                                      const BoxConstraints(minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      if (controller.selectedAnswer.value !=
                                          null)
                                        Icon(
                                          answer ==
                                                  controller.correctAnswer.value
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          color: Colors.white,
                                        ),
                                      const SizedBox(width: 8),
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
                      ),
                    ),
                    const Spacer(flex: 1),
                    controller.index.value ==
                            controller.questions.value['results'].length - 1
                        ? ElevatedButton.icon(
                            onPressed: () {
                              Get.toNamed('/view_score');
                              controller.index.value = 0;
                              controller.selectedAnswer.value = null;
                            },
                            icon: const Icon(Icons.send, color: Colors.white),
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
                              padding: const EdgeInsets.symmetric(
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
                            onPressed: controller.selectedAnswer.value != null
                                ? () {
                                    controller.nextQuestion(controller
                                        .questions.value['results'].length);
                                    controller.startTimer();
                                    controller.selectedAnswer.value = null;
                                  }
                                : null,
                            icon: const Icon(Icons.navigate_next,
                                color: Colors.white),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 25.0),
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              elevation: 5,
                              shadowColor: Colors.black26,
                            ),
                          ),
                    const SizedBox(
                        height: 70), // Additional space at the bottom
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
