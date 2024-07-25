import 'package:get/get.dart';
import 'dart:async';
import 'package:quiz/services/api_services.dart';

class QuizController extends GetxController {
  var score = 0.obs;
  var index = 0.obs;
  var isLoading = true.obs;
  Rx<Map<String, dynamic>> questions = Rx<Map<String, dynamic>>({});
  Rx<int> timer = 30.obs;
  Timer? _timer;
  Rx<String?> selectedAnswer = Rx<String?>(null);
  Rx<String> correctAnswer = Rx<String>('');
  RxList<String> shuffledAnswers = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
    getQuizQuestions();
  }

  Future<void> getQuizQuestions() async {
    try {
      var data = await ApiServices().Question(5);
      if (data != null) {
        questions.value = data;
        isLoading.value = false;
        shuffleAnswers(); // Shuffle answers initially
        startTimer();
      }
    } catch (e) {
      print("Error: $e");
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load questions');
    }
  }

  void startTimer() {
    timer.value = 30; // Resetting timer
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (this.timer.value > 0) {
        this.timer.value--;
      } else {
        nextQuestion(questions.value['results'].length);
        this.timer.value = 30; // Resetting timer
      }
    });
  }

  void increaseScore() {
    score++;
  }

  void resetScore() {
    score.value = 0;
  }

  void checkAnswer(String selectedAnswer, String correctAnswer) {
    this.selectedAnswer.value = selectedAnswer;
    this.correctAnswer.value = correctAnswer;

    if (selectedAnswer == correctAnswer) {
      increaseScore();
    }
  }

  void nextQuestion(int totalQuestions) {
    if (index < totalQuestions - 1) {
      index++;
      shuffleAnswers(); // Shuffle answers for the next question
    } else {
      index.value = 0;
      resetScore();
      shuffleAnswers(); // Shuffle answers for the first question
      startTimer(); // Restart timer for the first question
    }
  }

  void shuffleAnswers() {
    List<String> answers =
        List.from(questions.value['results'][index.value]['incorrect_answers']);
    answers.add(questions.value['results'][index.value]['correct_answer']);
    answers.shuffle();
    shuffledAnswers.value = answers;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
