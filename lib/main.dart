import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:quiz/screen/home_page.dart';
import 'package:get/get.dart';
import 'package:quiz/screen/view_score.dart';
import 'package:quiz/screen/quiz_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'quiz app',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      getPages: [
        GetPage(name: '/quiz', page: () => QuizPage()),
        GetPage(name: '/view_score', page: () => ViewScore()),
      ],
    );
  }
}
