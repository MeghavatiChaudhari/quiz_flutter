import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizController extends GetxController {
  var score = 0.obs;
  var index = 0.obs;
  var isLoading = true.obs;
  Rx<Map<String, dynamic>> questions = Rx<Map<String, dynamic>>({});

  void increaseScore() {
    score++;
  }

  void decreaseScore() {
    if (score > 0) {
      score--;
    }
  }

  void resetScore() {
    score.value = 0;
  }

  void checkAnswer(String selectedAnswer, String correctAnswer) {
    if (selectedAnswer == correctAnswer) {
      increaseScore();
    } else {
      decreaseScore();
    }
  }

  void nextQuestion(int totalQuestions) {
    if (index < totalQuestions - 1) {
      index++;
    } else {
      index.value = 0;
      resetScore();
    }
  }
}
